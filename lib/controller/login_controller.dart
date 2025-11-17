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
  String? currentRole;
  String? userName; // ✅ Added for notification purposes
  String? userEmail; // ✅ Added for OneSignal

  /// Login method
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
      isLoggedIn = true;

      // Get stored session data
      currentRole = await _loginService.getStoredRoleProfileName();
      userName = await _loginService.getStoredFullName();
      userEmail = await _loginService.getStoredEmail();

      // ✅ Log OneSignal player ID for debugging
      final playerId = OneSignal.User.pushSubscription.id;

      notifyListeners();

      // Return success with role information
      return {
        "success": true,
        "role": currentRole,
        "email": userEmail,
        "name": userName,
      };
    } else {
      errorMessage = result?["error"] ?? "Login failed";
      notifyListeners();

      // Return failure
      return {"success": false, "error": errorMessage};
    }
  }

  /// Load stored session on app start
  Future<void> loadStoredSession() async {
    final sid = await _loginService.getStoredSid();
    if ((sid ?? '').isNotEmpty) {
      isLoggedIn = true;
      currentRole = await _loginService.getStoredRoleProfileName();
      userName = await _loginService.getStoredFullName();
      userEmail = await _loginService.getStoredEmail();

      // ✅ Re-login to OneSignal if session exists
      if (userEmail != null && userEmail!.isNotEmpty) {
        try {
          await OneSignal.login(userEmail!);
        } catch (e) {}
      }

      notifyListeners();
    }
  }

  /// Get initial page based on role
  Future<Widget?> getInitialPage() async {
    final sid = await _loginService.getStoredSid();
    if ((sid ?? '').isEmpty) {
      return null;
    }

    final role = await _loginService.getStoredRoleProfileName();
    if (role == null) {
      return null;
    }

    return _getPageForRole(role);
  }

  /// Get widget for specific role
  Widget? _getPageForRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
      case 'administrator':
        return const AdminBottomNavigation();
      case 'crm':
      case 'supervisor':
        return const CRMBottomNavigation();
      case 'employee':
      case 'regular employee':
      case 'user':
      case 'staff':
        return const EmployeeBottomNavigation();
      default:
        return null;
    }
  }

  /// Logout user
  Future<void> logout() async {
    await _loginService.logout();
    isLoggedIn = false;
    currentRole = null;
    userName = null;
    userEmail = null;
    errorMessage = null;

    notifyListeners();
  }

  /// Clear session (alias for logout)
  Future<void> clearSession() async => logout();

  /// Check if user has specific role
  bool hasRole(String role) {
    return currentRole?.toLowerCase() == role.toLowerCase();
  }

  /// Check if user is admin
  bool get isAdmin => hasRole('admin') || hasRole('administrator');

  /// Check if user is CRM
  bool get isCRM => hasRole('crm') || hasRole('supervisor');

  /// Check if user is employee
  bool get isEmployee =>
      hasRole('employee') || hasRole('user') || hasRole('staff');
}
