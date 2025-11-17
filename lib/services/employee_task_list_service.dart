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

      // 🔵 PRINT SID
      print("🔐 SID in storage: $sid");

      // Build headers
      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      };

      final url = Uri.parse(
        "${ApiConstants.baseUrl}project_api.get_task_list?custom_assigned_employee=$employeeId",
      );

      // 🔵 PRINT REQUEST INFO
      print("🔵 TASK LIST REQUEST");
      print("URL: $url");
      print("Method: GET");
      print("Headers: $headers");
      print("------------------------");

      final request = http.Request('GET', url);
      request.headers.addAll(headers);

      final response = await request.send();

      // 🔵 PRINT RAW RESPONSE
      print("🟣 RAW RESPONSE");
      print("Status Code: ${response.statusCode}");
      print("Headers: ${response.headers}");
      print("------------------------");

      final body = await response.stream.bytesToString();

      // 🔵 PRINT BODY
      print("🟢 RESPONSE BODY");
      print(body);
      print("------------------------");

      if (response.statusCode == 200) {
        final decoded = json.decode(body);

        // 🔵 PRINT DECODED JSON
        print("🟡 DECODED JSON");
        print(jsonEncode(decoded));
        print("------------------------");

        return decoded;
      } else {
        print("❌ ERROR: ${response.reasonPhrase}");
        print("❌ BODY: $body");
        throw Exception("Failed to fetch task list: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❌ EXCEPTION in getTaskListByEmployee: $e");
      rethrow;
    }
  }
}
