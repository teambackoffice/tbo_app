import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class CreateProjectService {
  final String url =
      '${ApiConstants.baseUrl}project_planning_api.update_project_planning';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String> createProject({
    required String planningId,
    required String planningName,
    required String lead,
    required String leadSegment,
    required String projectType,
    required String status,
    required String planningDate,
    required int estimatedDuration,
    required double estimatedCost,
    required String plannedStartDate,
    required String plannedEndDate,
    required List<Map<String, dynamic>> resourceRequirements,
  }) async {
    try {
      // 🔑 Read SID
      final sid = await _secureStorage.read(key: 'sid');
      if (sid == null) throw Exception("SID not found. Please login again.");

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      };

      final body = json.encode({
        "planning_id": planningId,
        "planning_name": planningName,
        "lead": lead,
        "lead_segment": leadSegment,
        "project_type": projectType,
        "status": status,
        "planning_date": planningDate,
        "estimated_duration": estimatedDuration,
        "estimated_cost": estimatedCost,
        "planned_start_date": plannedStartDate,
        "planned_end_date": plannedEndDate,
        "resource_requirements": resourceRequirements, // keep as List<Map>
      });

      // 🧠 Print Request Details
      print("🔹 API Request URL: $url");
      print("🔹 Request Headers: $headers");
      print("🔹 Request Body: $body");

      final request = http.Request('POST', Uri.parse(url))
        ..headers.addAll(headers)
        ..body = body;

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      // 🧾 Print Response Details
      print("🔸 Response Status Code: ${response.statusCode}");
      print("🔸 Response Headers: ${response.headers}");
      print("🔸 Response Body: $responseBody");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Project planning updated successfully.");
        return responseBody;
      } else {
        print("❌ Failed to update project planning.");
        throw Exception(
          "Status: ${response.statusCode}, Reason: ${response.reasonPhrase}, Body: $responseBody",
        );
      }
    } catch (e, stack) {
      print("🚨 Exception occurred: $e");
      print("🚨 Stack Trace: $stack");
      throw Exception("Failed to update project planning: $e");
    }
  }
}
