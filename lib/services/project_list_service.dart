import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';
import 'package:tbo_app/modal/project_list_modal.dart';

class ProjectListService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<ProjectList> fetchProjectList({String? status}) async {
    String url = '${ApiConstants.baseUrl}project_api.get_project_list';

    // Add status as a query parameter if provided
    if (status != null && status.isNotEmpty) {
      url += '?status=$status';
    }

    try {
      final String? sid = await _secureStorage.read(key: 'sid');
      if (sid == null) {
        throw Exception('Authentication required. Please login again.');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', 'Cookie': 'sid=$sid'},
      );

      if (response.statusCode == 200) {
        try {
          final decoded = jsonDecode(response.body);
          final projectList = ProjectList.fromJson(decoded);
          return projectList;
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
