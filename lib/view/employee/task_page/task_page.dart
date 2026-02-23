import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/employee_task_list_controller.dart';
import 'package:tbo_app/modal/employee_task_list_modal.dart';
import 'package:tbo_app/view/employee/task_page/task_card.dart';
import 'package:tbo_app/view/employee/task_page/task_detail.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  String selectedStatus = 'All';
  DateTime? selectedDate;

  final List<String> statusOptions = ['All', 'Open', 'Working', 'Completed'];

  @override
  void initState() {
    super.initState();
    // Fetch tasks when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskByEmployeeController>().fetchTasks();
    });
  }

  List<Task> _filterTasks(List<Task> tasks) {
    return tasks.where((task) {
      // Status filter
      bool statusMatch =
          selectedStatus == 'All' ||
          task.status.toLowerCase() == selectedStatus.toLowerCase();

      // Date filter (by start date)
      bool dateMatch = true;
      if (selectedDate != null && task.expStartDate != null) {
        try {
          final taskStartDate = DateTime.parse(task.expStartDate!);
          dateMatch =
              taskStartDate.year == selectedDate!.year &&
              taskStartDate.month == selectedDate!.month &&
              taskStartDate.day == selectedDate!.day;
        } catch (e) {
          dateMatch = false;
        }
      }

      return statusMatch && dateMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        title: const Text(
          'Tasks',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Filter row
            Row(
              children: [
                // Status dropdown
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showStatusFilter(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedStatus,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Date picker
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          selectedDate != null
                              ? _formatDatePicker(selectedDate!)
                              : 'Select Date',
                          style: TextStyle(
                            fontSize: 16,
                            color: selectedDate != null
                                ? Colors.black87
                                : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          selectedDate != null
                              ? Icons.close
                              : Icons.calendar_today_outlined,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Task list
            Expanded(
              child: Consumer<TaskByEmployeeController>(
                builder: (context, taskController, child) {
                  if (taskController.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF10B981),
                        ),
                      ),
                    );
                  }

                  if (taskController.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading tasks',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            taskController.errorMessage!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              taskController.clearError();
                              taskController.fetchTasks();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final allTasks = taskController.taskListResponse?.data ?? [];

                  final filteredTasks = _filterTasks(allTasks);

                  if (allTasks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tasks found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You don\'t have any tasks assigned yet.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (filteredTasks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.filter_list_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tasks match your filters',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your status or date filters.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedStatus = 'All';
                                selectedDate = null;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Clear Filters'),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => taskController.fetchTasks(),
                    color: const Color(0xFF10B981),
                    child: ListView.separated(
                      itemCount: filteredTasks.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return ApiTaskCard(
                          task: task,
                          onTap: () => _navigateToTaskDetail(context, task),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by Status',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              ...statusOptions.map((status) {
                return ListTile(
                  title: Text(status),
                  leading: Radio<String>(
                    value: status,
                    groupValue: selectedStatus,
                    onChanged: (String? value) {
                      setState(() {
                        selectedStatus = value!;
                      });
                      Navigator.pop(context);
                    },
                    activeColor: const Color(0xFF10B981),
                  ),
                  onTap: () {
                    setState(() {
                      selectedStatus = status;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    if (selectedDate != null) {
      // If date is already selected, clear it
      setState(() {
        selectedDate = null;
      });
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF10B981),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _navigateToTaskDetail(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailPage(task: task)),
    ).then((result) {
      // Refresh tasks when returning from detail page
      context.read<TaskByEmployeeController>().fetchTasks();

      // Show success SnackBar if status was updated
      if (result != null && result is String && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    });
  }

  /*************  ✨ Windsurf Command ⭐  *************/
  /// Format a DateTime object into a String in the format 'DD-MM-YY'.
  ///
  /// This is used to display dates in a user-friendly format.
  ///
  /// Example:
  /// final DateTime date = DateTime(2022, 12, 25);
  /// final String formattedDate = _formatDatePicker(date);
  /// print(formattedDate); // Output: 25-12-22
  /*******  b66b6e16-8484-4659-bf1f-2cea213456d3  *******/
  String _formatDatePicker(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString().substring(2)}';
  }
}
