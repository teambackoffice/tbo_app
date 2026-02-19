import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class CreateTaskService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final String url = '${ApiConstants.baseUrl}project_api.create_task';

  Future<String?> _getToken() async {
    return await _storage.read(key: "sid");
  }

  Future<Map<String, dynamic>?> createTask({
    required String project,
    required String subject,
    required String assignedEmployee,
    required String priority,
    required String description,
    required String expStartDate,
    required String expEndDate,
    required String status,
  }) async {
    try {
      String? sid = await _getToken();

      if (sid == null) {
        throw Exception("Token not found");
      }

      var headers = {
        'Cookie': 'sid=$sid',
        'Content-Type': 'application/json',
        "Authorization": "token $sid",
      };

      var body = jsonEncode({
        "project": project,
        "subject": subject,
        "custom_assigned_employee": assignedEmployee,
        "priority": priority,
        "description": description,
        "exp_start_date": expStartDate,
        "exp_end_date": expEndDate,
        "status": status,
      });

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);
      }

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          "Failed with status ${response.statusCode}: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Create Task Error: $e");
    }
  }
}
