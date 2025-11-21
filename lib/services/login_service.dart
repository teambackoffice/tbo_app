import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:tbo_app/api/one_signal.dart';
import 'package:tbo_app/config/api_constants.dart';

class LoginService {
  final _storage = const FlutterSecureStorage();

  final String loginUrl = "${ApiConstants.baseUrl}auth.user_login";

  Future<Map<String, dynamic>?> loginUser({
    required String username,
    required String password,
  }) async {
    try {
      var uri = Uri.parse("$loginUrl?usr=$username&pwd=$password");

      var request = http.Request('POST', uri);
      http.StreamedResponse response = await request.send();

      // Read body
      final body = await response.stream.bytesToString();

      final data = json.decode(body);

      // Extract sid
      String? sid;
      if (response.headers['set-cookie'] != null) {
        final cookies = response.headers['set-cookie']!.split(';');
        for (var c in cookies) {
          if (c.trim().startsWith('sid=')) {
            sid = c.trim().substring(4);
            break;
          }
        }
      }

      // Store session
      if (sid != null) {
        await _storage.write(key: "sid", value: sid);
        await _storage.write(key: "username", value: username);

        // ⭐ Store smart role
        final smartRole = data["message"]?["smart_role"];

        if (smartRole != null) {
          await _storage.write(key: "smart_role", value: smartRole);
        }

        // Store email + OneSignal login
        final email = data["message"]?["email"];
        if (email != null) {
          await _storage.write(key: "email", value: email);

          try {
            await OneSignal.login(email);
            await OneSignalService().sendTags({
              'email': email,
              'username': username,
            });
          } catch (e) {}
        }

        // Store full name
        final fullName = data["full_name"];
        if (fullName != null) {
          await _storage.write(key: "full_name", value: fullName);
        }
      }

      return {"data": data, "sid": sid};
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  // Getters
  Future<String?> getStoredSid() async => await _storage.read(key: "sid");
  Future<String?> getStoredSmartRole() async =>
      await _storage.read(key: "smart_role");
  Future<String?> getStoredEmail() async => await _storage.read(key: "email");
  Future<String?> getStoredFullName() async =>
      await _storage.read(key: "full_name");

  Future<void> logout() async {
    try {
      await OneSignalService().removeExternalUserId();
    } catch (e) {}

    await _storage.deleteAll();
  }
}
