import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/project_list_controller.dart';
import 'package:tbo_app/modal/project_list_modal.dart';
import 'package:tbo_app/view/common/project_page/handover_rqsts.dart';
import 'package:tbo_app/view/common/project_page/project_details.dart';

class CommonProjectPage extends StatefulWidget {
  const CommonProjectPage({super.key});

  @override
  _CommonProjectPageState createState() => _CommonProjectPageState();
}

class _CommonProjectPageState extends State<CommonProjectPage>
    with TickerProviderStateMixin {
  String selectedFilter = 'All';
  String selectedDate = '';
  bool _isFabExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

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

    // Set today's date when the page loads
    final now = DateTime.now();
    selectedDate =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year.toString().substring(2)}';
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

  final List<String> filterOptions = ['All', 'Open', 'Progress', 'Completed'];

  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'open':
        return Color(0xFF129476);
      case 'progress':
      case 'in progress':
        return Color(0xFF007BFF);
      case 'completed':
      case 'closed':
        return Colors.green;
      default:
        return Color(0xFF28A745);
    }
  }

  // Filter projects based on selected filter and date
  List<ProjectDetails> getFilteredProjects(List<ProjectDetails>? projects) {
    if (projects == null) return [];

    List<ProjectDetails> filtered = projects;

    // Filter by status
    if (selectedFilter != 'All') {
      filtered = filtered.where((project) {
        final projectStatus = project.status ?? 'Open';

        // Handle different status mappings
        if (selectedFilter == 'Progress') {
          return projectStatus.toLowerCase() == 'progress' ||
              projectStatus.toLowerCase() == 'in progress';
        }

        return projectStatus.toLowerCase() == selectedFilter.toLowerCase();
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
                          // Label
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
                          // FAB
                          FloatingActionButton(
                            heroTag: "handover",
                            mini: true,
                            onPressed: () {
                              _toggleFab();
                              // Navigate to handover requests
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
                          // Label
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
                          // FAB
                          FloatingActionButton(
                            heroTag: "date_request",
                            mini: true,
                            onPressed: () {
                              _toggleFab();
                              // Navigate to date requests
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Opening Date Requests...'),
                                  backgroundColor: Color(0xFF2D7D8C),
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
        backgroundColor: Color(0xFFF5F5F5),
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Text(
            'Projects',
            style: TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Filter Row
            Row(
              children: [
                // Status Filter Dropdown
                Expanded(
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedFilter,
                        isExpanded: true,
                        icon: Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey.shade600,
                            size: 24,
                          ),
                        ),
                        items: filterOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedFilter = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                // Date Filter
                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(0xFF28A745),
                                onPrimary: Colors.white,
                                onSurface: Colors.black,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate =
                              '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year.toString().substring(2)}';
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(26),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectedDate,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 20,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            // Projects List
            Expanded(
              child: Consumer<GetProjectListController>(
                builder: (context, controller, child) {
                  if (controller.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF28A745),
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
                              backgroundColor: Color(0xFF28A745),
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

                  if (projects != null && projects.isNotEmpty) {}

                  if (filteredProjects.isEmpty &&
                      projects?.isNotEmpty == true) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.filter_list_off,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No projects match your filters',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Try selecting "All" or different filters',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedFilter = 'All';
                                selectedDate = '';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF28A745),
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Clear Filters'),
                          ),
                        ],
                      ),
                    );
                  }

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

                  return ListView.builder(
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
                          margin: EdgeInsets.only(bottom: 16),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
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
                                        // Project ID
                                        Text(
                                          project.name ?? 'Unknown Project',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        // Project Name
                                        Text(
                                          project.projectName ??
                                              'No Project Name',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        // Project Type Label
                                        Text(
                                          'Project Type',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        // Project Type Value
                                        Text(
                                          project.projectType ??
                                              'Not specified',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Status Badge
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(status),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildExpandableFab(),
    );
  }
}
