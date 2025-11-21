import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:tbo_app/services/login_service.dart';
import 'package:tbo_app/view/admin/bottom_navigation/bottom_navigation_admin.dart';
import 'package:tbo_app/view/crm/bottom_navigation/bottom_navigation.dart';
import 'package:tbo_app/view/employee/bottom_navigation/bottom_navigation_emply.dart';

class LoginController with ChangeNotifier {
  final LoginService _loginService = LoginService();

  bool isLoading = false;
  bool isLoggedIn = false;
  String? errorMessage;
  String? currentSmartRole;
  String? userName;
  String? userEmail;

  /// LOGIN USER
  Future<Map<String, dynamic>?> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _loginService.loginUser(
      username: username,
      password: password,
    );

    isLoading = false;

    if (result != null && result["data"]?["message"]?["success_key"] == 1) {
      currentSmartRole = await _loginService.getStoredSmartRole();
      userName = await _loginService.getStoredFullName();
      userEmail = await _loginService.getStoredEmail();

      // Smart role must exist
      if (currentSmartRole == null || currentSmartRole!.isEmpty) {
        errorMessage = "No role assigned";
        notifyListeners();
        return {"success": false, "error": "No role assigned"};
      }

      isLoggedIn = true;
      notifyListeners();

      return {
        "success": true,
        "smart_role": currentSmartRole,
        "email": userEmail,
        "name": userName,
      };
    } else {
      errorMessage = result?["error"] ?? "Login failed";
      notifyListeners();
      return {"success": false, "error": errorMessage};
    }
  }

  /// ⭐ THIS WAS MISSING — LOAD SESSION ON APP START
  Future<void> loadStoredSession() async {
    final sid = await _loginService.getStoredSid();

    if (sid != null && sid.isNotEmpty) {
      isLoggedIn = true;
      currentSmartRole = await _loginService.getStoredSmartRole();
      userName = await _loginService.getStoredFullName();
      userEmail = await _loginService.getStoredEmail();

      // Auto-login to OneSignal if email exists
      if (userEmail != null && userEmail!.isNotEmpty) {
        try {
          await OneSignal.login(userEmail!);
        } catch (_) {}
      }
    } else {
      isLoggedIn = false;
    }

    notifyListeners();
  }

  /// RETURN PAGE BASED ON SMART ROLE
  Widget? getPageFromSmartRole(String role) {
    switch (role.toLowerCase().trim()) {
      case 'tbo smart admin':
        return const AdminBottomNavigation();
      case 'tbo smart crm':
        return const CRMBottomNavigation();
      case 'tbo smart user':
        return const EmployeeBottomNavigation();
      default:
        return null;
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    await _loginService.logout();
    isLoggedIn = false;
    currentSmartRole = null;
    userName = null;
    userEmail = null;
    errorMessage = null;
    notifyListeners();
  }
}
