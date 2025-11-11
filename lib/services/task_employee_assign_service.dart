import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class TaskEmployeeAssignService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> updateAssignmentEmployees({
    required String assignmentId,
    required List<Map<String, dynamic>> taskAssignments,
    required List<Map<String, dynamic>> subTaskAssignments,
  }) async {
    try {
      // Get sid from secure storage
      final sid = await _secureStorage.read(key: "sid");
      if (sid == null) {
        throw Exception("Session expired. Please login again.");
      }

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      };

      final body = json.encode({
        "assignment_id": assignmentId,
        "task_assignments": taskAssignments,
        "sub_task_assignments": subTaskAssignments,
      });

      final url = Uri.parse(
        '${ApiConstants.baseUrl}task_assignment_api.update_assignment_employees',
      );

      final request = http.Request('POST', url);
      request.body = body;
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final decoded = json.decode(respStr);
        return decoded;
      } else {
        throw Exception("Failed: ${response.reasonPhrase}");
      }
    } catch (e, stack) {
      rethrow;
    }
  }
}
