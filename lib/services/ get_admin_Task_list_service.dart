import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';
import 'package:tbo_app/modal/get_admin_task_list_modal.dart';

class GetAdminTaskListService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Get SID from secure storage
  Future<String?> _getSid() async {
    final sid = await _secureStorage.read(key: "sid");
    return sid;
  }

  /// Fetch Project Details
  Future<GetAdminTaskListModalClass?> getProjectDetails({
    required String projectId,
  }) async {
    try {
      final sid = await _getSid();

      if (sid == null) {
        throw Exception("SID not found. Please login again.");
      }

      final String url =
          "${ApiConstants.baseUrl}project_api.get_project_detail?name=$projectId";

      final headers = {
        "Authorization": "token $sid",
        "Cookie": "sid=$sid",
        "Content-Type": "application/json",
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        return GetAdminTaskListModalClass.fromJson(jsonData);
      } else {
        throw Exception(
          "Failed to load project details: ${response.reasonPhrase}",
        );
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
