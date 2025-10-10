import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class EditLeadService {
  final String _url = '${ApiConstants.baseUrl}lead_api.edit_lead';

  Future<Map<String, dynamic>?> editLead({
    required String leadId,
    required String status,
  }) async {
    try {
      print("🟡 Sending Edit Lead Request...");
      print("📍 URL: $_url");

      var headers = {'Content-Type': 'application/json'};

      var body = json.encode({"lead_id": leadId, "status": status});

      print("📦 Request Headers: $headers");
      print("📦 Request Body: $body");

      var request = http.Request('POST', Uri.parse(_url));
      request.body = body;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      print("🕒 Waiting for response...");

      if (response.statusCode == 200) {
        final resBody = await response.stream.bytesToString();
        final decoded = json.decode(resBody);

        print("✅ Response Status: ${response.statusCode}");
        print("✅ Response Body: $decoded");

        return decoded;
      } else {
        final errorBody = await response.stream.bytesToString();
        print("❌ Failed with status: ${response.statusCode}");
        print("❌ Reason: ${response.reasonPhrase}");
        print("❌ Response Body: $errorBody");
        return null;
      }
    } catch (e) {
      print("⚠️ Exception in editLead: $e");
      return null;
    }
  }
}
