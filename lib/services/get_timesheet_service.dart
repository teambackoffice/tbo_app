import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';
import 'package:tbo_app/modal/timesheet_modal.dart';

class GetTimesheetService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<TimesheetModal> fetchtimesheet({String? employee}) async {
    String url = '${ApiConstants.baseUrl}project_api.get_timesheet';

    // 👉 Add employee param only if provided
    if (employee != null && employee.isNotEmpty) {
      url += '?employee=$employee';
    }

    try {
      final String? sid = await _secureStorage.read(key: 'sid');

      if (sid == null) {
        throw Exception('Authentication required. Please login again.');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', 'Cookie': 'sid=$sid'},
      );

      if (response.statusCode == 200) {
        try {
          final decoded = jsonDecode(response.body);
          return TimesheetModal.fromJson(decoded);
        } catch (e) {
          throw Exception('Failed to parse response: $e');
        }
      } else {
        throw Exception(
          'Failed to load timesheet. Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
