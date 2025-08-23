import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/all_lead_list_controller.dart';
import 'package:tbo_app/controller/log_out_controller.dart';
import 'package:tbo_app/controller/login_controller.dart';
import 'package:tbo_app/controller/project_list_controller.dart';
import 'package:tbo_app/controller/task_list_controller.dart';
import 'package:tbo_app/view/admin/bottom_navigation/bottom_navigation_admin.dart';
import 'package:tbo_app/view/crm/bottom_navigation/bottom_navigation.dart';
import 'package:tbo_app/view/employee/bottom_navigation/bottom_navigation_emply.dart';
import 'package:tbo_app/view/login_page/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginController>(
          create: (_) => LoginController(),
        ),
        ChangeNotifierProvider<LogOutController>(
          create: (_) => LogOutController(),
        ),
        ChangeNotifierProvider<GetProjectListController>(
          create: (_) => GetProjectListController(),
        ),
        ChangeNotifierProvider<TaskListController>(
          create: (_) => TaskListController(),
        ),
        ChangeNotifierProvider<AllLeadListController>(
          create: (_) => AllLeadListController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _checkStoredSession();
  }

  Future<void> _checkStoredSession() async {
    final authController = context.read<LoginController>();
    await authController.loadStoredSession();

    if (mounted) {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  // Method to get the appropriate widget based on role
  Widget _getHomePageBasedOnRole(String? role) {
    if (role == null) {
      return const LoginPage();
    }

    switch (role.toLowerCase()) {
      case 'admin':
      case 'administrator':
        return const AdminBottomNavigation();
      case 'crm':
      case 'supervisor':
        return const CRMBottomNavigation();
      case 'employee':
      case 'user':
      case 'staff':
        return const EmployeeBottomNavigation();
      default:
        return const LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking stored session
    if (_isInitializing) {
      return const Scaffold(
        backgroundColor: Color(0xFFFAF9F6),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF1C7690)),
        ),
      );
    }

    return Consumer<LoginController>(
      builder: (context, authController, child) {
        // ✅ If user is logged in, navigate based on role
        if (authController.isLoggedIn) {
          return _getHomePageBasedOnRole(authController.currentRole);
        }

        // ✅ If not logged in, show login page
        return const LoginPage();
      },
    );
  }
}
