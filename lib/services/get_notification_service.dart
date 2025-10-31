import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';
import 'package:tbo_app/modal/get_notification_modal.dart';

class NotificationService {
  final _storage = const FlutterSecureStorage();

  Future<NotificationModal> fetchNotifications({required String userId}) async {
    // Read SID from storage
    String? sid = await _storage.read(key: "sid");

    final uri = Uri.parse(
      "${ApiConstants.baseUrl}auth.get_notification?user_id=$userId",
    );

    final request = http.Request('GET', uri);
    print("NotificationService Request URL: $uri");

    // Add SID cookie if available
    if (sid != null) {
      request.headers['Cookie'] = 'sid=$sid';
    }

    // Add additional headers if needed
    request.headers['Content-Type'] = 'application/json';

    final response = await request.send();
    print("NotificationService Response Status: ${response.statusCode}");
    print("NotificationService Response Body: ${response.reasonPhrase}");

    if (response.statusCode == 200) {
      final String responseString = await response.stream.bytesToString();

      final data = jsonDecode(responseString);

      // ✅ Parse the entire response as NotificationModal
      NotificationModal notificationModal = NotificationModal.fromJson(data);

      return notificationModal;
    } else if (response.statusCode == 401) {
      throw Exception("❌ Unauthorized: Please login again");
    } else if (response.statusCode == 404 || response.statusCode == 417) {
      throw Exception(" No notifications found ");
    } else {
      throw Exception(
        "❌ Failed to load notifications: ${response.statusCode} - ${response.reasonPhrase}",
      );
    }
  }
}
