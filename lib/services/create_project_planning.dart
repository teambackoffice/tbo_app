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

      // 🚀 Send request
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        throw Exception(
          'Status: ${response.statusCode}, Reason: ${response.reasonPhrase}, Body: ${response.body}',
        );
      }
    } catch (e, stack) {
      throw Exception('Error while creating project planning: $e');
    }
  }
}
