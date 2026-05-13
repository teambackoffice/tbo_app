import 'dart:convert';

import 'package:flutter/material.dart';
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
    required String expectedTime,
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
        "expected_time": expectedTime,
        "custom_estimated_hours": expectedTime,
      });

      // =========================
      // PRINT REQUEST DETAILS
      // =========================
      debugPrint("========== CREATE TASK API ==========");
      debugPrint("URL: $url");

      debugPrint("HEADERS:");
      headers.forEach((key, value) {
        debugPrint("$key : $value");
      });

      debugPrint("BODY:");
      debugPrint(body);

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      // =========================
      // PRINT RESPONSE DETAILS
      // =========================
      debugPrint("========== RESPONSE ==========");
      debugPrint("STATUS CODE: ${response.statusCode}");
      debugPrint("RESPONSE BODY:");
      debugPrint(response.body);

      if (response.body.isNotEmpty) {
        try {
          final decoded = jsonDecode(response.body);

          debugPrint("DECODED RESPONSE:");
          debugPrint(decoded.toString());
        } catch (e) {
          debugPrint("JSON DECODE ERROR: $e");
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

            // Remove HTML tags
            errorMsg = errorMsg.replaceAll(RegExp(r'<[^>]*>'), '');

            debugPrint("API ERROR: $errorMsg");

            throw errorMsg;
          }
        }

        debugPrint("TASK CREATED SUCCESSFULLY");

        return decoded;
      } else {
        throw Exception(
          "Failed with status ${response.statusCode}: ${response.body}",
        );
      }
    } catch (e) {
      debugPrint("CREATE TASK EXCEPTION: $e");
      rethrow;
    }
  }
}
