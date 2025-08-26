import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class CreateProjectService {
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> createProject({
    required String projectName,
    required String status,
    required String startDate,
    required String endDate,
    required String projectType,
    required String priority,
    required String department,
    String? notes,
  }) async {
    try {
      // Read sid directly
      String? sid = await _storage.read(key: "sid");

      if (sid == null) {
        throw Exception("No session found. Please login again.");
      }

      var headers = {'Content-Type': 'application/json', 'Cookie': 'sid=$sid'};

      var url = Uri.parse("${ApiConstants.baseUrl}project_api.create_project");

      var body = json.encode({
        "project_name": projectName,
        "status": status,
        "expected_start_date": startDate,
        "expected_end_date": endDate,
        "project_type": projectType,
        "priority": priority,
        "department": department,
        "notes": notes,
      });

      // 🔹 Debug logs

      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed: ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
