import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';
import 'package:tbo_app/modal/employee_task_date_request.dart';

class EmployeeTaskDateRequestService {
  static const _baseUrl =
      '${ApiConstants.baseUrl}date_request_api.get_date_requests';
  static const _storage = FlutterSecureStorage();

  Future<EmployeeDateRequestModalClass?> fetchDateRequests({
    required String employeeId,
  }) async {
    try {
      // 🔵 READ SID
      String? sid = await _storage.read(key: 'sid');

      if (sid == null) {
        return null;
      }

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      };

      // 🔵 PREPARE REQUEST
      var request = http.Request('GET', Uri.parse(_baseUrl));
      request.body = json.encode({"employee": employeeId});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      // 🔵 READ STRING BODY
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        try {
          final decoded = jsonDecode(responseBody);

          final parsedModel = employeeDateRequestModalClassFromJson(
            responseBody,
          );

          return parsedModel;
        } catch (e) {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
