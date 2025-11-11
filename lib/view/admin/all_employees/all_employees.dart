import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/all_employees._controller.dart';

class TeamMembersPage extends StatefulWidget {
  const TeamMembersPage({super.key});

  @override
  State<TeamMembersPage> createState() => _TeamMembersPageState();
}

class _TeamMembersPageState extends State<TeamMembersPage> {
  final _storage = const FlutterSecureStorage();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  Future<String?> _getSid() async {
    return await _storage.read(key: "sid");
  }

  @override
  void initState() {
    super.initState();
    // Fetch employees when page loads if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<AllEmployeesController>(
        context,
        listen: false,
      );
      if (controller.allEmployees == null ||
          controller.allEmployees!.message.isEmpty) {
        controller.fetchallemployees();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> _filterEmployees(List<dynamic> employees) {
    if (_searchQuery.isEmpty) {
      return employees;
    }

    return employees.where((employee) {
      final name = employee.employeeName.isNotEmpty
          ? employee.employeeName.toLowerCase()
          : employee.name.toLowerCase();
      final role = employee.designation.toLowerCase();
      final department = employee.department.toLowerCase();
      final query = _searchQuery.toLowerCase();

      return name.contains(query) ||
          role.contains(query) ||
          department.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      body: SafeArea(
        child: Column(
          children: [
            // Top Row with Back Button and Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Team Members',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Add refresh button
                  Consumer<AllEmployeesController>(
                    builder: (context, controller, child) {
                      return IconButton(
                        onPressed: controller.isLoading
                            ? null
                            : () => controller.fetchallemployees(),
                        icon: Icon(
                          Icons.refresh,
                          color: controller.isLoading
                              ? Colors.grey
                              : const Color(0xFF1C7690),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by name, role, or department',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF1C7690),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),

            // Team Members List using real API data
            Expanded(
              child: Consumer<AllEmployeesController>(
                builder: (context, controller, child) {
                  if (controller.isLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Color(0xFF1C7690)),
                          SizedBox(height: 16),
                          Text(
                            'Loading team members...',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  if (controller.error != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red[300],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Failed to load team members',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              controller.error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () => controller.fetchallemployees(),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1C7690),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (controller.allEmployees?.message.isEmpty ?? true) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No team members found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Check back later or contact your administrator',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  final employees = controller.allEmployees!.message;
                  final filteredEmployees = _filterEmployees(employees);

                  if (filteredEmployees.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No results found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try searching with different keywords',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      // Results count
                      if (_searchQuery.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Found ${filteredEmployees.length} result${filteredEmployees.length != 1 ? 's' : ''}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          itemCount: filteredEmployees.length,
                          itemBuilder: (context, index) {
                            final employee = filteredEmployees[index];
                            return _buildTeamMemberTile(
                              name: employee.employeeName.isNotEmpty
                                  ? employee.employeeName
                                  : employee.name,
                              role: employee.designation,
                              imageUrl: employee.imageUrl.isNotEmpty
                                  ? employee.imageUrl
                                  : employee.image,
                              department: employee.department,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMemberTile({
    required String name,
    required String role,
    required String imageUrl,
    required String department,
  }) {
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

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
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
                          width: 56,
                          height: 56,
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
                            return Center(
                              child: Text(
                                _getInitials(name),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
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
                          fontSize: 20,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
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
                    const SizedBox(height: 4),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (department.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        department,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
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
