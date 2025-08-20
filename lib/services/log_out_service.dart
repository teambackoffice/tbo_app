import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class LogOutService {
  final String baseUrl = "${ApiConstants.baseUrl}logout";

  Future<Map<String, dynamic>> logout({required String username}) async {
    try {
      // Build URL
      var url = Uri.parse("$baseUrl?usr=$username");

      // Create request
      var request = http.Request('POST', url);

      // Send request
      http.StreamedResponse response = await request.send();

      // Handle response
      if (response.statusCode == 200) {
        String body = await response.stream.bytesToString();

        var decoded = jsonDecode(body);

        return decoded;
      } else {
        return {
          "status": "error",
          "message": response.reasonPhrase ?? "Unknown error",
        };
      }
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }
}
