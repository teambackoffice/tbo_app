import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/all_employees._controller.dart';
import 'package:tbo_app/controller/project_list_controller.dart';
import 'package:tbo_app/modal/project_list_modal.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetProjectListController>(
        context,
        listen: false,
      ).fetchprojectlist();
    });
  }

  // Function to get daily rotating projects
  List<ProjectDetails> _getDailyProjects(List<ProjectDetails>? projects) {
    if (projects == null || projects.isEmpty) return [];

    // Use current day of year to rotate projects daily
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    final startIndex = dayOfYear % projects.length;

    List<ProjectDetails> dailyProjects = [];

    // Get first project
    dailyProjects.add(projects[startIndex]);

    // Get second project (avoid duplicate)
    if (projects.length > 1) {
      final secondIndex = (startIndex + 1) % projects.length;
      dailyProjects.add(projects[secondIndex]);
    }

    return dailyProjects.take(2).toList();
  }

  // Function to get project color based on priority
  Color _getProjectColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return const Color(0xFF475569);
      case 'medium':
        return const Color(0xFF129476);
      case 'low':
        return const Color(0xFF1C7690);
      default:
        return const Color(0xFF129476);
    }
  }

  // Function to calculate estimated hours for display
  String _getEstimatedHours(ProjectDetails project) {
    double totalHours = 0;
    if (project.taskTemplates != null) {
      for (var task in project.taskTemplates!) {
        totalHours += task.estimatedHours ?? 0;
      }
    }
    return totalHours > 0 ? '${totalHours.toInt()} Hours' : '-- Hours';
  }

  // Function to format date for display
  String _formatDate(DateTime? date) {
    if (date == null) return '--';
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString().substring(2)}';
  }

  // Function to get mock assigned employees (since project API doesn't include this)

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
                    backgroundColor: Color(0xFF1C7690),
                    child: Icon(Icons.person, size: 30, color: Colors.white),
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

              // Dynamic Project Cards using Consumer
              Consumer<GetProjectListController>(
                builder: (context, controller, child) {
                  if (controller.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(
                          color: Color(0xFF129476),
                        ),
                      ),
                    );
                  }

                  if (controller.error != null) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red.shade600,
                            size: 30,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Failed to load projects',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            controller.error!,
                            style: TextStyle(color: Colors.red.shade600),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => controller.fetchprojectlist(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF129476),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final projects = controller.projectList?.data;
                  if (projects == null || projects.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            color: Colors.grey.shade600,
                            size: 40,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'No Projects Available',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'There are currently no projects to display',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    );
                  }

                  // Get daily rotating projects
                  final dailyProjects = _getDailyProjects(projects);

                  return Column(
                    children: [
                      ...dailyProjects.asMap().entries.map((entry) {
                        final index = entry.key;
                        final project = entry.value;

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index < dailyProjects.length - 1 ? 15 : 0,
                          ),
                          child: _buildProjectCard(
                            project: project,
                            projectIndex: index,
                          ),
                        );
                      }),
                      if (dailyProjects.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'No active projects found for today',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),

              // Action Buttons Row
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
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C7690),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/employees.png"),
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
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C7690),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/alltasks.png"),
                          const SizedBox(height: 5),
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
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C7690),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/timesheet.png"),
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

  Widget _buildProjectCard({
    required ProjectDetails project,
    required int projectIndex,
  }) {
    final color = _getProjectColor(project.priority);
    final estimatedHours = _getEstimatedHours(project);
    final dueDate = _formatDate(project.expectedEndDate);
    final startdate = _formatDate(project.expectedStartDate);

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
                  project.priority?.toUpperCase() ?? 'MEDIUM',
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
            project.projectName ?? 'Untitled Project',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            project.name ?? 'No project ID',
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
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Start Date',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      startdate,
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
                          'End Date',
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
                      '',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                    const SizedBox(height: 5),
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
