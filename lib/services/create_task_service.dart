import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class CreateTaskService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final String url = '${ApiConstants.baseUrl}project_api.create_task';

  Future<String?> _getToken() async {
    return await _storage.read(key: "sid");
  }

  Future<Map<String, dynamic>?> createTask({
    required String project,
    required String subject,
    required String assignedEmployee,
    required String priority,
    required String description,
    required String expStartDate,
    required String expEndDate,
    required String status,
  }) async {
    try {
      String? sid = await _getToken();

      if (sid == null) {
        throw Exception("Token not found");
      }

      var headers = {
        'Cookie': 'sid=$sid',
        'Content-Type': 'application/json',
        "Authorization": "token $sid",
      };

      var body = jsonEncode({
        "project": project,
        "subject": subject,
        "custom_assigned_employee": assignedEmployee,
        "priority": priority,
        "description": description,
        "exp_start_date": expStartDate,
        "exp_end_date": expEndDate,
        "status": status,
      });

      print("🔹 CREATE TASK API CALL");
      print("🔹 URL: $url");
      print("🔹 Headers: $headers");
      print("🔹 Request Body: $body");

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print("🔸 Status Code: ${response.statusCode}");
      print("🔸 Raw Response Body: ${response.body}");

      if (response.body.isNotEmpty) {
        try {
          final decoded = jsonDecode(response.body);
          print("✅ Decoded Response: $decoded");
        } catch (e) {
          print("❌ JSON Decode Error: $e");
        }
      }

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic> &&
            decoded.containsKey('message') &&
            decoded['message'] is Map<String, dynamic>) {
          final message = decoded['message'];
          if (message['success'] == false) {
            String errorMsg = message['error'] ?? 'Unknown error';
            // Remove HTML tags for cleaner error display
            errorMsg = errorMsg.replaceAll(RegExp(r'<[^>]*>'), '');
            throw errorMsg;
          }
        }

        return decoded;
      } else {
        throw Exception(
          "Failed with status ${response.statusCode}: ${response.body}",
        );
      }
    } catch (e) {
      print("❌ Create Task Exception: $e");
      rethrow;
    }
  }
}
