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

      // 🔵 PRINT REQUEST
      print("🔵 LOGIN REQUEST");
      print("URL: $uri");
      print("Method: POST");
      print("------------------------");

      var request = http.Request('POST', uri);
      http.StreamedResponse response = await request.send();

      // 🔵 PRINT RAW RESPONSE DETAILS
      print("🟣 RAW RESPONSE");
      print("Status Code: ${response.statusCode}");
      print("Headers: ${response.headers}");
      print("------------------------");

      final body = await response.stream.bytesToString();

      // 🔵 PRINT RESPONSE BODY
      print("🟢 RESPONSE BODY");
      print(body);
      print("------------------------");

      final data = json.decode(body);

      // 🔵 PRINT DECODED JSON
      print("🟡 DECODED JSON");
      print(jsonEncode(data));
      print("------------------------");

      // Extract sid
      String? sid;
      if (response.headers['set-cookie'] != null) {
        print("🍪 SET-COOKIE HEADER FOUND");
        print(response.headers['set-cookie']);

        final cookies = response.headers['set-cookie']!.split(';');
        for (var c in cookies) {
          if (c.trim().startsWith('sid=')) {
            sid = c.trim().substring(4);
            print("✅ Extracted SID: $sid");
            break;
          }
        }
      } else {
        print("❌ No set-cookie header found. Cannot extract SID.");
      }

      // Store session
      if (sid != null) {
        print("💾 Storing SID and User Data…");
        await _storage.write(key: "sid", value: sid);
        await _storage.write(key: "username", value: username);

        final roleProfileName = data["message"]?["role_profile_name"];
        print("Role Profile: $roleProfileName");
        if (roleProfileName != null) {
          await _storage.write(
            key: "role_profile_name",
            value: roleProfileName,
          );
        }

        final email = data["message"]?["email"];
        print("Email: $email");
        if (email != null) {
          await _storage.write(key: "email", value: email);

          // OneSignal linking
          try {
            print("🔗 Linking OneSignal user: $email");
            await OneSignal.login(email);

            final tags = <String, String>{'email': email, 'username': username};

            if (roleProfileName != null) {
              tags['role'] = roleProfileName.toLowerCase();
            }

            print("🏷️ OneSignal Tags: $tags");
            await OneSignalService().sendTags(tags);
          } catch (e) {
            print("❌ OneSignal Error: $e");
          }
        }

        final fullName = data["full_name"];
        print("Full Name: $fullName");
        if (fullName != null) {
          await _storage.write(key: "full_name", value: fullName);
        }

        if (roleProfileName == "Employee") {
          final employeeName = data["message"]?["employee"]?["name"];
          print("Employee ID: $employeeName");

          if (employeeName != null) {
            await _storage.write(key: "employee_id", value: employeeName);

            try {
              await OneSignalService().sendTags({'employee_id': employeeName});
            } catch (e) {
              print("❌ OneSignal Tag Error: $e");
            }
          }
        }
      }

      return {"data": data, "sid": sid};
    } catch (e) {
      print("❌ LOGIN ERROR: $e");
      return {"error": e.toString()};
    }
  }

  // Getters
  Future<String?> getStoredSid() async => await _storage.read(key: "sid");
  Future<String?> getStoredApiKey() async =>
      await _storage.read(key: "api_key");
  Future<String?> getStoredUsername() async =>
      await _storage.read(key: "username");
  Future<String?> getStoredRoleProfileName() async =>
      await _storage.read(key: "role_profile_name");
  Future<String?> getStoredEmail() async => await _storage.read(key: "email");
  Future<String?> getStoredEmployeeId() async =>
      await _storage.read(key: "employee_original_id");
  Future<String?> getStoredFullName() async =>
      await _storage.read(key: "full_name");

  Future<void> storeSession({
    required String sid,
    required String username,
    String? email,
    String? fullName,
  }) async {
    await _storage.write(key: "sid", value: sid);
    await _storage.write(key: "username", value: username);
    if (email != null) await _storage.write(key: "email", value: email);
    if (fullName != null)
      await _storage.write(key: "full_name", value: fullName);
  }

  Future<void> logout() async {
    try {
      print("🔓 Removing OneSignal External User");
      await OneSignalService().removeExternalUserId();
    } catch (e) {
      print("❌ OneSignal Logout Error: $e");
    }

    print("🧹 Clearing All Secure Storage Data");
    await _storage.deleteAll();
  }
}
