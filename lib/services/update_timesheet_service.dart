// lib/services/update_timesheet_status_service.dart
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class UpdateTimesheetStatusService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> updateTimesheetStatus({
    required String timesheetId,
    required String action,
  }) async {
    try {
      // Read SID from storage
      final sid = await _secureStorage.read(key: "sid");

      final url = Uri.parse(
        "${ApiConstants.baseUrl}task_assignment_api.update_timesheet_status",
      );

      final headers = {
        "Content-Type": "application/json",
        if (sid != null) "Cookie": "sid=$sid",
      };

      final body = jsonEncode({"timesheet_id": timesheetId, "action": action});

      // Make POST call
      final response = await http.post(url, headers: headers, body: body);

      // Return JSON response
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "success": false,
          "status_code": response.statusCode,
          "message": response.body,
        };
      }
    } catch (e, stack) {
      return {"success": false, "message": e.toString()};
    }
  }
}
