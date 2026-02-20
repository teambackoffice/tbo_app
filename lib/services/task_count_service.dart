import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class TaskCountService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> getTaskCount() async {
    final sid = await _secureStorage.read(key: 'sid');
    final employeeId = await _secureStorage.read(key: 'employee_original_id');

    if (sid == null) throw Exception("Session ID not found");
    if (employeeId == null) throw Exception("Employee ID not found");

    return await _getTaskCountsByStatus(employeeId, sid);
  }

  Future<Map<String, dynamic>?> _getTaskCountsByStatus(
    String employeeId,
    String sid,
  ) async {
    final statuses = ['open', 'working', 'completed'];
    Map<String, int> counts = {'open': 0, 'working': 0, 'completed': 0};

    for (String status in statuses) {
      try {
        final count = await _getCountForStatus(employeeId, sid, status);
        counts[status] = count;
      } catch (e) {}
    }

    return counts;
  }

  Future<int> _getCountForStatus(
    String employeeId,
    String sid,
    String status,
  ) async {
    final url = Uri.parse(
      "${ApiConstants.baseUrl}project_api.get_task_summary"
      "?custom_assigned_employee=$employeeId&status=$status",
    );

    final headers = {'Content-Type': 'application/json', 'Cookie': 'sid=$sid'};

    print("🔹 Request URL ($status): $url");
    print("🔹 Headers: $headers");

    final request = http.Request('GET', url);
    request.headers.addAll(headers);

    final response = await request.send();
    final body = await response.stream.bytesToString();

    print("🔸 Status Code ($status): ${response.statusCode}");
    print("🔸 Raw Response Body ($status): $body");

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(body);

        print("✅ Decoded JSON ($status): $jsonResponse");

        final count = jsonResponse['message']?['total_count'] ?? 0;

        print("📊 Extracted Count ($status): $count");

        return count as int;
      } catch (e) {
        print("❌ JSON Parse Error ($status): $e");
        return 0;
      }
    } else {
      print("❌ Request Failed ($status): ${response.reasonPhrase}");
      throw Exception(
        "Failed request for status $status: ${response.reasonPhrase}",
      );
    }
  }
}
