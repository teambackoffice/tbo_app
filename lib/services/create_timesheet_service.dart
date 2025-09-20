import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class CreateTimesheetService {
  Future<Map<String, dynamic>?> createTimesheet({
    required String sid,
    required String employee,
    required String startDate,
    required String endDate,
    required List<Map<String, dynamic>> timeLogs,
  }) async {
    final url = Uri.parse(
      "${ApiConstants.baseUrl}project_api.create_timesheet",
    );

    final headers = {'Content-Type': 'application/json', 'Cookie': 'sid=$sid'};

    final body = json.encode({
      "employee": employee,
      "start_date": startDate,
      "end_date": endDate,
      "time_logs": timeLogs,
    });

    try {
      final request = http.Request('POST', url);
      request.headers.addAll(headers);
      request.body = body;

      final response = await request.send();

      print("➡️ URL: $url");
      print("➡️ Headers: $headers");
      print("➡️ Body: $body");
      print("➡️ Status Code: ${response.statusCode}");

      final responseBody = await response.stream.bytesToString();
      print("➡️ Response: $responseBody");

      if (response.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        throw Exception("Failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❌ Error: $e");
      rethrow;
    }
  }
}
