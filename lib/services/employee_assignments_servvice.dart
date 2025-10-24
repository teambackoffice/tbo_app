import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';
import 'package:tbo_app/modal/employee_assignment_modal.dart';

class EmployeeAssignmentsService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<EmployeeAssignments> fetchemployeeassignments({
    required String projectId,
  }) async {
    final String baseUrl =
        '${ApiConstants.baseUrl}task_assignment_api.get_employee_assignments';

    try {
      final String? sid = await _secureStorage.read(key: 'sid');

      if (sid == null) {
        throw Exception('Authentication required. Please login again.');
      }

      // 🔹 Add only project_id as query param
      final uri = Uri.parse(
        baseUrl,
      ).replace(queryParameters: {'project': projectId});

      print("📡 Request URL: $uri");
      print("📦 Request Headers: {Cookie: sid=$sid}");

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json', 'Cookie': 'sid=$sid'},
      );

      print("✅ Status Code: ${response.statusCode}");
      print("📥 Raw Response Body: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final decoded = jsonDecode(response.body);
          print("🔍 Decoded JSON: $decoded");

          final employeeAssignments = EmployeeAssignments.fromJson(decoded);

          // 🔥 Print details from your modal (adjust based on your model fields)
          for (var emp in employeeAssignments.data) {
            print("👤 Employee Assignment: ${emp.toJson()}");
          }

          return employeeAssignments;
        } catch (e) {
          throw Exception('Failed to parse response: $e');
        }
      } else {
        throw Exception(
          'Failed to load employee assignments. Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("❌ Error: $e");
      throw Exception('Network error: $e');
    }
  }
}
