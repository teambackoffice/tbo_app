import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class EditTaskService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> editTask({
    required String taskId,
    required String project,
    required String subject,
    required String status,
    required String priority,
  }) async {
    try {
      final sid = await _secureStorage.read(key: 'sid');

      if (sid == null) {
        throw Exception("Session ID (sid) not found in storage");
      }

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      };

      final request = http.Request(
        'POST',
        Uri.parse(
          '${ApiConstants.baseUrl}/tbo_smart.mobile_api.project_api.edit_task',
        ),
      );

      final bodyData = {
        "task_id": taskId,
        "project": project,
        "subject": subject,
        "status": status,
        "priority": priority,
      };

      request.body = json.encode(bodyData);
      request.headers.addAll(headers);

      // 🔹 Print request info
      print("---- Edit Task API Request ----");
      print("URL: ${request.url}");
      print("Headers: ${request.headers}");
      print("Body: ${request.body}");
      print("-------------------------------");

      final response = await request.send();

      final responseData = await response.stream.bytesToString();

      // 🔹 Print response info
      print("---- Edit Task API Response ----");
      print("Status Code: ${response.statusCode}");
      print("Reason Phrase: ${response.reasonPhrase}");
      print("Response Body: $responseData");
      print("--------------------------------");

      if (response.statusCode == 200) {
        return json.decode(responseData);
      } else {
        throw Exception("Failed to edit task: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❌ Exception in EditTaskService: $e");
      rethrow;
    }
  }
}
