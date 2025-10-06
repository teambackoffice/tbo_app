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

    // Add SID cookie if available
    if (sid != null) {
      request.headers['Cookie'] = 'sid=$sid';
    }

    // Add additional headers if needed
    request.headers['Content-Type'] = 'application/json';

    final response = await request.send();

    if (response.statusCode == 200) {
      final String responseString = await response.stream.bytesToString();
      print(uri);
      print("✅ Raw Response: $responseString");

      final data = jsonDecode(responseString);

      // ✅ Parse the entire response as NotificationModal
      NotificationModal notificationModal = NotificationModal.fromJson(data);

      print(
        "🔔 Total notifications: ${notificationModal.message.message.title.length}",
      );

      return notificationModal;
    } else if (response.statusCode == 401) {
      throw Exception("❌ Unauthorized: Please login again");
    } else if (response.statusCode == 404) {
      throw Exception("❌ Notifications not found");
    } else {
      throw Exception(
        "❌ Failed to load notifications: ${response.statusCode} - ${response.reasonPhrase}",
      );
    }
  }

  // Optional: Mark notification as read on backend
  Future<void> markNotificationAsRead({
    required String userId,
    required String notificationId,
  }) async {
    String? sid = await _storage.read(key: "sid");

    final uri = Uri.parse("${ApiConstants.baseUrl}auth.mark_notification_read");

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (sid != null) 'Cookie': 'sid=$sid',
      },
      body: jsonEncode({'user_id': userId, 'notification_id': notificationId}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to mark notification as read");
    }
  }

  // Optional: Delete notification
  Future<void> deleteNotification({
    required String userId,
    required String notificationId,
  }) async {
    String? sid = await _storage.read(key: "sid");

    final uri = Uri.parse("${ApiConstants.baseUrl}auth.delete_notification");

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (sid != null) 'Cookie': 'sid=$sid',
      },
      body: jsonEncode({'user_id': userId, 'notification_id': notificationId}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete notification");
    }
  }
}
