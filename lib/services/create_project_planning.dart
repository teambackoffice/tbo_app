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
    final sid = await _secureStorage.read(key: 'sid');

    if (sid == null) {
      throw Exception("Session ID not found in storage");
    }

    var headers = {'Content-Type': 'application/json', 'Cookie': ' sid=$sid;'};

    var body = jsonEncode({
      "planning_name": planningName,
      "lead_segment": leadSegment,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode != 201) {
        throw Exception('Failed: ${response.reasonPhrase}');
      }

      return response.body; // 🔥 CHANGE: Return the response body
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
