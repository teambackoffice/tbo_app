import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/log_out_controller.dart';
import 'package:tbo_app/controller/login_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  final storage = const FlutterSecureStorage();

  Future<Map<String, String?>> _loadProfileData() async {
    final name = await storage.read(key: "username");
    final email = await storage.read(key: "email");
    final phone = await storage.read(key: "phone");
    final employeeId = await storage.read(key: "employeeId");

    return {
      "name": name ?? "Unknown",
      "email": email ?? "Not available",
      "phone": phone ?? "Not available",
      "employeeId": employeeId ?? "N/A",
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      body: SafeArea(
        child: FutureBuilder<Map<String, String?>>(
          future: _loadProfileData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF1C7690)),
              );
            }

            final profile = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Profile Picture
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFB8E6E6), Color(0xFF9DD6D6)],
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Name + Designation
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF8E8E8E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            profile["name"]!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(height: 1, color: Color(0xFFE5E5E5)),
                          const SizedBox(height: 16),
                          const Text(
                            "Designation",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF8E8E8E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Web Designer", // you can also store this in secure storage
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Phone, Email, Employee ID
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Phone",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF8E8E8E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            profile["phone"]!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 10),
                          const Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF8E8E8E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            profile["email"]!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 10),
                          const Text(
                            "Employee ID",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF8E8E8E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            profile["employeeId"]!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Log Out Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          _handleLogout(context, profile["name"]!);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C7690),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context, String username) {
    final parentContext = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C7690),
                foregroundColor: Color(0xFF1C7690),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () async {
                // Close confirmation dialog
                Navigator.of(dialogContext).pop();

                // Show loading dialog
                showDialog(
                  context: parentContext,
                  barrierDismissible: false,
                  builder: (_) => const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1C7690)),
                  ),
                );

                try {
                  final logoutController = Provider.of<LogOutController>(
                    parentContext,
                    listen: false,
                  );
                  final loginController = Provider.of<LoginController>(
                    parentContext,
                    listen: false,
                  );

                  // clear session from API / storage
                  await logoutController.logout("Employee");

                  // update login state so AuthWrapper rebuilds
                  await loginController.clearSession();

                  if (parentContext.mounted) {
                    Navigator.of(parentContext).pop(); // close loading
                    // ✅ No manual navigation needed, AuthWrapper will now show LoginPage
                  }
                } catch (e) {
                  if (parentContext.mounted) {
                    Navigator.of(parentContext).pop(); // close loading
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      const SnackBar(
                        content: Text("Failed to log out. Please try again."),
                      ),
                    );
                  }
                }
              },

              child: const Text(
                'Log Out',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
