import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/log_out_controller.dart';
import 'package:tbo_app/controller/login_controller.dart';
import 'package:tbo_app/view/login_page/login_page.dart';

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  final storage = const FlutterSecureStorage();

  Future<Map<String, String?>> _loadProfileData() async {
    final name = await storage.read(key: "username");
    final email = await storage.read(key: "email");
    final phone = await storage.read(key: "mobileNo");
    final employeeId = await storage.read(key: "employee_id");
    final designation = await storage.read(key: "designation");
    final imageUrl = await storage.read(key: "image");

    return {
      "name": name ?? "Unknown",
      "email": email ?? "Not available",
      "phone": phone ?? "Not available",
      "employeeId": employeeId ?? "N/A",
      "designation": designation ?? "Not specified",
      "imageUrl": imageUrl ?? "",
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      body: SingleChildScrollView(
        child: SafeArea(
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
                            profile["imageUrl"] ?? '',
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
                            Container(
                              height: 1,
                              color: const Color(0xFFE5E5E5),
                            ),
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
                            Text(
                              profile["designation"] ?? "",
                              style: const TextStyle(
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
                            _handleLogout(context, profile["email"]!);
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
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, String email) async {
    // ✅ Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C7690),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(
                'Log Out',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );

    // ✅ If user cancelled, return early
    if (confirmed != true || !context.mounted) return;

    // ✅ Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF1C7690)),
      ),
    );

    try {
      final logoutController = context.read<LogOutController>();
      final loginController = context.read<LoginController>();

      // ✅ Use email for logout (or username based on your API)
      final username = email.isNotEmpty ? email : 'user';
      final success = await logoutController.logout(username);

      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();

      if (!context.mounted) return;

      // ✅ Always clear login controller state (even if API failed)
      await loginController.logout();

      if (!context.mounted) return;

      // ✅ Always navigate to login page (local logout always succeeds)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );

      // ✅ Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            logoutController.logoutMessage ?? 'Logged out successfully',
          ),
          backgroundColor: success ? Colors.green : Colors.orange,
        ),
      );
    } catch (e) {
      // Close loading dialog if still open
      if (context.mounted) Navigator.of(context).pop();

      if (!context.mounted) return;

      // ✅ Force logout locally even on error
      try {
        final loginController = context.read<LoginController>();
        await loginController.logout();

        if (!context.mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged Out Successfully'),
            backgroundColor: Colors.orange,
          ),
        );
      } catch (e2) {
        // Last resort error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Logout error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
