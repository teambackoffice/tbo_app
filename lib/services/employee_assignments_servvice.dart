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

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json', 'Cookie': 'sid=$sid'},
      );

      if (response.statusCode == 200) {
        print('🔹 Response: ${response.body}');
        try {
          final decoded = jsonDecode(response.body);
          return EmployeeAssignments.fromJson(decoded);
        } catch (e) {
          throw Exception('Failed to parse response: $e');
        }
      } else {
        throw Exception(
          'Failed to load employee assignments. Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
