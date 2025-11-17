import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class TaskCountService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Removed the unused 'status' parameter for cleaner code
  Future<Map<String, dynamic>?> getTaskCount() async {
    // Read sid and employee ID from secure storage
    final sid = await _secureStorage.read(key: 'sid');
    final employeeId = await _secureStorage.read(key: 'employee_original_id');

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
    // Initialize map with default counts
    Map<String, int> counts = {'open': 0, 'working': 0, 'completed': 0};

    for (String status in statuses) {
      try {
        final count = await _getCountForStatus(employeeId, sid, status);
        counts[status] = count;
      } catch (e) {
        // Log the error for debugging, but continue with other statuses
        // print('Error fetching count for status $status: $e');
        // Count remains 0 due to initialization
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
        // ⭐ CRITICAL FIX: The API response uses 'total_count', not 'count'
        final count = jsonResponse['message']?['total_count'] ?? 0;
        return count as int;
      } catch (e) {
        // Malformed JSON or missing key will result in 0
        return 0;
      }
    } else {
      throw Exception(
        "Failed request for status $status: ${response.reasonPhrase}",
      );
    }
  }
}
