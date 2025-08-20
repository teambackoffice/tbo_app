import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/log_out_controller.dart';
import 'package:tbo_app/controller/login_controller.dart';

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      body: SafeArea(
        child: Padding(
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
                      'https://media.istockphoto.com/id/1481165140/photo/portrait-of-biracial-young-woman-smiling-and-using-laptop-in-bright-contemporary-office.jpg?s=612x612&w=0&k=20&c=p4WaudLa74dVkawzcjLnEqDnIO5EE7IZaJzUqav8wfE=',
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

                // Name and Designation - Special styling
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
                      const Text(
                        "Sabisha",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 1,
                        width: double.infinity,
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
                      const Text(
                        "Digital Marketing Manager",
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

                // Phone, Email, and Employee ID - Combined container
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
                      const Text(
                        "+91 8129904187",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: const Color(0xFFE5E5E5),
                      ),
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
                      const Text(
                        "sabisha@gmail.com",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: const Color(0xFFE5E5E5),
                      ),
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
                      const Text(
                        "TB044273336",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2D2D2D),
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
                      _handleLogout(context);
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
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
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
                  await logoutController.logout("Admin");

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
