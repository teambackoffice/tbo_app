import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class TaskDateRequestService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> createdaterequest({
    required String employee,
    required String task,
    required String requestedStartDate,
    required String requestedEndDate,
    required String reason,
  }) async {
    final sid = await _secureStorage.read(key: 'sid');

    if (sid == null) {
      throw Exception("Session ID not found in secure storage");
    }

    final url = Uri.parse(
      "${ApiConstants.baseUrl}task_assignment_api.create_employee_date_request"
      "?employee=$employee"
      "&task=$task"
      "&requested_start_date=$requestedStartDate"
      "&requested_end_date=$requestedEndDate"
      "&reason=$reason",
    );

    final headers = {'Content-Type': 'application/json', 'Cookie': 'sid=$sid'};

    final request = http.Request('POST', url);
    request.headers.addAll(headers);

    final response = await request.send();

    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(resBody);
    } else {
      throw Exception(
        "Failed to create employee date request: ${response.reasonPhrase}",
      );
    }
  }
}
