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
    required String employeeTask,
    required String handoverReason,
    required String handoverNotes,
    required String handoverType,
    String? leaveStartDate,
    String? leaveEndDate,
  }) async {
    try {
      print("🔹 Starting createTaskHandoverRequest...");

      // Read session ID
      final sid = await _secureStorage.read(key: 'sid');
      print("📦 SID: $sid");

      if (sid == null) {
        throw Exception("Session ID not found");
      }

      // Build the request URL
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}task_assignment_api.create_task_handover_request'
        '?from_employee=$fromEmployee'
        '&to_employee=$toEmployee'
        '&task=$task'
        '&employee_task=$employeeTask'
        '&handover_reason=$handoverReason'
        '&handover_notes=$handoverNotes'
        '&handover_type=$handoverType'
        '${leaveStartDate != null ? '&leave_start_date=$leaveStartDate' : ''}'
        '${leaveEndDate != null ? '&leave_end_date=$leaveEndDate' : ''}',
      );

      print("🌐 Request URL: $uri");

      // Setup request
      final request = http.Request('POST', uri);
      request.headers['Cookie'] = 'sid=$sid';
      request.headers['Content-Type'] = 'application/json';

      print("🧾 Headers: ${request.headers}");

      // Send request
      final response = await request.send();
      print("📨 Response status: ${response.statusCode}");

      // Read response body
      final responseBody = await response.stream.bytesToString();
      print("📦 Raw Response Body: $responseBody");

      // Parse response
      if (response.statusCode == 200) {
        final decoded = json.decode(responseBody);
        print("✅ Decoded Response: $decoded");
        return decoded;
      } else {
        print("❌ Error Response: ${response.reasonPhrase}");
        print("❌ Response Body: $responseBody");
        throw Exception("Error: ${response.reasonPhrase}, Body: $responseBody");
      }
    } catch (e, stack) {
      print("💥 Exception occurred: $e");
      print("🧩 Stack Trace: $stack");
      rethrow;
    }
  }
}
