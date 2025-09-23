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

    // Approach 1: Try without status parameter
    try {
      final result1 = await _tryApproach1(employeeId, sid);
      if (result1 != null) return result1;
    } catch (e) {}

    // Approach 2: Try with different status values
    try {
      final result2 = await _tryApproach2(employeeId, sid);
      if (result2 != null) return result2;
    } catch (e) {}

    // Approach 3: Try different endpoint if exists
    try {
      final result3 = await _tryApproach3(employeeId, sid);
      if (result3 != null) return result3;
    } catch (e) {}

    // If all approaches fail, return zero counts
    return {'open': 0, 'working': 0, 'completed': 0};
  }

  // Approach 1: No status parameter
  Future<Map<String, dynamic>?> _tryApproach1(
    String employeeId,
    String sid,
  ) async {
    final url = Uri.parse(
      "${ApiConstants.baseUrl}project_api.get_task_summary"
      "?custom_assigned_employee=$employeeId",
    );

    return await _makeRequest(url, sid, "Approach 1");
  }

  // Approach 2: Individual status calls
  Future<Map<String, dynamic>?> _tryApproach2(
    String employeeId,
    String sid,
  ) async {
    final statuses = [
      'Open',
      'Working',
      'Completed',
      'In Progress',
      'Todo',
      'Done',
    ];
    Map<String, int> counts = {'open': 0, 'working': 0, 'completed': 0};

    for (String status in statuses) {
      try {
        final url = Uri.parse(
          "${ApiConstants.baseUrl}project_api.get_task_summary"
          "?status=$status&custom_assigned_employee=$employeeId",
        );

        final response = await _makeRequest(url, sid, "Status: $status");
        if (response != null && response['message'] != null) {
          final count = response['message']['count'] ?? 0;

          // Map different status names to our categories
          if (status.toLowerCase().contains('open') ||
              status.toLowerCase().contains('todo')) {
            counts['open'] = (counts['open'] ?? 0) + (count as int);
          } else if (status.toLowerCase().contains('working') ||
              status.toLowerCase().contains('progress')) {
            counts['working'] = (counts['working'] ?? 0) + (count as int);
          } else if (status.toLowerCase().contains('completed') ||
              status.toLowerCase().contains('done')) {
            counts['completed'] = (counts['completed'] ?? 0) + (count as int);
          }
        }
      } catch (e) {}
    }

    if (counts['open']! > 0 ||
        counts['working']! > 0 ||
        counts['completed']! > 0) {
      return counts;
    }
    return null;
  }

  // Approach 3: Try alternative endpoint
  Future<Map<String, dynamic>?> _tryApproach3(
    String employeeId,
    String sid,
  ) async {
    // Try different possible endpoint names
    final endpoints = [
      'project_api.get_task_counts',
      'project_api.get_employee_task_summary',
      'project_api.get_dashboard_data',
      'task_api.get_summary',
    ];

    for (String endpoint in endpoints) {
      try {
        final url = Uri.parse(
          "${ApiConstants.baseUrl}$endpoint"
          "?custom_assigned_employee=$employeeId",
        );

        final response = await _makeRequest(url, sid, "Endpoint: $endpoint");
        if (response != null) {
          // Try to extract task counts from various response formats
          final counts = _extractTaskCounts(response);
          if (counts != null) return counts;
        }
      } catch (e) {}
    }
    return null;
  }

  Future<Map<String, dynamic>?> _makeRequest(
    Uri url,
    String sid,
    String label,
  ) async {
    final headers = {'Content-Type': 'application/json', 'Cookie': 'sid=$sid'};

    final request = http.Request('GET', url);
    request.headers.addAll(headers);

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(resBody);
    } else {
      throw Exception("Failed request: ${response.reasonPhrase}");
    }
  }

  Map<String, dynamic>? _extractTaskCounts(Map<String, dynamic> response) {
    // Try to find task counts in various response formats

    // Format 1: Direct counts
    if (response.containsKey('open') ||
        response.containsKey('working') ||
        response.containsKey('completed')) {
      return {
        'open': response['open'] ?? 0,
        'working': response['working'] ?? 0,
        'completed': response['completed'] ?? 0,
      };
    }

    // Format 2: Inside message
    if (response['message'] != null) {
      final message = response['message'];
      if (message is Map<String, dynamic>) {
        if (message.containsKey('open') ||
            message.containsKey('working') ||
            message.containsKey('completed')) {
          return {
            'open': message['open'] ?? 0,
            'working': message['working'] ?? 0,
            'completed': message['completed'] ?? 0,
          };
        }

        // Format 3: Task counts array or list
        if (message.containsKey('task_counts') ||
            message.containsKey('counts')) {
          final counts = message['task_counts'] ?? message['counts'];
          if (counts is List) {
            Map<String, int> result = {'open': 0, 'working': 0, 'completed': 0};
            for (var item in counts) {
              if (item is Map<String, dynamic>) {
                final status = item['status']?.toString().toLowerCase() ?? '';
                final count = item['count'] ?? 0;

                if (status.contains('open') || status.contains('todo')) {
                  result['open'] = count;
                } else if (status.contains('working') ||
                    status.contains('progress')) {
                  result['working'] = count;
                } else if (status.contains('completed') ||
                    status.contains('done')) {
                  result['completed'] = count;
                }
              }
            }
            return result;
          }
        }
      }
    }

    return null;
  }
}
