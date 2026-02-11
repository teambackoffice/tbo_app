import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';
import 'package:tbo_app/modal/project_list_modal.dart';

class ProjectListService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<ProjectList> fetchProjectList({String? status}) async {
    String url = '${ApiConstants.baseUrl}project_api.get_project_list';

    if (status != null && status.isNotEmpty) {
      url += '?status=$status';
    }

    try {
      final String? sid = await _secureStorage.read(key: 'sid');

      if (sid == null) {
        throw Exception('Authentication required. Please login again.');
      }

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      };

      // 🔵 REQUEST LOGS
      print('🔵 REQUEST URL: $url');
      print('🔵 REQUEST HEADERS: $headers');

      final response = await http.get(Uri.parse(url), headers: headers);

      // 🟢 RESPONSE LOGS
      print('🟢 STATUS CODE: ${response.statusCode}');
      print('🟢 RAW RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final decoded = jsonDecode(response.body);

          // 🟣 FULL DECODED JSON
          print('🟣 DECODED JSON: $decoded');

          // Optional: print only message section
          print('🟣 MESSAGE DATA: ${decoded['message']}');

          final projectList = ProjectList.fromJson(decoded);

          return projectList;
        } catch (e) {
          print('🔴 JSON PARSE ERROR: $e');
          throw Exception('Failed to parse response: $e');
        }
      } else {
        // 🔴 API ERROR RESPONSE
        print('🔴 API ERROR BODY: ${response.body}');
        throw Exception(
          'Failed to load projects. Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // 🔴 NETWORK / UNEXPECTED ERROR
      print('🔴 NETWORK ERROR: $e');
      throw Exception('Network error: $e');
    }
  }
}
