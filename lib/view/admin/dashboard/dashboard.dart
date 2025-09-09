import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/all_employees._controller.dart';
import 'package:tbo_app/view/admin/all_employees/all_employees.dart';
import 'package:tbo_app/view/admin/bottom_navigation/bottom_navigation_admin.dart';
import 'package:tbo_app/view/admin/dashboard/notification/notification.dart';
import 'package:tbo_app/view/admin/dashboard/timesheet/timesheet.dart';
import 'package:tbo_app/view/admin/task/task.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _storage = const FlutterSecureStorage();

  Future<String?> _getSid() async {
    return await _storage.read(key: "sid");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<AllEmployeesController>(
        context,
        listen: false,
      ).fetchallemployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      'https://media.istockphoto.com/id/1481165140/photo/portrait-of-biracial-young-woman-smiling-and-using-laptop-in-bright-contemporary-office.jpg?s=612x612&w=0&k=20&c=p4WaudLa74dVkawzcjLnEqDnIO5EE7IZaJzUqav8wfE=',
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Hello ',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Admin !',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Team Lead',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4A90A4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF129476).withOpacity(1),
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search here...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    suffixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Ongoing Tasks Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ongoing Tasks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AdminBottomNavigation(initialIndex: 1),
                        ),
                      );
                    },
                    child: const Text(
                      'See all',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Task Cards
              _buildTaskCard(
                title: 'Champion Car Wash App',
                subtitle: 'TBOPROID1',
                time: '18 Hours',
                dueDate: '15-07-25',
                assignedEmployees: [
                  {
                    "name": "Shameer",
                    "image":
                        "https://media.istockphoto.com/id/1490901345/photo/happy-male-entrepreneur-at-his-office-desk-looking-at-camera.jpg?s=612x612&w=0&k=20&c=YUcA7EJpGx9CS0SEVJyU0jH6yB9GaUKAOUp98YmBzi0=",
                  },
                  {
                    "name": "Priya",
                    "image":
                        "https://media.istockphoto.com/id/1489414046/photo/portrait-of-an-attractive-empowered-multiethnic-woman-looking-at-camera-and-charmingly.jpg?s=612x612&w=0&k=20&c=p9-7xtXTjNUUDYJVJmZ2pka98lr2xiFCM1jFLqpgF6Q=",
                  },
                ],
                color: const Color(0xFF475569),
                priority: 'High',
              ),

              const SizedBox(height: 15),

              _buildTaskCard(
                title: 'Onshore Profile',
                subtitle: 'TBOPROID2',
                time: '18 Hours',
                dueDate: '15-07-25',
                assignedEmployees: [
                  {
                    "name": "Jasir",
                    "image":
                        "https://media.istockphoto.com/id/1490901345/photo/happy-male-entrepreneur-at-his-office-desk-looking-at-camera.jpg?s=612x612&w=0&k=20&c=YUcA7EJpGx9CS0SEVJyU0jH6yB9GaUKAOUp98YmBzi0=",
                  },
                ],
                color: const Color(0xFF129476),
                priority: 'High',
              ),

              // const SizedBox(height: 20),

              // Add Project/Task Button
              // SizedBox(
              //   width: double.infinity,
              //   height: 50,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       showDialog(
              //         context: context,
              //         barrierDismissible: true,
              //         builder: (context) => _buildDialog(context),
              //       );
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: const Color(0xFF1C7690),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(25),
              //       ),
              //       elevation: 0,
              //     ),
              //     child: const Text(
              //       'Add Project / Task',
              //       style: TextStyle(
              //         fontSize: 16,
              //         fontWeight: FontWeight.w500,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 30),

              // Team Members Section - Now using real API data
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     const Text(
              //       'Team Members',
              //       style: TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.black,
              //       ),
              //     ),
              //     TextButton(
              //       onPressed: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => const TeamMembersPage(),
              //           ),
              //         );
              //       },
              //       child: const Text(
              //         'View all',
              //         style: TextStyle(color: Colors.grey, fontSize: 14),
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 10),

              // Team Members List - Using Consumer to get real data
              // Consumer<AllEmployeesController>(
              //   builder: (context, controller, child) {
              //     if (controller.isLoading) {
              //       return const Center(
              //         child: Padding(
              //           padding: EdgeInsets.all(20),
              //           child: CircularProgressIndicator(
              //             color: Color(0xFF1C7690),
              //           ),
              //         ),
              //       );
              //     }

              //     if (controller.error != null) {
              //       return Card(
              //         color: Colors.red.shade50,
              //         child: Padding(
              //           padding: const EdgeInsets.all(16),
              //           child: Row(
              //             children: [
              //               const Icon(Icons.error, color: Colors.red),
              //               const SizedBox(width: 10),
              //               Expanded(
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     const Text(
              //                       'Failed to load team members',
              //                       style: TextStyle(
              //                         fontWeight: FontWeight.bold,
              //                         color: Colors.red,
              //                       ),
              //                     ),
              //                     Text(
              //                       controller.error!,
              //                       style: const TextStyle(
              //                         fontSize: 12,
              //                         color: Colors.red,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //               IconButton(
              //                 icon: const Icon(
              //                   Icons.refresh,
              //                   color: Colors.red,
              //                 ),
              //                 onPressed: () => controller.fetchallemployees(),
              //               ),
              //             ],
              //           ),
              //         ),
              //       );
              //     }

              //     if (controller.allEmployees?.message.isEmpty ?? true) {
              //       return const Card(
              //         child: Padding(
              //           padding: EdgeInsets.all(16),
              //           child: Center(
              //             child: Text(
              //               'No team members found',
              //               style: TextStyle(fontSize: 16, color: Colors.grey),
              //             ),
              //           ),
              //         ),
              //       );
              //     }

              //     // Show limited number of employees on dashboard
              //     final employees = controller.allEmployees!.message
              //         .take(5)
              //         .toList();

              //     return Column(
              //       children: employees.map((employee) {
              //         return _buildTeamMember(
              //           employee.employeeName.isNotEmpty
              //               ? employee.employeeName
              //               : employee.name,
              //           employee.designation,
              //           employee.imageUrl.isNotEmpty
              //               ? employee.imageUrl
              //               : employee.image,
              //           employee.department,
              //         );
              //       }).toList(),
              //     );
              //   },
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TeamMembersPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 100, // extra height to fit text
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C7690),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image
                          Image.asset("assets/employees.png"),
                          // Text
                          const Text(
                            "    Team\n Members",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminTaskPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 100, // extra height to fit text
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C7690),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image
                          Image.asset("assets/alltasks.png"),
                          const SizedBox(height: 5),
                          // Text
                          const Text(
                            "   All\n Tasks",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmployeeTimesheet(),
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 100, // extra height to fit text
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C7690),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image
                          Image.asset("assets/timesheet.png"),
                          // Text
                          const Text(
                            " Time\n Sheet",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard({
    required String title,
    required String subtitle,
    required String time,
    required String dueDate,
    required List<Map<String, String>> assignedEmployees,
    required Color color,
    required String priority,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5E5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  priority,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Time',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Due Date',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      dueDate,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Assigned to',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                    const SizedBox(height: 5),
                    _buildEmployeeAvatars(assignedEmployees),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeAvatars(List<Map<String, String>> employees) {
    const int maxVisible = 2;
    const double avatarRadius = 12.0;
    const double overlapOffset = 18.0;

    return SizedBox(
      height: avatarRadius * 2,
      child: Stack(
        children: [
          // Display visible avatars
          ...employees.take(maxVisible).map((employee) {
            int index = employees.indexOf(employee);
            final imageUrl = employee["image"] ?? '';
            final name = employee["name"] ?? '';
            final hasValidImage =
                imageUrl.isNotEmpty &&
                (imageUrl.startsWith('http://') ||
                    imageUrl.startsWith('https://'));

            return Positioned(
              left: index * overlapOffset,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: const Color(0xFF1C7690),
                  backgroundImage: hasValidImage
                      ? NetworkImage(imageUrl)
                      : null,
                  onBackgroundImageError: hasValidImage
                      ? (exception, stackTrace) {
                          debugPrint('Failed to load avatar image: $imageUrl');
                        }
                      : null,
                  child: !hasValidImage
                      ? Text(
                          _getInitials(name),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 8,
                          ),
                        )
                      : null,
                ),
              ),
            );
          }),

          // Show "+X more" indicator if there are more employees
          if (employees.length > maxVisible)
            Positioned(
              left: maxVisible * overlapOffset,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: Colors.grey[600],
                  child: Text(
                    "+${employees.length - maxVisible}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(
    String name,
    String role,
    String imageUrl,
    String department,
  ) {
    return FutureBuilder<String?>(
      future: _getSid(),
      builder: (context, snapshot) {
        final sid = snapshot.data;

        // Build full URL if image path exists
        String? fullImageUrl;
        if (imageUrl.isNotEmpty) {
          if (imageUrl.startsWith('http://') ||
              imageUrl.startsWith('https://')) {
            fullImageUrl = imageUrl;
          } else if (imageUrl.startsWith('/')) {
            // Convert relative path to full URL
            fullImageUrl =
                'https://tbo-smart.tbo365.cloud$imageUrl'; // Replace with your base URL
          }
        }

        final hasValidImage = fullImageUrl != null && fullImageUrl.isNotEmpty;

        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          margin: const EdgeInsets.only(bottom: 15),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFF1C7690),
                  child: hasValidImage && sid != null
                      ? ClipOval(
                          child: Image.network(
                            fullImageUrl,
                            headers: {
                              "Cookie": "sid=$sid",
                              "Accept": "image/*",
                              "User-Agent": "Flutter App",
                            },
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print('❌ Failed to load image: $fullImageUrl');
                              print('❌ Error: $error');
                              return Center(
                                child: Text(
                                  _getInitials(name),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Text(
                          _getInitials(name),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        role,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      if (department.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          department,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';

    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    } else {
      return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
    }
  }
}
