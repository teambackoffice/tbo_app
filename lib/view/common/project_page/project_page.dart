import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/project_list_controller.dart';
import 'package:tbo_app/modal/project_list_modal.dart';
import 'package:tbo_app/view/common/project_page/date_rqst.dart';
import 'package:tbo_app/view/common/project_page/handover_rqsts.dart';
import 'package:tbo_app/view/common/project_page/project_details.dart';

class CommonProjectPage extends StatefulWidget {
  const CommonProjectPage({super.key});

  @override
  _CommonProjectPageState createState() => _CommonProjectPageState();
}

class _CommonProjectPageState extends State<CommonProjectPage>
    with TickerProviderStateMixin {
  String searchQuery = '';
  String selectedStatus = 'Open';
  bool _isFabExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  // Define status categories
  final List<String> statusCategories = [
    'All',
    'Open',
    'Completed',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetProjectListController>(
        context,
        listen: false,
      ).fetchprojectlist();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFab() {
    setState(() {
      _isFabExpanded = !_isFabExpanded;
      if (_isFabExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'open':
        return Color(0xFF129476);

      case 'completed':
        return Color(0xFF28A745);
      case 'cancelled':
        return Color(0xFF6C757D);
      default:
        return Color(0xFF28A745);
    }
  }

  // Get count for each status
  int getStatusCount(List<ProjectDetails>? projects, String status) {
    if (projects == null) return 0;

    if (status == 'All') return projects.length;

    return projects.where((project) {
      final projectStatus = project.status?.toLowerCase() ?? '';
      final targetStatus = status.toLowerCase();

      if (targetStatus == 'in progress') {
        return projectStatus == 'progress' || projectStatus == 'in progress';
      }

      return projectStatus == targetStatus;
    }).length;
  }

  // Filter projects based on search query and selected status
  List<ProjectDetails> getFilteredProjects(List<ProjectDetails>? projects) {
    if (projects == null) return [];

    List<ProjectDetails> filtered = projects;

    // Filter by selected status
    if (selectedStatus != 'All') {
      filtered = filtered.where((project) {
        final projectStatus = project.status?.toLowerCase() ?? '';
        final targetStatus = selectedStatus.toLowerCase();

        if (targetStatus == 'in progress') {
          return projectStatus == 'progress' || projectStatus == 'in progress';
        }

        return projectStatus == targetStatus;
      }).toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((project) {
        final projectName = project.projectName?.toLowerCase() ?? '';
        final projectId = project.name?.toLowerCase() ?? '';
        final projectType = project.projectType?.toLowerCase() ?? '';
        final status = project.status?.toLowerCase() ?? '';
        final query = searchQuery.toLowerCase();

        return projectName.contains(query) ||
            projectId.contains(query) ||
            projectType.contains(query) ||
            status.contains(query);
      }).toList();
    }

    return filtered;
  }

  Widget _buildExpandableFab() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Backdrop when expanded
        if (_isFabExpanded)
          GestureDetector(
            onTap: _toggleFab,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.3),
            ),
          ),

        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Handover Request FAB
            AnimatedBuilder(
              animation: _expandAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _expandAnimation.value,
                  child: Opacity(
                    opacity: _expandAnimation.value,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Handover Request',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          FloatingActionButton(
                            heroTag: "handover",
                            mini: true,
                            onPressed: () {
                              _toggleFab();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmployeeHandoverPage(),
                                ),
                              );
                            },
                            backgroundColor: Color(0xFF2D7D8C),
                            elevation: 4,
                            child: Icon(
                              Icons.swap_horiz_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Date Request FAB
            AnimatedBuilder(
              animation: _expandAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _expandAnimation.value,
                  child: Opacity(
                    opacity: _expandAnimation.value,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Date Request',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          FloatingActionButton(
                            heroTag: "date_request",
                            mini: true,
                            onPressed: () {
                              _toggleFab();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EmployeeDateRequestScreen(),
                                ),
                              );
                            },
                            backgroundColor: Color(0xFF2D7D8C),
                            elevation: 4,
                            child: Icon(
                              Icons.calendar_month_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Main FAB
            FloatingActionButton(
              heroTag: "main_fab",
              onPressed: _toggleFab,
              backgroundColor: _isFabExpanded
                  ? Color(0xFF1B5E5E)
                  : Color(0xFF2D7D8C),
              elevation: 6,
              child: AnimatedRotation(
                turns: _isFabExpanded ? 0.125 : 0,
                duration: Duration(milliseconds: 250),
                child: Icon(
                  _isFabExpanded ? Icons.close_rounded : Icons.menu_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Center(
          child: Text(
            'Projects',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Field
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                    hintText: 'Search projects...',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                // Status Filter Dropdown
                Consumer<GetProjectListController>(
                  builder: (context, controller, child) {
                    final projects = controller.projectList?.data;

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_list,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Status:',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedStatus,
                                isExpanded: true,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Color(0xFF2D7D8C),
                                ),
                                items: statusCategories.map((String status) {
                                  int count = getStatusCount(projects, status);
                                  return DropdownMenuItem<String>(
                                    value: status,
                                    child: Text(
                                      '$status ($count)',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedStatus = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Projects List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<GetProjectListController>(
                builder: (context, controller, child) {
                  if (controller.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF2D7D8C),
                      ),
                    );
                  }

                  if (controller.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Error loading projects',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            controller.error!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => controller.fetchprojectlist(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2D7D8C),
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final projects = controller.projectList?.data;
                  final filteredProjects = getFilteredProjects(projects);

                  if (projects == null || projects.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_open_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No projects found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'No projects available',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (filteredProjects.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No matching projects',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Try adjusting your search or filter',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchprojectlist();
                    },
                    color: Color(0xFF2D7D8C),
                    child: ListView.builder(
                      itemCount: filteredProjects.length,
                      itemBuilder: (context, index) {
                        final project = filteredProjects[index];
                        final status = project.status ?? 'Open';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProjectDetailsPage(project: project),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 12),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            project.name ?? 'Unknown Project',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade500,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            project.projectName ??
                                                'No Project Name',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getStatusColor(status),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Divider(height: 1, color: Colors.grey.shade200),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.category_outlined,
                                      size: 16,
                                      color: Colors.grey.shade500,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Type: ',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      project.projectType ?? 'Not specified',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildExpandableFab(),
    );
  }
}
