import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class TaskCountService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> getTaskCount({required String status}) async {
    // Read sid and employee ID from secure storage
    final sid = await _secureStorage.read(key: 'sid');
    final employeeId = await _secureStorage.read(key: 'employee_id');

    if (sid == null) {
      throw Exception("Session ID not found in secure storage");
    }

    if (employeeId == null) {
      throw Exception("Employee ID not found in secure storage");
    }

    // Get counts for each specific status
    return await _getTaskCountsByStatus(employeeId, sid);
  }

  Future<Map<String, dynamic>?> _getTaskCountsByStatus(
    String employeeId,
    String sid,
  ) async {
    // Your API uses these exact status names
    final statuses = ['open', 'working', 'completed'];
    Map<String, int> counts = {'open': 0, 'working': 0, 'completed': 0};

    for (String status in statuses) {
      try {
        final count = await _getCountForStatus(employeeId, sid, status);
        counts[status] = count;
      } catch (e) {
        // Continue with other statuses, keep count as 0
      }
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
    final request = http.Request('GET', url);
    request.headers.addAll(headers);

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(resBody);
        final count = jsonResponse['message']?['count'] ?? 0;
        return count as int;
      } catch (e) {
        return 0;
      }
    } else {
      throw Exception(
        "Failed request for status $status: ${response.reasonPhrase}",
      );
    }
  }
}
