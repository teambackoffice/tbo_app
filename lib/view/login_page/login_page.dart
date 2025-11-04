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
  bool _obscurePassword = true;

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
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 Logo Section
              Column(
                children: [
                  CircleAvatar(
                    radius: 60, // 👈 same as 90x90 container
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/TBO Smart_Logo_New.jpg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Welcome !",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Sign in to continue",
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // 🔹 Login Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C7690),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Username Field
                    TextField(
                      controller: _loginIdController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        prefixIcon: const Icon(Icons.person_outline),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF1C7690),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 26),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authController.isLoading
                            ? null
                            : () async {
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

                                final result = await authController.login(
                                  _loginIdController.text.trim(),
                                  _passwordController.text.trim(),
                                );

                                if (!mounted) return;

                                if (result != null &&
                                    result["success"] == true) {
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
                                      nextPage =
                                          const EmployeeBottomNavigation();
                                      break;
                                    default:
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Unknown user role'),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                      return;
                                  }

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (_) => nextPage),
                                    (route) => false,
                                  );
                                } else {
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
                          elevation: 3,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: authController.isLoading
                            ? const DotsLoading()
                            : const Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DotsLoading extends StatefulWidget {
  final Color color;
  const DotsLoading({super.key, this.color = const Color(0xFF1C7690)});

  @override
  State<DotsLoading> createState() => _DotsLoadingState();
}

class _DotsLoadingState extends State<DotsLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            double opacity = (1 - ((_animation.value + index / 3) % 1)).clamp(
              0.2,
              1,
            );
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: widget.color.withOpacity(opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
