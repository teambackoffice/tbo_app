import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
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
      // ✅ Logout from OneSignal FIRST
      try {
        await OneSignal.logout();
      } catch (e) {
        // Continue with logout even if OneSignal fails
      }

      // ✅ Call backend logout API
      final response = await _authService.logout(username: username);

      // ✅ Check for multiple possible response formats
      bool isSuccess = false;

      if (response["status"] == "success" ||
          response["message"]?["success_key"] == 1 ||
          response.containsKey("message") && response["message"] != null) {
        isSuccess = true;
      } else if (response["status"] == "error") {
        _errorMessage = "Logout failed: ${response["message"]}";
      }

      // ✅ Clear local storage regardless of API response
      // (User should be logged out locally even if API fails)
      await _loginService.logout();

      if (isSuccess) {
        _logoutMessage = "Logout Successful";
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        // Even if API failed, we cleared local storage
        _logoutMessage = "Logout Successful";
        _isLoading = false;
        notifyListeners();
        return true; // ✅ Return true because local logout succeeded
      }
    } catch (e) {
      // ✅ Still clear local storage even on exception
      try {
        await _loginService.logout();
        _logoutMessage = "Logout Successful";
        _isLoading = false;
        notifyListeners();
        return true; // ✅ Return true because local logout succeeded
      } catch (storageError) {
        _errorMessage = "Logout error: ${e.toString()}";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    }
  }

  /// Quick logout (clears local data without API call)
  /// Use this if backend logout fails but you still want to log user out locally
  Future<void> quickLogout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // ✅ Logout from OneSignal
      try {
        await OneSignal.logout();
      } catch (e) {}

      await _loginService.logout();
      _logoutMessage = "Logout Successful";
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
