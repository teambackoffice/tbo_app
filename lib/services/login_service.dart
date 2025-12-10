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
      print("📡 LOGIN API INITIATED");
      print("➡️ URL: $loginUrl?usr=$username&pwd=$password");

      var uri = Uri.parse("$loginUrl?usr=$username&pwd=$password");

      var request = http.Request('POST', uri);

      print("📤 Sending Request...");
      http.StreamedResponse response = await request.send();

      print("\n📥 RAW RESPONSE RECEIVED");
      print("➡️ Status Code: ${response.statusCode}");
      print("➡️ Reason Phrase: ${response.reasonPhrase}");

      // Print all headers
      print("\n📄 Response Headers:");
      response.headers.forEach((key, value) {
        print("   $key: $value");
      });

      // Read body
      final body = await response.stream.bytesToString();

      print("\n📦 Response Body Raw:");
      print(body);

      final data = json.decode(body);

      print("\n📊 Decoded JSON:");
      print(data);

      // Extract sid
      String? sid;
      if (response.headers['set-cookie'] != null) {
        print("\n🍪 Set-Cookie Found:");
        print(response.headers['set-cookie']);

        final cookies = response.headers['set-cookie']!.split(';');
        for (var c in cookies) {
          if (c.trim().startsWith('sid=')) {
            sid = c.trim().substring(4);
            break;
          }
        }

        print("🔑 Extracted SID: $sid");
      } else {
        print("⚠️ No Set-Cookie Header Found!");
      }

      // Store session
      if (sid != null) {
        await _storage.write(key: "sid", value: sid);
        await _storage.write(key: "username", value: username);
        print("💾 SID Stored Successfully");

        final smartRole = data["message"]?["smart_role"];
        if (smartRole != null) {
          await _storage.write(key: "smart_role", value: smartRole);
          print("💾 Smart Role Stored: $smartRole");
        }

        final email = data["message"]?["email"];
        if (email != null) {
          await _storage.write(key: "email", value: email);
          print("💾 Email Stored: $email");

          try {
            await OneSignal.login(email);
            print("📡 OneSignal Login Success");

            await OneSignalService().sendTags({
              'email': email,
              'username': username,
            });
            print("🏷️ OneSignal Tags Sent");
          } catch (e) {
            print("⚠️ OneSignal Error: $e");
          }
        }

        final fullName = data["full_name"];
        if (fullName != null) {
          await _storage.write(key: "full_name", value: fullName);
          print("💾 Full Name Stored: $fullName");
        }

        // 🔥 NEW → Store department
        final department = data["message"]?["employee"]?["department"];
        if (department != null) {
          await _storage.write(key: "department", value: department);
          print("💾 Department Stored: $department");
        }
      }

      print("\n✅ FINAL RETURN DATA");
      print({"data": data, "sid": sid});

      return {"data": data, "sid": sid};
    } catch (e) {
      print("❌ LOGIN ERROR: $e");
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
