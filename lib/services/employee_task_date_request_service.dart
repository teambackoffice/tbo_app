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
      // Read sid from secure storage
      String? sid = await _storage.read(key: 'sid');
      if (sid == null) {
        return null;
      }

      var headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid', // Add cookie header
      };

      var request = http.Request('GET', Uri.parse(_baseUrl));
      request.body = json.encode({"employee": employeeId});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        return employeeDateRequestModalClassFromJson(responseBody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
