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

      print("========== PROJECT LIST API ==========");
      print("Request URL: $url");
      print("Status Filter: $status");
      print("SID: $sid");

      if (sid == null) {
        print("ERROR: SID is null");
        throw Exception('Authentication required. Please login again.');
      }

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      };

      print("Request Headers: $headers");

      final response = await http.get(Uri.parse(url), headers: headers);

      print("========== RESPONSE ==========");
      print("Status Code: ${response.statusCode}");
      print("Response Headers: ${response.headers}");
      print("Raw Response Body:");
      print(response.body);

      if (response.statusCode == 200) {
        try {
          final decoded = jsonDecode(response.body);

          print("========== DECODED JSON ==========");
          print(decoded);

          final projectList = ProjectList.fromJson(decoded);

          print("========== PARSED MODEL ==========");
          print(projectList);

          return projectList;
        } catch (e, stackTrace) {
          print("========== JSON PARSE ERROR ==========");
          print("Error: $e");
          print("StackTrace: $stackTrace");

          throw Exception('Failed to parse response: $e');
        }
      } else {
        print("========== API ERROR ==========");
        print("Status Code: ${response.statusCode}");
        print("Body: ${response.body}");

        throw Exception(
          'Failed to load projects. Code: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      print("========== NETWORK/UNEXPECTED ERROR ==========");
      print("Error: $e");
      print("StackTrace: $stackTrace");

      throw Exception('Network error: $e');
    }
  }
}
