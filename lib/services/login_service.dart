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
      final uri = Uri.parse("$loginUrl?usr=$username&pwd=$password");

      print("🔵 LOGIN REQUEST");
      print("➡️ URL: $uri");
      print("➡️ Method: POST");

      final request = http.Request('POST', uri);
      final response = await request.send();

      print("🟢 RESPONSE RECEIVED");
      print("➡️ Status Code: ${response.statusCode}");

      // 🔹 Print headers
      print("📦 RESPONSE HEADERS:");
      response.headers.forEach((key, value) {
        print("   $key : $value");
      });

      // 🔹 Read & print raw body
      final body = await response.stream.bytesToString();
      print("📨 RAW RESPONSE BODY:");
      print(body);

      // 🔹 Decode JSON
      final data = json.decode(body);
      print("📊 PARSED JSON RESPONSE:");
      print(const JsonEncoder.withIndent('  ').convert(data));

      // 🔹 Extract SID
      String? sid;
      final setCookie = response.headers['set-cookie'];
      if (setCookie != null) {
        print("🍪 SET-COOKIE HEADER: $setCookie");

        final cookies = setCookie.split(';');
        for (var c in cookies) {
          if (c.trim().startsWith('sid=')) {
            sid = c.trim().substring(4);
            break;
          }
        }
      }

      print("🆔 EXTRACTED SID: $sid");

      // 🔹 Store data
      if (sid != null) {
        await _storage.write(key: "sid", value: sid);
        await _storage.write(key: "username", value: username);

        final smartRole = data["message"]?["smart_role"];
        final email = data["message"]?["email"];
        final fullName = data["full_name"];
        final department = data["message"]?["employee"]?["department"];

        print("👤 USER DATA");
        print("   Smart Role: $smartRole");
        print("   Email: $email");
        print("   Full Name: $fullName");
        print("   Department: $department");

        if (smartRole != null) {
          await _storage.write(key: "smart_role", value: smartRole);
        }

        if (email != null) {
          await _storage.write(key: "email", value: email);

          try {
            await OneSignal.login(email);
            await OneSignalService().sendTags({
              'email': email,
              'username': username,
            });
            print("🔔 OneSignal login & tags sent");
          } catch (e) {
            print("❌ OneSignal Error: $e");
          }
        }

        if (fullName != null) {
          await _storage.write(key: "full_name", value: fullName);
        }

        if (department != null) {
          await _storage.write(key: "department", value: department);
        }
      }

      print("✅ LOGIN FLOW COMPLETED");

      return {"data": data, "sid": sid, "statusCode": response.statusCode};
    } catch (e, stack) {
      print("❌ LOGIN ERROR");
      print(e);
      print(stack);
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
