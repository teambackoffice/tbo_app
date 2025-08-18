import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class LogOutService {
  final String baseUrl = "${ApiConstants.baseUrl}logout";

  Future<Map<String, dynamic>> logout({required String username}) async {
    try {
      // Build URL
      var url = Uri.parse("$baseUrl?usr=$username");
      print("➡️ Logout URL: $url");

      // Create request
      var request = http.Request('POST', url);
      print("➡️ Request Method: ${request.method}");
      print("➡️ Request Headers: ${request.headers}");
      print("➡️ Request Body: ${request.body}");

      // Send request
      print("📤 Sending logout request...");
      http.StreamedResponse response = await request.send();

      print("📥 Response Status Code: ${response.statusCode}");
      print("📥 Response Reason: ${response.reasonPhrase}");

      // Handle response
      if (response.statusCode == 200) {
        String body = await response.stream.bytesToString();
        print("✅ Response Body: $body");

        var decoded = jsonDecode(body);
        print("✅ Decoded JSON: $decoded");

        return decoded;
      } else {
        print("❌ Logout failed: ${response.reasonPhrase}");
        return {
          "status": "error",
          "message": response.reasonPhrase ?? "Unknown error",
        };
      }
    } catch (e) {
      print("🔥 Exception during logout: $e");
      return {"status": "error", "message": e.toString()};
    }
  }
}
