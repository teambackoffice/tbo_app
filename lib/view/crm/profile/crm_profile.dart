import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/log_out_controller.dart';
import 'package:tbo_app/controller/login_controller.dart';
import 'package:tbo_app/services/login_service.dart';

class CRMProfilePage extends StatefulWidget {
  const CRMProfilePage({super.key});

  @override
  State<CRMProfilePage> createState() => _CRMProfilePageState();
}

class _CRMProfilePageState extends State<CRMProfilePage> {
  final LoginService _loginService = LoginService();
  String? fullName;

  final _storage = const FlutterSecureStorage();
  String? _fullName;
  String? designation;
  String? _imageUrl;
  String? _employeeId;
  String? _email;
  String? _phone;
  Future<void> _userdetails() async {
    final name = await _storage.read(key: 'employee_full_name');
    final designationValue = await _storage.read(key: 'designation');
    final imageUrl = await _storage.read(key: 'image');
    final employeeId = await _storage.read(key: 'employee_original_id');
    final email = await _storage.read(key: 'email');
    final phone = await _storage.read(key: 'mobileNo');
    setState(() {
      _fullName = name;
      designation = designationValue;
      _imageUrl = imageUrl;
      _employeeId = employeeId;
      _email = email;
      _phone = phone;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final storedFullName = await _loginService.getStoredFullName();
    setState(() {
      fullName = storedFullName;
    });
  }

  final storage = const FlutterSecureStorage();

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
                      _imageUrl ?? '',
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
                      Text(
                        _fullName ?? 'CRM',
                        style: const TextStyle(
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
                        "Bussines Development Exceutive",
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
                      Text(
                        _phone ?? '',
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
                      Text(
                        _email ?? '',
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
                      Text(
                        _employeeId ?? '',
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
                  await logoutController.logout("CRM");

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
