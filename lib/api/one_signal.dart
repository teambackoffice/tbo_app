import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalApi {
  static Future<void> initOneSignal() async {
    // Replace with your OneSignal App ID
    const String oneSignalAppId = "6a1f3d55-06a2-4260-81fd-95f4f41ab003";

    // Debug logs
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    // Initialize OneSignal
    OneSignal.initialize(oneSignalAppId);

    // Request permission on iOS
    OneSignal.Notifications.requestPermission(true);

    // ✅ Foreground notification listener
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      event.preventDefault();
      event.notification.display();
    });

    // ✅ Notification click listener
    OneSignal.Notifications.addClickListener((event) {
      print("Notification clicked: ${event.notification.jsonRepresentation()}");
      // You can navigate user based on custom data here
    });

    // ✅ Subscription changes listener
    OneSignal.User.pushSubscription.addObserver((state) {
      print("Push subscription changed: ${state.jsonRepresentation()}");
    });
  }
}
