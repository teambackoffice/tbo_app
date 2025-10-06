import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:tbo_app/api/one_signal.dart'; // ✅ Import OneSignal service
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

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final data = json.decode(body);

        // Extract sid from cookie
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

        // Store session details
        if (sid != null) {
          await _storage.write(key: "sid", value: sid);
          await _storage.write(key: "username", value: username);

          // role_profile_name
          final roleProfileName = data["message"]?["role_profile_name"];
          if (roleProfileName != null) {
            await _storage.write(
              key: "role_profile_name",
              value: roleProfileName,
            );
          }

          // email - Link to OneSignal
          final email = data["message"]?["email"];
          if (email != null) {
            await _storage.write(key: "email", value: email);

            // ✅ Link user to OneSignal
            try {
              await OneSignal.login(email);
              print('✅ OneSignal: User linked with email: $email');

              // ✅ Add tags for targeted notifications
              final tags = <String, String>{
                'email': email,
                'username': username,
              };

              if (roleProfileName != null) {
                tags['role'] = roleProfileName.toLowerCase();
              }

              await OneSignalService().sendTags(tags);
              print('✅ OneSignal: Tags added - $tags');
            } catch (e) {
              print('⚠️ OneSignal error: $e');
            }
          }

          // full_name
          final fullName = data["full_name"];
          if (fullName != null) {
            await _storage.write(key: "full_name", value: fullName);
          }

          // employee_id (for Employee role)
          if (roleProfileName == "Employee") {
            final employeeName = data["message"]?["employee"]?["name"];
            if (employeeName != null) {
              await _storage.write(key: "employee_id", value: employeeName);

              // ✅ Add employee_id tag
              try {
                await OneSignalService().sendTags({
                  'employee_id': employeeName,
                });
                print('✅ OneSignal: Employee ID tag added: $employeeName');
              } catch (e) {
                print('⚠️ OneSignal tag error: $e');
              }
            }
          }
        }

        return {"data": data, "sid": sid};
      } else {
        return {"error": response.reasonPhrase};
      }
    } catch (e) {
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
      await _storage.read(key: "employee_id");
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
    if (email != null) {
      await _storage.write(key: "email", value: email);
    }
    if (fullName != null) {
      await _storage.write(key: "full_name", value: fullName);
    }
  }

  Future<void> logout() async {
    // ✅ Remove OneSignal user before clearing storage
    try {
      await OneSignalService().removeExternalUserId();
      print('✅ OneSignal: User unlinked on logout');
    } catch (e) {
      print('⚠️ OneSignal logout error: $e');
    }

    await _storage.deleteAll();
  }
}
