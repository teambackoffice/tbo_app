import 'package:flutter/material.dart';
import 'package:tbo_app/services/login_service.dart';

class LoginController with ChangeNotifier {
  final LoginService _authService = LoginService();

  bool isLoading = false;
  String? errorMessage;
  String? sid;
  String? username;

  Future<void> login(String usr, String pwd) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _authService.loginUser(username: usr, password: pwd);

    isLoading = false;
    if (result != null && result["error"] == null) {
      sid = result["sid"];
      username = usr;
      notifyListeners();
    } else {
      errorMessage = result?["error"] ?? "Login failed";
      notifyListeners();
    }
  }

  Future<void> loadStoredSession() async {
    sid = await _authService.getStoredSid();
    username = await _authService.getStoredUsername();
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    sid = null;
    username = null;
    notifyListeners();
  }

  bool get isLoggedIn => sid != null && username != null;
}
