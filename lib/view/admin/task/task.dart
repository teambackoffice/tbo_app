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
  DateTime? selectedDate;
  String searchQuery = '';

  // Pagination variables
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  bool _isLoadingMore = false;

  // Controllers
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late TaskListController _taskController;

  @override
  void initState() {
    super.initState();
    // Set today's date when the page loads
    selectedDate = DateTime.now();

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

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _currentPage++;
      _isLoadingMore = false;
    });
  }

  void _clearSearch() {
    setState(() {
      searchQuery = '';
      _searchController.clear();
    });
  }

  void _clearDateFilter() {
    setState(() {
      selectedDate = null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2D7D8C),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  final List<String> filterOptions = ['All', 'Open', 'Working', 'Completed'];

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return const Color(0xFF3B82F6);
      case 'urgent':
        return const Color(0xFFEF4444);
      case 'working':
        return const Color(0xFFF59E0B);
      case 'completed':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF2D7D8C);
    }
  }

  Color getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return const Color(0xFFEFF6FF);
      case 'urgent':
        return const Color(0xFFFEF2F2);
      case 'working':
        return const Color(0xFFFFFBEB);
      case 'completed':
        return const Color(0xFFECFDF5);
      default:
        return const Color(0xFFF0F9FA);
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String formatDateShort(DateTime? date) {
    if (date == null) return 'Select Date';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  String calculateTimeRemaining(DateTime? endDate) {
    if (endDate == null) return 'N/A';
    final now = DateTime.now();
    final difference = endDate.difference(now);

    if (difference.isNegative) {
      return 'Overdue';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d left';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h left';
    } else {
      return '${difference.inMinutes}m left';
    }
  }

  Color getTimeRemainingColor(DateTime? endDate) {
    if (endDate == null) return const Color(0xFF6B7280);
    final now = DateTime.now();
    final difference = endDate.difference(now);

    if (difference.isNegative) {
      return const Color(0xFFEF4444);
    } else if (difference.inDays <= 1) {
      return const Color(0xFFF59E0B);
    } else {
      return const Color(0xFF10B981);
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
        final projectName = (task.projectName ?? '').toLowerCase();
        final query = searchQuery.toLowerCase();

        return taskName.contains(query) ||
            assignedUser.contains(query) ||
            projectName.contains(query);
      }).toList();
    }

    // Apply date filter
    if (selectedDate != null) {
      tasks = tasks.where((task) {
        if (task.expEndDate == null) return false;
        return task.expEndDate!.year == selectedDate!.year &&
            task.expEndDate!.month == selectedDate!.month &&
            task.expEndDate!.day == selectedDate!.day;
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

  Widget _buildTaskCard(TaskDetails task) {
    final taskName = task.subject ?? task.name;
    final assignedUser = task.assignedUsers ?? "Unassigned";
    final projectName = task.projectName ?? "No Project";
    final timeRemaining = calculateTimeRemaining(task.expEndDate);
    final timeColor = getTimeRemainingColor(task.expEndDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminTaskDetailsPage(task: task),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusBackgroundColor(task.status),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.status.toUpperCase(),
                        style: TextStyle(
                          color: getStatusColor(task.status),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    // Time Remaining Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: timeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: timeColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timeRemaining,
                            style: TextStyle(
                              color: timeColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Task Name
                Text(
                  taskName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Project Name
                Row(
                  children: [
                    Icon(
                      Icons.folder_outlined,
                      size: 16,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        projectName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Divider
                Container(height: 1, color: const Color(0xFFF3F4F6)),

                const SizedBox(height: 16),

                // Details Row
                Row(
                  children: [
                    // Due Date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 14,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Due Date',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            formatDate(task.expEndDate),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Vertical Divider
                    Container(
                      width: 1,
                      height: 40,
                      color: const Color(0xFFF3F4F6),
                    ),

                    const SizedBox(width: 16),

                    // Assigned To
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline_rounded,
                                size: 14,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Assigned To',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF2D7D8C),
                                      Color(0xFF3A9AAB),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Text(
                                    assignedUser.isNotEmpty
                                        ? assignedUser[0].toUpperCase()
                                        : 'U',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  assignedUser,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF111827),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Arrow
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onTap,
    VoidCallback? onClear,
    bool isActive = false,
    IconData? icon,
  }) {
    return Container(
      height: 40,
      padding: EdgeInsets.only(left: isActive ? 12 : 16),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2D7D8C) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? const Color(0xFF2D7D8C) : const Color(0xFFE5E7EB),
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: const Color(0xFF2D7D8C).withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 16,
                    color: isActive ? Colors.white : const Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          if (isActive && onClear != null) ...[
            const SizedBox(width: 4),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onClear,
              icon: const Icon(
                Icons.close_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ] else
            const SizedBox(width: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF111827),
              size: 18,
            ),
          ),
        ),
        backgroundColor: const Color(0xFFFAFAFA),
        title: const Text(
          'Tasks',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Consumer<TaskListController>(
        builder: (context, controller, child) {
          if (controller.isLoading && _currentPage == 0) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2D7D8C),
                strokeWidth: 3,
              ),
            );
          }

          if (controller.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.error_outline_rounded,
                        size: 40,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Unable to Load Tasks',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _fetchTasks,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D7D8C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.refresh_rounded, size: 20),
                      label: const Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final paginatedTasks = _getPaginatedTasks();
          final totalFilteredTasks = _getFilteredTasks().length;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF2D7D8C),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      hintText: 'Search tasks, projects, or people...',
                      hintStyle: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 15,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF6B7280),
                        size: 22,
                      ),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              onPressed: _clearSearch,
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Color(0xFF6B7280),
                                size: 20,
                              ),
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Filter Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Status Filter
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedFilter,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF6B7280),
                              size: 20,
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF111827),
                            ),
                            items: filterOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.filter_list_rounded,
                                        size: 16,
                                        color: Color(0xFF6B7280),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(value),
                                    ],
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
                      const SizedBox(width: 8),
                      // Date Filter Chip
                      _buildFilterChip(
                        label: selectedDate != null
                            ? formatDateShort(selectedDate!)
                            : 'Select Date',
                        onTap: () => _selectDate(context),
                        onClear: selectedDate != null ? _clearDateFilter : null,
                        isActive: selectedDate != null,
                        icon: Icons.calendar_today_rounded,
                      ),
                    ],
                  ),
                ),

                // Results Count
                if (searchQuery.isNotEmpty || selectedDate != null) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D7D8C).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$totalFilteredTasks result${totalFilteredTasks != 1 ? 's' : ''} found',
                        style: const TextStyle(
                          color: Color(0xFF2D7D8C),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Tasks List
                Expanded(
                  child: paginatedTasks.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    searchQuery.isNotEmpty ||
                                            selectedDate != null
                                        ? Icons.search_off_rounded
                                        : Icons.task_alt_rounded,
                                    size: 40,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  searchQuery.isNotEmpty || selectedDate != null
                                      ? 'No Matches Found'
                                      : 'No Tasks Yet',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  searchQuery.isNotEmpty || selectedDate != null
                                      ? 'Try adjusting your filters or search query'
                                      : 'No tasks available at the moment',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6B7280),
                                    height: 1.5,
                                  ),
                                ),
                                if (searchQuery.isNotEmpty ||
                                    selectedDate != null) ...[
                                  const SizedBox(height: 24),
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      _clearDateFilter();
                                      _clearSearch();
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF2D7D8C),
                                      side: const BorderSide(
                                        color: Color(0xFF2D7D8C),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.clear_all_rounded,
                                      size: 20,
                                    ),
                                    label: const Text(
                                      'Clear Filters',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchTasks,
                          color: const Color(0xFF2D7D8C),
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(bottom: 24),
                            itemCount:
                                paginatedTasks.length +
                                (_isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == paginatedTasks.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF2D7D8C),
                                      strokeWidth: 3,
                                    ),
                                  ),
                                );
                              }

                              final task = paginatedTasks[index];
                              return _buildTaskCard(task);
                            },
                          ),
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
