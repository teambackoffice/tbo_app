import 'package:flutter/material.dart';
import 'package:tbo_app/api/one_signal.dart';
import 'package:tbo_app/modal/get_notification_modal.dart';
import 'package:tbo_app/services/get_notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationModal? _notificationModal;
  bool _isLoading = false;
  String? _errorMessage;

  NotificationModal? get notificationModal => _notificationModal;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final NotificationService _service = NotificationService();

  // Get unread count
  int get unreadCount {
    if (_notificationModal == null) return 0;
    return _notificationModal!.message.message.title
        .where((notif) => !notif.isRead)
        .length;
  }

  Future<void> loadNotifications({required String userId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notificationModal = await _service.fetchNotifications(userId: userId);

      // Set OneSignal external user ID
      await OneSignalService().setExternalUserId(userId);

      print(
        "✅ Loaded ${_notificationModal?.message.message.title.length ?? 0} notifications",
      );
    } catch (e) {
      _errorMessage = e.toString();
      print("❌ Error: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mark single notification as read
  void markAsRead(int index) {
    if (_notificationModal != null &&
        index < _notificationModal!.message.message.title.length) {
      _notificationModal!.message.message.title[index].isRead = true;
      notifyListeners();
    }
  }

  // Mark all notifications as read
  void markAllAsRead() {
    if (_notificationModal != null) {
      for (var notif in _notificationModal!.message.message.title) {
        notif.isRead = true;
      }
      notifyListeners();
    }
  }

  // Refresh notifications (for pull-to-refresh)
  Future<void> refreshNotifications(String userId) async {
    await loadNotifications(userId: userId);
  }

  // Handle new notification from OneSignal
  void handleNewNotification() {
    // Increment badge or show indicator
    notifyListeners();
  }

  // Logout - remove OneSignal user ID
  Future<void> logout() async {
    await OneSignalService().removeExternalUserId();
    _notificationModal = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Clear notifications
  void clearNotifications() {
    _notificationModal = null;
    _errorMessage = null;
    notifyListeners();
  }
}
