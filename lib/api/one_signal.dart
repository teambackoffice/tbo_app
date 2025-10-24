import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  // ✅ Your OneSignal App credentials
  static const String appId = "6a1f3d55-06a2-4260-81fd-95f4f41ab003";
  static const String restApiKey =
      "os_v2_app_nipt2vigujbgbap5sx2pigvqanwideo76a2uupniuezdlomuxqt4zl353yozehjua5jocgdve36ceusldohpxqxtkhjjvobdr45ic4q"; // Get from OneSignal dashboard

  // ============================================
  // USER MANAGEMENT
  // ============================================

  /// Login user with external ID (email)
  Future<void> loginUser(String email) async {
    try {
      await OneSignal.login(email);
    } catch (e) {
      rethrow;
    }
  }

  /// Logout current user
  Future<void> logoutUser() async {
    try {
      await OneSignal.logout();
    } catch (e) {
      rethrow;
    }
  }

  /// Remove external user ID (legacy method - use logout instead)
  Future<void> removeExternalUserId() async {
    await logoutUser();
  }

  // ============================================
  // USER PROPERTIES
  // ============================================

  /// Set user email
  Future<void> setUserEmail(String email) async {
    try {
      await OneSignal.User.addEmail(email);
    } catch (e) {}
  }

  /// Add tags for user segmentation
  Future<void> sendTags(Map<String, String> tags) async {
    try {
      await OneSignal.User.addTags(tags);
    } catch (e) {}
  }

  /// Remove specific tags
  Future<void> removeTags(List<String> tagKeys) async {
    try {
      await OneSignal.User.removeTags(tagKeys);
    } catch (e) {}
  }

  // ============================================
  // SUBSCRIPTION MANAGEMENT
  // ============================================

  /// Get current player/subscription ID
  String? getPlayerId() {
    return OneSignal.User.pushSubscription.id;
  }

  /// Get push token
  String? getPushToken() {
    return OneSignal.User.pushSubscription.token;
  }

  /// Check if user is subscribed
  bool isSubscribed() {
    return OneSignal.User.pushSubscription.optedIn!;
  }

  /// Opt user into push notifications
  Future<void> optIn() async {
    await OneSignal.User.pushSubscription.optIn();
  }

  /// Opt user out of push notifications
  Future<void> optOut() async {
    await OneSignal.User.pushSubscription.optOut();
  }

  // ============================================
  // SEND NOTIFICATIONS (via REST API)
  // ============================================

  /// Send notification to specific user by email
  Future<bool> sendNotificationToEmail({
    required String email,
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://onesignal.com/api/v1/notifications'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Basic $restApiKey',
        },
        body: jsonEncode({
          'app_id': appId,
          'include_aliases': {
            'external_id': [email],
          },
          'target_channel': 'push',
          'headings': {'en': title},
          'contents': {'en': message},
          'data': data ?? {},
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Send notification to specific user by Player ID
  Future<bool> sendNotificationToPlayerId({
    required String playerId,
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://onesignal.com/api/v1/notifications'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Basic $restApiKey',
        },
        body: jsonEncode({
          'app_id': appId,
          'include_subscription_ids': [playerId],
          'headings': {'en': title},
          'contents': {'en': message},
          'data': data ?? {},
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Send notification to users with specific tags
  Future<bool> sendNotificationToTags({
    required List<Map<String, dynamic>> filters,
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://onesignal.com/api/v1/notifications'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Basic $restApiKey',
        },
        body: jsonEncode({
          'app_id': appId,
          'filters': filters,
          'headings': {'en': title},
          'contents': {'en': message},
          'data': data ?? {},
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Send task assignment notification
  Future<bool> sendTaskAssignmentNotification({
    required String employeeEmail,
    required String taskSubject,
    required String taskId,
    required String assignerName,
  }) async {
    return await sendNotificationToEmail(
      email: employeeEmail,
      title: 'New Task Assigned',
      message: '$assignerName assigned you: $taskSubject',
      data: {
        'type': 'task_assignment',
        'taskId': taskId,
        'taskSubject': taskSubject,
        'assignerName': assignerName,
      },
    );
  }

  // ============================================
  // IN-APP MESSAGING
  // ============================================

  /// Add trigger for in-app messages
  Future<void> addTrigger(String key, String value) async {
    await OneSignal.InAppMessages.addTrigger(key, value);
  }

  /// Remove trigger
  Future<void> removeTrigger(String key) async {
    await OneSignal.InAppMessages.removeTrigger(key);
  }

  /// Pause in-app messages
  void pauseInAppMessages() {
    OneSignal.InAppMessages.paused(true);
  }

  /// Resume in-app messages
  void resumeInAppMessages() {
    OneSignal.InAppMessages.paused(false);
  }
}
