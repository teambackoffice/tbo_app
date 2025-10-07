import 'package:flutter/material.dart';
import 'package:tbo_app/services/log_out_service.dart';
import 'package:tbo_app/services/login_service.dart';

class LogOutController extends ChangeNotifier {
  final LogOutService _authService = LogOutService();
  final LoginService _loginService = LoginService();

  bool _isLoading = false;
  String? _logoutMessage;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get logoutMessage => _logoutMessage;
  String? get errorMessage => _errorMessage;

  /// Logout user from backend and OneSignal
  Future<bool> logout(String username) async {
    _isLoading = true;
    _logoutMessage = null;
    _errorMessage = null;
    notifyListeners();

    try {
      // ✅ Call logout API (OneSignal unlinking happens inside LogOutService)
      final response = await _authService.logout(username: username);

      if (response["status"] == "error") {
        _errorMessage = "Logout failed: ${response["message"]}";
        _isLoading = false;
        notifyListeners();
        return false;
      } else {
        _logoutMessage = "Logout successful";

        // ✅ Clear secure storage after successful logout
        await _loginService.logout();

        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = "Logout error: ${e.toString()}";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Quick logout (clears local data without API call)
  /// Use this if backend logout fails but you still want to log user out locally
  Future<void> quickLogout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loginService.logout();
      _logoutMessage = "Logged out locally";
    } catch (e) {
      _errorMessage = "Quick logout error: ${e.toString()}";
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear logout message
  void clearMessage() {
    _logoutMessage = null;
    notifyListeners();
  }

  /// Reset controller state
  void reset() {
    _isLoading = false;
    _logoutMessage = null;
    _errorMessage = null;
    notifyListeners();
  }
}
