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

      // 📌 Print Request Info
      print("📤 Request URL: $uri");
      print(
        "📤 Request Headers: {Content-Type: application/json, Cookie: sid=$sid}",
      );
      print("📤 Query Params: $queryParams");

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json', 'Cookie': 'sid=$sid'},
      );

      // 📌 Print Response Info
      print("📥 Response Code: ${response.statusCode}");
      print("📥 Raw Response Body: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final decoded = jsonDecode(response.body);

          // 📌 Print Parsed JSON
          print("✅ Decoded JSON: $decoded");

          final tasklist = allTaskListModalFromJson(response.body);

          // 📌 Print Parsed Model
          print("✅ Parsed Task List Modal: $tasklist");

          return tasklist;
        } catch (e) {
          print("❌ Parsing Error: $e");
          throw Exception('Failed to parse response: $e');
        }
      } else {
        print(
          "❌ Server Error: Code ${response.statusCode}, Body: ${response.body}",
        );
        throw Exception(
          'Failed to load projects. Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("❌ Network Error: $e");
      throw Exception('Network error: $e');
    }
  }
}
