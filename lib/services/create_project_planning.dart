import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class CreateProjectPlanningService {
  final String url =
      '${ApiConstants.baseUrl}project_planning_api.create_project_planning';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String> createProjectPlanning({
    required String planningName,
    required String leadSegment,
  }) async {
    try {
      // 🔑 Read SID for authentication
      final sid = await _secureStorage.read(key: 'sid');

      if (sid == null) {
        throw Exception("Session ID not found in storage");
      }

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      };

      final body = jsonEncode({
        "planning_name": planningName,
        "lead_segment": leadSegment,
      });

      // 🧠 Log request details
      print('🔹 API Request URL: $url');
      print('🔹 Request Headers: $headers');
      print('🔹 Request Body: $body');

      // 🚀 Send request
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      // 🧾 Log response details
      print('🔸 Response Status Code: ${response.statusCode}');
      print('🔸 Response Headers: ${response.headers}');
      print('🔸 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Project Planning Created Successfully.');
        return response.body;
      } else {
        print('❌ Failed to Create Project Planning.');
        throw Exception(
          'Status: ${response.statusCode}, Reason: ${response.reasonPhrase}, Body: ${response.body}',
        );
      }
    } catch (e, stack) {
      print('🚨 Exception occurred while creating project planning: $e');
      print('🚨 Stack Trace: $stack');
      throw Exception('Error while creating project planning: $e');
    }
  }
}
