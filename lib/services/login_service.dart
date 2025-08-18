import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class LoginService {
  final _storage = const FlutterSecureStorage();

  final String loginUrl = "${ApiConstants.baseUrl}user_login";

  Future<Map<String, dynamic>?> loginUser({
    required String username,
    required String password,
  }) async {
    try {
      print("🔑 Attempting login...");
      print("➡️ Username: $username | Password: $password");

      var uri = Uri.parse(
        "$loginUrl?usr=$username&pwd=$password",
      ); // API expects query params
      print("🌐 Request URL: $uri");

      var request = http.Request('POST', uri);

      http.StreamedResponse response = await request.send();
      print("📡 Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        print("📥 Raw Response Body: $body");

        final data = json.decode(body);
        print("✅ Decoded Response Data: $data");

        // Extract sid from cookie if returned in headers
        String? sid;
        if (response.headers['set-cookie'] != null) {
          print("🍪 Set-Cookie Header: ${response.headers['set-cookie']}");
          final cookies = response.headers['set-cookie']!.split(';');
          for (var c in cookies) {
            if (c.trim().startsWith('sid=')) {
              sid = c.trim().substring(4);
              break;
            }
          }
        }

        print("📌 Extracted SID: $sid");

        // Store sid & username in secure storage
        if (sid != null) {
          await _storage.write(key: "sid", value: sid);
          await _storage.write(key: "username", value: username);
          print("🔒 Stored SID & Username in Secure Storage");
        }

        return {"data": data, "sid": sid};
      } else {
        print("❌ Error: ${response.reasonPhrase}");
        return {"error": response.reasonPhrase};
      }
    } catch (e) {
      print("⚠️ Exception: $e");
      return {"error": e.toString()};
    }
  }

  Future<String?> getStoredSid() async {
    final sid = await _storage.read(key: "sid");
    print("📦 Retrieved SID from storage: $sid");
    return sid;
  }

  Future<String?> getStoredUsername() async {
    final username = await _storage.read(key: "username");
    print("📦 Retrieved Username from storage: $username");
    return username;
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    print("🚪 User logged out — storage cleared");
  }
}
