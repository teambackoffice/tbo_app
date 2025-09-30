import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class FirebaseApi {
  final firebaseMessaging = FirebaseMessaging.instance;
  String? _fcmToken;

  String? get fcmToken => _fcmToken;

  Future<void> initNotification() async {
    try {
      // Request permission
      final settings = await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');

        // iOS APNs token (only for iOS)
        if (Platform.isIOS) {
          final apnsToken = await firebaseMessaging.getAPNSToken();
          if (apnsToken != null) {
            print("APNs Token: $apnsToken");
          } else {
            print("Waiting for APNs token...");
            // Sometimes APNs token takes time, retry after delay
            await Future.delayed(const Duration(seconds: 3));
            final retryToken = await firebaseMessaging.getAPNSToken();
            print("APNs Token (retry): $retryToken");
          }
        }

        // Get FCM token
        _fcmToken = await firebaseMessaging.getToken();
        print("FCM Token: $_fcmToken");

        // TODO: Send token to your backend server
        if (_fcmToken != null) {
          await _sendTokenToServer(_fcmToken!);
        }

        // Listen for token refresh
        firebaseMessaging.onTokenRefresh.listen((newToken) {
          print("Refreshed FCM Token: $newToken");
          _fcmToken = newToken;
          _sendTokenToServer(newToken);
        });

        // Handle notification when app is opened from terminated state
        FirebaseMessaging.instance.getInitialMessage().then((message) {
          if (message != null) {
            _handleMessageClick(message);
          }
        });

        // Handle notification when app is in background
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
          _handleMessageClick(message);
        });
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }
    } catch (e) {
      print("Error initializing notifications: $e");
    }
  }

  Future<void> _sendTokenToServer(String token) async {
    try {
      // TODO: Implement your API call to save token to backend
      // Example:
      // await http.post(
      //   Uri.parse('YOUR_API_URL/save-fcm-token'),
      //   body: {'fcm_token': token, 'user_id': userId},
      // );
      print("Token should be sent to server: $token");
    } catch (e) {
      print("Error sending token to server: $e");
    }
  }

  void _handleMessageClick(RemoteMessage message) {
    print("Notification clicked: ${message.data}");

    final context = navigatorKey.currentState?.overlay?.context;
    if (context != null) {
      if (message.data.containsKey('sales_return')) {
        // Navigate to specific screen
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (_) => YourTargetScreen()),
        // );
      }
    }
  }
}
