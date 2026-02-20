import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class TaskService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> getTaskListByEmployee({
    required String employeeId,
  }) async {
    try {
      final sid = await _secureStorage.read(key: 'sid');

      if (sid == null) {
        throw Exception("No session ID found in secure storage");
      }

      // Build headers
      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      };

      final url = Uri.parse(
        "${ApiConstants.baseUrl}project_api.get_task_list?custom_assigned_employee=$employeeId",
      );

      final request = http.Request('GET', url);
      request.headers.addAll(headers);

      final response = await request.send();

      final body = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print("=============Response ${body}===============");
        final decoded = json.decode(body);

        return decoded;
      } else {
        throw Exception("Failed to fetch task list: ${response.reasonPhrase}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
