import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';
import 'package:tbo_app/modal/timesheet_modal.dart';

class GetTimesheetService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<TimesheetModal> fetchtimesheet({String? employee}) async {
    String url = '${ApiConstants.baseUrl}project_api.get_timesheet';

    if (employee != null && employee.isNotEmpty) {
      url += '?employee=$employee';
    }

    try {
      final String? sid = await _secureStorage.read(key: 'sid');

      if (sid == null) {
        throw Exception('Authentication required. Please login again.');
      }

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      /// ✅ PRINT EVERYTHING
      print('================ TIMESHEET API RESPONSE ================');
      print('URL: $url');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Body: ${response.body}');
      print('=========================================================');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        try {
          final decoded = jsonDecode(response.body);
          return TimesheetModal.fromJson(decoded);
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception('Failed to parse response: $e');
        }
      } else {
        throw Exception(
          'Failed to load timesheet. Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Network/General Error: $e');
      throw Exception('Network error: $e');
    }
  }
}
