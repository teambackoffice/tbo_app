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

    print("🔑 SID: $sid");
    print("👤 Employee ID: $employeeId");

    // Approach 1
    try {
      print("\n🚀 Trying Approach 1 (no status param)");
      final result1 = await _tryApproach1(employeeId, sid);
      if (result1 != null) {
        print("✅ Approach 1 Success: $result1");
        return result1;
      }
    } catch (e) {
      print("❌ Approach 1 failed: $e");
    }

    // Approach 2
    try {
      print("\n🚀 Trying Approach 2 (status loop)");
      final result2 = await _tryApproach2(employeeId, sid);
      if (result2 != null) {
        print("✅ Approach 2 Success: $result2");
        return result2;
      }
    } catch (e) {
      print("❌ Approach 2 failed: $e");
    }

    // Approach 3
    try {
      print("\n🚀 Trying Approach 3 (alt endpoints)");
      final result3 = await _tryApproach3(employeeId, sid);
      if (result3 != null) {
        print("✅ Approach 3 Success: $result3");
        return result3;
      }
    } catch (e) {
      print("❌ Approach 3 failed: $e");
    }

    print("⚠️ All approaches failed, returning zero counts");
    return {'open': 0, 'working': 0, 'completed': 0};
  }

  // Approach 1
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

  // Approach 2
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

          print("📊 Status $status → Count: $count");

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
      } catch (e) {
        print("❌ Error for status $status: $e");
      }
    }

    print("📊 Final counts from Approach 2: $counts");

    if (counts['open']! > 0 ||
        counts['working']! > 0 ||
        counts['completed']! > 0) {
      return counts;
    }
    return null;
  }

  // Approach 3
  Future<Map<String, dynamic>?> _tryApproach3(
    String employeeId,
    String sid,
  ) async {
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
          final counts = _extractTaskCounts(response);
          print("📊 Extracted counts from $endpoint: $counts");
          if (counts != null) return counts;
        }
      } catch (e) {
        print("❌ Error for endpoint $endpoint: $e");
      }
    }
    return null;
  }

  // Core request method
  Future<Map<String, dynamic>?> _makeRequest(
    Uri url,
    String sid,
    String label,
  ) async {
    print("\n🌐 Request → $label");
    print("🔗 URL: $url");

    final headers = {'Content-Type': 'application/json', 'Cookie': 'sid=$sid'};
    final request = http.Request('GET', url);
    request.headers.addAll(headers);

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    print("📥 Response Status: ${response.statusCode}");
    print("📥 Response Body: $resBody");

    if (response.statusCode == 200) {
      try {
        return jsonDecode(resBody);
      } catch (e) {
        print("⚠️ JSON decode failed: $e");
        return null;
      }
    } else {
      throw Exception("Failed request: ${response.reasonPhrase}");
    }
  }

  // Extract counts from different formats
  Map<String, dynamic>? _extractTaskCounts(Map<String, dynamic> response) {
    print("🔍 Trying to extract counts from response: $response");

    if (response.containsKey('open') ||
        response.containsKey('working') ||
        response.containsKey('completed')) {
      return {
        'open': response['open'] ?? 0,
        'working': response['working'] ?? 0,
        'completed': response['completed'] ?? 0,
      };
    }

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

    print("⚠️ No matching count format found in response");
    return null;
  }
}
