import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/task_list_controller.dart';
import 'package:tbo_app/modal/task_list_modal.dart';
import 'package:tbo_app/view/admin/task/task_details.dart';

class AdminTaskPage extends StatefulWidget {
  const AdminTaskPage({super.key});

  @override
  _AdminTaskPageState createState() => _AdminTaskPageState();
}

class _AdminTaskPageState extends State<AdminTaskPage>
    with TickerProviderStateMixin {
  String selectedFilter = 'All';
  String selectedDate = '';
  String searchQuery = '';

  // Pagination variables
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  bool _isLoadingMore = false;

  // Search Animation Controller
  late AnimationController _searchAnimationController;
  bool _isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // FAB Animation Controller
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  bool _isFabOpen = false;

  late TaskListController _taskController;

  @override
  void initState() {
    super.initState();
    // Set today's date when the page loads
    final now = DateTime.now();
    selectedDate =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year.toString().substring(2)}';

    // Initialize Search animation
    _searchAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    // Initialize FAB animation
    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);

    // Listen to search changes
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text;
      });
    });

    // Fetch initial tasks
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _taskController = Provider.of<TaskListController>(context, listen: false);
      _fetchTasks();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore) {
      _loadMoreTasks();
    }
  }

  Future<void> _fetchTasks() async {
    final status = selectedFilter == 'All' ? null : selectedFilter;
    await _taskController.fetchtasklist(status: status);
    setState(() {
      _currentPage = 0;
    });
  }

  Future<void> _loadMoreTasks() async {
    if (_taskController.tasklist == null) return;

    final totalItems = _getFilteredTasks().length;
    final loadedItems = (_currentPage + 1) * _itemsPerPage;

    if (loadedItems >= totalItems) return;

    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(Duration(milliseconds: 500)); // Simulate loading

    setState(() {
      _currentPage++;
      _isLoadingMore = false;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
    });
    if (_isSearchExpanded) {
      _searchAnimationController.forward();
      Future.delayed(Duration(milliseconds: 300), () {
        _searchFocusNode.requestFocus();
      });
    } else {
      _searchAnimationController.reverse();
      _searchController.clear();
      _searchFocusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _searchAnimationController.dispose();
    _fabAnimationController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleFab() {
    setState(() {
      _isFabOpen = !_isFabOpen;
    });
    if (_isFabOpen) {
      _fabAnimationController.forward();
    } else {
      _fabAnimationController.reverse();
    }
  }

  final List<String> filterOptions = ['All', 'Open', 'Working', 'Completed'];

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
      case 'urgent':
        return Color.fromARGB(255, 31, 85, 201);
      case 'working':
        return Color(0xFFF39C12);
      case 'completed':
        return Color.fromARGB(255, 33, 181, 70);
      default:
        return Color(0xFF2D7D8C);
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString().substring(2)}';
  }

  String calculateTimeRemaining(DateTime? endDate) {
    if (endDate == null) return 'N/A';
    final now = DateTime.now();
    final difference = endDate.difference(now);

    if (difference.isNegative) {
      return 'Overdue';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} Days';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} Hours';
    } else {
      return '${difference.inMinutes} Minutes';
    }
  }

  List<TaskDetails> _getFilteredTasks() {
    if (_taskController.tasklist == null) return [];

    var tasks = _taskController.tasklist!.data;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      tasks = tasks.where((task) {
        final taskName = (task.subject ?? task.name).toLowerCase();
        final assignedUser = (task.assignedUsers ?? '').toLowerCase();
        final query = searchQuery.toLowerCase();

        return taskName.contains(query) || assignedUser.contains(query);
      }).toList();
    }

    return tasks;
  }

  List<TaskDetails> _getPaginatedTasks() {
    final filteredTasks = _getFilteredTasks();
    final endIndex = ((_currentPage + 1) * _itemsPerPage).clamp(
      0,
      filteredTasks.length,
    );
    return filteredTasks.sublist(0, endIndex);
  }

  Widget _buildAnimatedSearchBar() {
    return AnimatedBuilder(
      animation: _searchAnimationController,
      builder: (context, child) {
        return Container(
          height: 48,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isSearchExpanded
                  ? Color(0xFF2D7D8C)
                  : Colors.grey.shade300,
              width: _isSearchExpanded ? 2 : 1,
            ),
            boxShadow: _isSearchExpanded
                ? [
                    BoxShadow(
                      color: Color(0xFF2D7D8C).withOpacity(0.2),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Stack(
            children: [
              // Search Input Field
              Positioned.fill(
                child: Opacity(
                  opacity: _isSearchExpanded ? 1.0 : 0.0,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 60),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Search by employee name..',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFF2D7D8C).withOpacity(0.6),
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Placeholder text when collapsed
              if (!_isSearchExpanded)
                Positioned.fill(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, color: Color(0xFF2D7D8C), size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Search Tasks',
                          style: TextStyle(
                            color: Color(0xFF2D7D8C),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Clear and Close Button
              if (_isSearchExpanded)
                Positioned(
                  right: 4,
                  top: 4,
                  bottom: 4,
                  child: Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: _toggleSearch,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF2D7D8C), Color(0xFF3A9AAB)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              // Tap area when collapsed
              if (!_isSearchExpanded)
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: _toggleSearch,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tasks',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<TaskListController>(
        builder: (context, controller, child) {
          if (controller.isLoading && _currentPage == 0) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error loading tasks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(controller.error!),
                  SizedBox(height: 16),
                  ElevatedButton(onPressed: _fetchTasks, child: Text('Retry')),
                ],
              ),
            );
          }

          final paginatedTasks = _getPaginatedTasks();

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Filter Row
                Row(
                  children: [
                    // Status Filter Dropdown
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedFilter,
                            isExpanded: true,
                            icon: Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                            ),
                            items: filterOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedFilter = newValue!;
                              });
                              _fetchTasks();
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    // Date Filter
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate =
                                  '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year.toString().substring(2)}';
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                selectedDate,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Animated Search Bar (Full Width)
                _buildAnimatedSearchBar(),

                // Show search results count when searching
                if (searchQuery.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF2D7D8C).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_getFilteredTasks().length} result${_getFilteredTasks().length != 1 ? 's' : ''} found',
                        style: TextStyle(
                          color: Color(0xFF2D7D8C),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],

                SizedBox(height: 16),

                // Tasks List
                Expanded(
                  child: paginatedTasks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                searchQuery.isNotEmpty
                                    ? Icons.search_off
                                    : Icons.task_alt,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                searchQuery.isNotEmpty
                                    ? 'No tasks match your search'
                                    : 'No tasks found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (searchQuery.isNotEmpty) ...[
                                SizedBox(height: 8),
                                Text(
                                  'Try adjusting your search terms',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount:
                              paginatedTasks.length + (_isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == paginatedTasks.length) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final task = paginatedTasks[index];

                            // Highlight search matches
                            final taskName = task.subject ?? task.name;
                            final assignedUser = task.assignedUsers ?? "";

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdminTaskDetailsPage(task: task),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 16),
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Priority Badge
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getStatusColor(task.status),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        task.status,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    // Task Name with highlight
                                    Text(
                                      taskName,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    // Task Details Row
                                    Row(
                                      children: [
                                        // Time Column
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    size: 16,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    'Time',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                calculateTimeRemaining(
                                                  task.expEndDate,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Due Date Column
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .calendar_today_outlined,
                                                    size: 16,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    'Due Date',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                formatDate(task.expEndDate),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Assigned To Column
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Assigned to',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                assignedUser,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
