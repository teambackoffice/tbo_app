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
      // Read SID
      final sid = await _secureStorage.read(key: 'sid');
      print("🔑 SID: $sid");

      if (sid == null) {
        print("❌ SID not found");
        throw Exception("SID not found. Please login again.");
      }

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      };

      print("📌 Headers: $headers");

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
        "resource_requirements": resourceRequirements,
      });

      print("📦 Body: $body");
      print("📨 URL: $url");

      final request = http.Request('POST', Uri.parse(url))
        ..headers.addAll(headers)
        ..body = body;

      print("🚀 Sending request...");

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("📥 Response Code: ${response.statusCode}");
      print("📥 Response Body: $responseBody");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Request Successful!");
        return responseBody;
      } else {
        print("❌ Error Response: ${response.reasonPhrase}");
        throw Exception(
          "Status: ${response.statusCode}, Reason: ${response.reasonPhrase}, Body: $responseBody",
        );
      }
    } catch (e, stack) {
      print("🔥 Exception: $e");
      print("📌 StackTrace: $stack");
      throw Exception("Failed to update project planning: $e");
    }
  }
}
