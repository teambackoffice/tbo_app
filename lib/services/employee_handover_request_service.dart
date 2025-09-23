import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class TaskHandoverService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> createTaskHandoverRequest({
    required String fromEmployee,
    required String toEmployee,
    required String task,
    required String handoverReason,
    required String handoverNotes,
    required String handoverType,
    String? leaveStartDate,
    String? leaveEndDate,
  }) async {
    try {
      // 🔹 Read SID
      final sid = await _secureStorage.read(key: 'sid');

      if (sid == null) {
        throw Exception("Session ID not found");
      }

      // 🔹 Build URI
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}task_assignment_api.create_task_handover_request'
        '?from_employee=$fromEmployee'
        '&to_employee=$toEmployee'
        '&task=$task'
        '&handover_reason=$handoverReason'
        '&handover_notes=$handoverNotes'
        '&handover_type=$handoverType'
        '${leaveStartDate != null ? '&leave_start_date=$leaveStartDate' : ''}'
        '${leaveEndDate != null ? '&leave_end_date=$leaveEndDate' : ''}',
      );

      // 🔹 Setup request
      final request = http.Request('POST', uri);
      request.headers['Cookie'] = 'sid=$sid';
      request.headers['Content-Type'] = 'application/json';

      // 🔹 Send request
      final response = await request.send();

      // 🔹 Read response
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final decoded = json.decode(responseBody);
        return decoded;
      } else {
        throw Exception("Error: ${response.reasonPhrase}, Body: $responseBody");
      }
    } catch (e, stack) {
      rethrow;
    }
  }
}
