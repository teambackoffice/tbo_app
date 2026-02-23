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
      // Read SID
      final sid = await _secureStorage.read(key: 'sid');

      if (sid == null) {
        throw Exception("SID not found in storage");
      }

      final url = Uri.parse('${ApiConstants.baseUrl}lead_api.create_lead');

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(leadData),
      );

      // Handle success
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        return decoded;
      }
      // Handle API error
      else {
        return {
          "success": false,
          "status": response.statusCode,
          "body": response.body,
        };
      }
    } catch (e, stack) {
      return {"success": false, "error": e.toString()};
    }
  }
}
