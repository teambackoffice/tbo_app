import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';
import 'package:tbo_app/modal/task_list_modal.dart';

class TaskListService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<AllTaskListModal> fetchtasklist({
    String? status,
    String? assignedUsers,
  }) async {
    String baseUrl = '${ApiConstants.baseUrl}project_api.get_task_list';

    // Build query params only if provided
    final queryParams = <String, String>{};
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }
    if (assignedUsers != null && assignedUsers.isNotEmpty) {
      queryParams['assigned_users'] = assignedUsers;
    }

    // Build final Uri with query params
    final uri = Uri.parse(
      baseUrl,
    ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

    try {
      final String? sid = await _secureStorage.read(key: 'sid');
      if (sid == null) {
        throw Exception('Authentication required. Please login again.');
      }

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json', 'Cookie': 'sid=$sid'},
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}'); // Debugging line
        print('Response status code: ${response.statusCode}'); // Debugging line
        print(uri);
        try {
          final decoded = jsonDecode(response.body);

          final tasklist = allTaskListModalFromJson(response.body);

          return tasklist;
        } catch (e) {
          throw Exception('Failed to parse response: $e');
        }
      } else {
        throw Exception(
          'Failed to load projects. Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
