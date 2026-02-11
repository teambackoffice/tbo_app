import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class CreateNewLeadService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> createLead({
    required Map<String, dynamic> leadData,
  }) async {
    try {
      print('📤 Lead Payload: $leadData');

      // Read SID
      final sid = await _secureStorage.read(key: 'sid');
      print('🔐 SID: $sid');

      if (sid == null) {
        throw Exception("SID not found in storage");
      }

      final url = Uri.parse('${ApiConstants.baseUrl}lead_api.create_lead');
      print('🌐 URL: $url');

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      };
      print('📨 Headers: $headers');

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(leadData),
      );

      // Print raw response
      print('📥 Status Code: ${response.statusCode}');
      print('📥 Raw Response Body: ${response.body}');

      // Handle success
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        print('✅ Decoded Response: $decoded');
        return decoded;
      }
      // Handle API error
      else {
        print('❌ API Error Response');
        return {
          "success": false,
          "status": response.statusCode,
          "body": response.body,
        };
      }
    } catch (e, stack) {
      print('🔥 Exception Occurred');
      print('Error: $e');
      print('StackTrace: $stack');

      return {"success": false, "error": e.toString()};
    }
  }
}
