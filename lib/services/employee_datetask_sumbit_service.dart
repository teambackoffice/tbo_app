import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class SubmitDateRequestService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> submitDateRequest({
    required String requestId,
    String? requestedEndDate,
  }) async {
    const url = '${ApiConstants.baseUrl}date_request_api.submit_date_request';

    try {
      print('🔹 Starting date request submission...');
      print('📤 API URL: $url');

      // ✅ Read SID from secure storage
      final sid = await _secureStorage.read(key: 'sid');
      print('🔑 Retrieved SID: $sid');

      if (sid == null) {
        print('⚠️ SID not found in secure storage');
        return {'error': 'Session expired. Please log in again.'};
      }

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      };

      final body = json.encode({
        "request_id": requestId,
        "requested_end_date": requestedEndDate,
      });

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        return {'error': 'Request failed. Please try again.'};
      }
    } catch (e, stackTrace) {
      return {'error': e.toString()};
    }
  }
}
