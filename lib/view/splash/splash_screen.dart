import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/login_controller.dart';
import 'package:tbo_app/view/admin/bottom_navigation/bottom_navigation_admin.dart';
import 'package:tbo_app/view/crm/bottom_navigation/bottom_navigation.dart';
import 'package:tbo_app/view/employee/bottom_navigation/bottom_navigation_emply.dart';
import 'package:tbo_app/view/login_page/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // ✅ Wait for OneSignal to be fully initialized (if needed)
      await Future.delayed(const Duration(milliseconds: 500));

      final loginController = context.read<LoginController>();

      // ✅ Load stored session and wait for completion
      await loginController.loadStoredSession();

      // ✅ Show splash for at least 2 seconds total
      await Future.delayed(const Duration(milliseconds: 1500));

      if (!mounted) return;

      // Navigate based on login and role
      Widget nextPage;
      if (loginController.isLoggedIn) {
        final role = loginController.currentRole?.toLowerCase();
        switch (role) {
          case 'admin':
          case 'administrator':
            nextPage = const AdminBottomNavigation();
            break;
          case 'crm':
          case 'supervisor':
          case 'bde':
            nextPage = const CRMBottomNavigation();
            break;
          case 'employee':
          case 'user':
          case 'staff':
          case 'regular employee':
            nextPage = const EmployeeBottomNavigation();
            break;
          default:
            nextPage = const LoginPage();
        }
      } else {
        nextPage = const LoginPage();
      }

      // ✅ Use pushAndRemoveUntil to prevent back navigation to splash
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => nextPage),
        (route) => false,
      );
    } catch (e) {
      // If any error occurs, navigate to login
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: CircleAvatar(
            radius: 90,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Image.asset(
                "assets/TBO Smart_Logo_New.jpg",
                fit: BoxFit.cover,
                width: 150,
                height: 150,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
