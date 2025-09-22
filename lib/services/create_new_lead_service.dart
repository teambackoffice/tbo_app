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

      if (response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        return decoded;
      } else {
        throw Exception('Failed to create lead: ${response.statusCode}');
      }
    } catch (e) {
      return null;
    }
  }
}
