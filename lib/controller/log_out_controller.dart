import 'package:flutter/material.dart';
import 'package:tbo_app/services/log_out_service.dart';
import 'package:tbo_app/services/login_service.dart'; // ✅ Import to clear storage

class LogOutController extends ChangeNotifier {
  final LogOutService _authService = LogOutService();
  final LoginService _loginService = LoginService(); // ✅ For clearing storage

  bool _isLoading = false;
  String? _logoutMessage;

  bool get isLoading => _isLoading;
  String? get logoutMessage => _logoutMessage;

  Future<void> logout(String username) async {
    _isLoading = true;
    _logoutMessage = null;
    notifyListeners();

    // ✅ Call logout API (OneSignal unlinking happens inside)
    final response = await _authService.logout(username: username);

    if (response["status"] == "error") {
      _logoutMessage = "Logout failed: ${response["message"]}";
    } else {
      _logoutMessage = "Logout successful";

      // ✅ Clear secure storage after successful logout
      await _loginService.logout();
      print('✅ Local storage cleared');
    }

    _isLoading = false;
    notifyListeners();
  }
}
