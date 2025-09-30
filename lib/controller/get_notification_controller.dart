import 'package:flutter/material.dart';
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

  Future<void> loadNotifications({required String userId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notificationModal = await _service.fetchNotifications(userId: userId);
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
}
