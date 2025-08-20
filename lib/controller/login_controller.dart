import 'package:flutter/material.dart';
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

  // Updated login method that returns result instead of navigating
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

      // Get the role profile name from storage
      currentRole = await _loginService.getStoredRoleProfileName();

      notifyListeners();

      // Return success with role information
      return {"success": true, "role": currentRole};
    } else {
      errorMessage = result?["error"] ?? "Login failed";
      notifyListeners();

      // Return failure
      return {"success": false, "error": errorMessage};
    }
  }

  Future<void> loadStoredSession() async {
    final sid = await _loginService.getStoredSid();
    if ((sid ?? '').isNotEmpty) {
      isLoggedIn = true;
      currentRole = await _loginService.getStoredRoleProfileName();
    }
    notifyListeners();
  }

  Future<Widget?> getInitialPage() async {
    final sid = await _loginService.getStoredSid();
    if ((sid ?? '').isEmpty) {
      return null;
    }

    final role = await _loginService.getStoredRoleProfileName();
    if (role == null) {
      return null;
    }

    switch (role.toLowerCase()) {
      case 'Admin':
      case 'administrator':
        return const AdminBottomNavigation(); // Replace with your admin page
      case 'CRM':
      case 'supervisor':
        return const CRMBottomNavigation(); // Replace with your manager page
      case 'Employee':
      case 'user':
      case 'staff':
        return const EmployeeBottomNavigation(); // Replace with your employee page
      default:
        return null;
    }
  }

  Future<void> logout() async {
    await _loginService.logout();
    isLoggedIn = false;
    currentRole = null;
    notifyListeners();
  }

  Future<void> clearSession() async => logout();
}
