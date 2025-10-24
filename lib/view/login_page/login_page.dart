import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/login_controller.dart';
import 'package:tbo_app/view/admin/bottom_navigation/bottom_navigation_admin.dart';
import 'package:tbo_app/view/crm/bottom_navigation/bottom_navigation.dart';
import 'package:tbo_app/view/employee/bottom_navigation/bottom_navigation_emply.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true; // 🔒 password visibility state

  @override
  void dispose() {
    _loginIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<LoginController>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 50),

              // Login ID field
              TextField(
                controller: _loginIdController,
                decoration: InputDecoration(
                  hintText: "Username",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password field with show/hide
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFF1C7690),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword; // toggle
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🔑 Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authController.isLoading
                      ? null
                      : () async {
                          // ✅ Validate inputs
                          if (_loginIdController.text.trim().isEmpty ||
                              _passwordController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter username and password',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // ✅ Perform login
                          final result = await authController.login(
                            _loginIdController.text.trim(),
                            _passwordController.text.trim(),
                          );

                          if (!mounted) return;

                          // ✅ Handle navigation based on result
                          if (result != null && result["success"] == true) {
                            final role = result["role"]?.toLowerCase();
                            Widget nextPage;

                            switch (role) {
                              case 'admin':
                              case 'administrator':
                                nextPage = const AdminBottomNavigation();
                                break;
                              case 'crm':
                              case 'supervisor':
                                nextPage = const CRMBottomNavigation();
                                break;
                              case 'employee':
                              case 'user':
                              case 'staff':
                                nextPage = const EmployeeBottomNavigation();
                                break;
                              default:
                                // Unknown role, stay on login
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Unknown user role'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                                return;
                            }

                            // ✅ Navigate and remove all previous routes
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => nextPage),
                              (route) => false,
                            );
                          } else {
                            // Show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  result?["error"] ??
                                      authController.errorMessage ??
                                      "Login failed",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C7690),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: authController.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Error message (optional, since we're using SnackBar)
              if (authController.errorMessage != null)
                Text(
                  authController.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
