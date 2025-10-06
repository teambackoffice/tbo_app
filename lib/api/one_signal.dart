// lib/api/one_signal.dart
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:tbo_app/main.dart';

// ✅ TODO: Import your actual page widgets here
// Example:
// import 'package:tbo_app/view/tasks/task_detail_page.dart';
// import 'package:tbo_app/view/projects/project_detail_page.dart';
// import 'package:tbo_app/view/notifications/notification_list_page.dart';

class OneSignalService {
  static final OneSignalService _instance = OneSignalService._internal();
  factory OneSignalService() => _instance;
  OneSignalService._internal();

  static const String appId = "6a1f3d55-06a2-4260-81fd-95f4f41ab003";

  Future<void> initialize() async {
    debugPrint('🔔 Initializing OneSignal...');

    // Enable verbose logging for debugging
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    // Initialize OneSignal
    OneSignal.initialize(appId);

    // Request notification permissions
    await OneSignal.Notifications.requestPermission(true);

    // Set up notification click handler
    OneSignal.Notifications.addClickListener(_handleNotificationOpened);

    // Set up foreground notification handler
    OneSignal.Notifications.addForegroundWillDisplayListener(
      _handleNotificationReceived,
    );

    debugPrint('✅ OneSignal initialized successfully');
  }

  // Set external user ID (called after login)
  Future<void> setExternalUserId(String userId) async {
    await OneSignal.login(userId);
    debugPrint('✅ OneSignal user linked: $userId');
  }

  // Remove external user ID (called on logout)
  Future<void> removeExternalUserId() async {
    await OneSignal.logout();
    debugPrint('✅ OneSignal user unlinked');
  }

  // Get OneSignal player/subscription ID
  String? getPlayerId() {
    return OneSignal.User.pushSubscription.id;
  }

  // Handle notification tap (when user clicks notification)
  void _handleNotificationOpened(OSNotificationClickEvent event) {
    debugPrint('📱 Notification clicked!');
    debugPrint('   ID: ${event.notification.notificationId}');
    debugPrint('   Title: ${event.notification.title}');
    debugPrint('   Body: ${event.notification.body}');
    debugPrint('   Data: ${event.notification.additionalData}');

    // Navigate based on notification data
    _navigateBasedOnNotification(event.notification);
  }

  // Handle notification received in foreground
  void _handleNotificationReceived(OSNotificationWillDisplayEvent event) {
    debugPrint('📬 Notification received in foreground');
    debugPrint('   Title: ${event.notification.title}');
    debugPrint('   Body: ${event.notification.body}');

    // Display the notification
    event.notification.display();

    // To prevent showing notification, uncomment:
    // event.preventDefault();
  }

  // Navigate to screens based on notification data
  void _navigateBasedOnNotification(OSNotification notification) {
    final context = navigatorKey.currentContext;
    if (context == null) {
      debugPrint('❌ Navigation context is null');
      return;
    }

    final additionalData = notification.additionalData;
    if (additionalData == null || additionalData.isEmpty) {
      debugPrint('⚠️ No additional data in notification');
      return;
    }

    // Extract navigation data
    final type = additionalData['type'] as String?;
    final id = additionalData['id'] as String?;

    debugPrint('🧭 Navigating to: type=$type, id=$id');

    // ✅ TODO: Uncomment and customize based on your app's pages
    switch (type) {
      case 'task':
        debugPrint('→ Navigate to task: $id');
        // Uncomment when you have the page:
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => TaskDetailPage(taskId: id ?? ''),
        //   ),
        // );

        // Temporary: Show dialog for testing
        _showTestDialog(context, 'Task', id);
        break;

      case 'project':
        debugPrint('→ Navigate to project: $id');
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => ProjectDetailPage(projectId: id ?? ''),
        //   ),
        // );

        _showTestDialog(context, 'Project', id);
        break;

      case 'lead':
        debugPrint('→ Navigate to lead: $id');
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => LeadDetailPage(leadId: id ?? ''),
        //   ),
        // );

        _showTestDialog(context, 'Lead', id);
        break;

      case 'notification':
        debugPrint('→ Navigate to notifications');
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => NotificationListPage(),
        //   ),
        // );

        _showTestDialog(context, 'Notification', null);
        break;

      case 'timesheet':
        debugPrint('→ Navigate to timesheet');
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => TimesheetPage(),
        //   ),
        // );

        _showTestDialog(context, 'Timesheet', null);
        break;

      default:
        debugPrint('⚠️ Unknown notification type: $type');
        break;
    }
  }

  // Temporary test dialog (remove when you add real navigation)
  void _showTestDialog(BuildContext context, String type, String? id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('🔔 Notification Tapped'),
        content: Text(
          'Type: $type\n${id != null ? 'ID: $id' : ''}',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Subscribe to push notifications
  Future<void> subscribeToPush() async {
    await OneSignal.User.pushSubscription.optIn();
    debugPrint('✅ Subscribed to push notifications');
  }

  // Unsubscribe from push notifications
  Future<void> unsubscribeFromPush() async {
    await OneSignal.User.pushSubscription.optOut();
    debugPrint('✅ Unsubscribed from push notifications');
  }

  // Add tags for user targeting
  Future<void> sendTags(Map<String, String> tags) async {
    OneSignal.User.addTags(tags);
    debugPrint('✅ Tags added: $tags');
  }

  // Remove tags
  Future<void> removeTags(List<String> keys) async {
    OneSignal.User.removeTags(keys);
    debugPrint('✅ Tags removed: $keys');
  }
}
