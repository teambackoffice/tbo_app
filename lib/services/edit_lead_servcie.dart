import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class EditLeadService {
  final String _url = '${ApiConstants.baseUrl}lead_api.edit_lead';

  Future<Map<String, dynamic>?> editLead({
    required String leadId,
    required String status,
  }) async {
    try {
      var headers = {'Content-Type': 'application/json'};

      var body = json.encode({"lead_id": leadId, "status": status});

      // ================================
      // PRINT REQUEST DETAILS
      // ================================
      developer.log(
        '════════════════════════════════════',
        name: 'EDIT LEAD API',
      );

      developer.log('🚀 EDIT LEAD API REQUEST', name: 'EDIT LEAD API');

      developer.log('🔗 URL: $_url', name: 'EDIT LEAD API');

      developer.log('📦 REQUEST BODY: $body', name: 'EDIT LEAD API');

      developer.log('📋 REQUEST HEADERS: $headers', name: 'EDIT LEAD API');

      developer.log(
        '════════════════════════════════════',
        name: 'EDIT LEAD API',
      );

      var request = http.Request('POST', Uri.parse(_url));

      request.body = body;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      // Read response body ONCE
      final responseBody = await response.stream.bytesToString();

      // ================================
      // PRINT RESPONSE DETAILS
      // ================================
      developer.log('📥 RESPONSE RECEIVED', name: 'EDIT LEAD API');

      developer.log(
        '📊 STATUS CODE: ${response.statusCode}',
        name: 'EDIT LEAD API',
      );

      developer.log(
        '📋 RESPONSE HEADERS: ${response.headers}',
        name: 'EDIT LEAD API',
      );

      developer.log('📦 RESPONSE BODY: $responseBody', name: 'EDIT LEAD API');

      developer.log(
        '════════════════════════════════════',
        name: 'EDIT LEAD API',
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(responseBody);

        developer.log('✅ DECODED RESPONSE: $decoded', name: 'EDIT LEAD API');

        return decoded as Map<String, dynamic>;
      } else {
        developer.log(
          '❌ API ERROR (${response.statusCode}): $responseBody',
          name: 'EDIT LEAD API',
        );

        return null;
      }
    } catch (e, stackTrace) {
      developer.log('🔥 EXCEPTION: $e', name: 'EDIT LEAD API');

      developer.log('📍 STACK TRACE: $stackTrace', name: 'EDIT LEAD API');

      return null;
    }
  }
}
