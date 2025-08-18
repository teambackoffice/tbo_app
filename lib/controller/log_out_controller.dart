import 'package:flutter/material.dart';
import 'package:tbo_app/services/log_out_service.dart';

class LogOutController extends ChangeNotifier {
  final LogOutService _authService = LogOutService();

  bool _isLoading = false;
  String? _logoutMessage;

  bool get isLoading => _isLoading;
  String? get logoutMessage => _logoutMessage;

  Future<void> logout(String username) async {
    _isLoading = true;
    _logoutMessage = null;
    notifyListeners();

    final response = await _authService.logout(username: username);

    if (response["status"] == "error") {
      _logoutMessage = "Logout failed: ${response["message"]}";
    } else {
      _logoutMessage = "Logout successful";
    }

    _isLoading = false;
    notifyListeners();
  }
}
