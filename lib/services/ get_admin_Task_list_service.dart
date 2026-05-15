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

    print("SID => $sid");

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

      print("========== API REQUEST ==========");
      print("URL => $url");
      print("Headers => $headers");
      print("Project ID => $projectId");

      // 1. Properly encode the URL to prevent FormatExceptions if projectId has spaces
      final encodedUrl = Uri.encodeFull(url);
      
      // 2. Add a timeout so it doesn't hang forever
      final response = await http
          .get(Uri.parse(encodedUrl), headers: headers)
          .timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception("Connection timed out. Please check your internet or server.");
        },
      );

      print("========== API RESPONSE ==========");
      print("Status Code => ${response.statusCode}");
      print("Reason => ${response.reasonPhrase}");
      print("Response Body => ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        print("========== DECODED JSON ==========");
        print(jsonData);

        return GetAdminTaskListModalClass.fromJson(jsonData);
      } else {
        throw Exception(
          "Failed to load project details: ${response.reasonPhrase}",
        );
      }
    } catch (e, stackTrace) {
      print("========== ERROR ==========");
      print(e);
      print(stackTrace);

      throw Exception("Error: $e");
    }
  }
}
