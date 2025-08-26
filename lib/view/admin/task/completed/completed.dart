import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/task_list_controller.dart';
import 'package:tbo_app/view/admin/task/completed/complete_details.dart';

class AdminCompleteTaskList extends StatefulWidget {
  const AdminCompleteTaskList({super.key});

  @override
  State<AdminCompleteTaskList> createState() => _AdminCompleteTaskListState();
}

class _AdminCompleteTaskListState extends State<AdminCompleteTaskList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // ✅ Get stored email

      // ✅ Call controller with email as assignedUsers
      Provider.of<TaskListController>(context, listen: false).fetchtasklist(
        status: "Completed",
        // if null, fallback to empty string
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskListController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF1C7690)),
          );
        }

        if (controller.error != null) {
          return Center(child: Text('Error: ${controller.error}'));
        }

        final tasks = controller.tasklist?.data ?? [];
        if (tasks.isEmpty) {
          return const Center(child: Text('No tasks available'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            var task = tasks[index];

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AdminCompleteDetails(task: task), // Pass task data
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Priority label
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(task.priority ?? 'Low'),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            task.priority ?? 'Low',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF00AD85),
                            border: Border.all(
                              color: Colors.green[800]!,
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.done,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Task title - Use subject instead of name for display
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            task.subject ?? task.name ?? 'Untitled Task',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black87,
                              height: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Time & Due Date & Assigned To labels
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_outlined,
                          size: 16,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "Start Date",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        const SizedBox(width: 60),
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "Due Date",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        const SizedBox(width: 60),
                        const Text(
                          "Assigned To",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Time & Due Date values & Employee Avatars
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Start Date - Fixed field name and null handling
                        SizedBox(
                          width: 80,
                          child: _buildDateText(task.expStartDate),
                        ),
                        const SizedBox(width: 60),

                        // Due Date - Fixed field name and null handling
                        SizedBox(
                          width: 80,
                          child: _buildDateText(task.expEndDate),
                        ),
                        const SizedBox(width: 60),

                        // Employee Avatars
                        Expanded(
                          child: _buildEmployeeAvatars(
                            task.assignedUsers ?? [],
                          ),
                        ),
                      ],
                    ),

                    // Show task ID
                    ...[
                      const SizedBox(height: 12),
                      Text(
                        'Task ID: ${task.name}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Helper method to build date text with null safety
  Widget _buildDateText(dynamic dateValue) {
    if (dateValue == null) {
      return const Text(
        'Not set',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    try {
      DateTime date;
      if (dateValue is String) {
        if (dateValue.isEmpty) {
          return const Text(
            'Not set',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          );
        }
        date = DateTime.parse(dateValue);
      } else if (dateValue is DateTime) {
        date = dateValue;
      } else {
        return const Text(
          'Invalid date',
          style: TextStyle(color: Colors.red, fontSize: 12),
        );
      }

      return Text(
        DateFormat('d MMM yyyy').format(date),
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
    } catch (e) {
      return const Text(
        'Invalid date',
        style: TextStyle(color: Colors.red, fontSize: 12),
      );
    }
  }

  // Helper method to get priority color
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
      default:
        return const Color(0xFF1C7690);
    }
  }

  Widget _buildEmployeeAvatars(List<String> employees) {
    const int maxVisible = 3; // Maximum number of avatars to show
    const double avatarSize = 32.0;
    const double overlapOffset = 24.0; // How much avatars overlap

    if (employees.isEmpty) {
      return const Text(
        'Unassigned',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return SizedBox(
      height: avatarSize,
      child: Stack(
        children: [
          // Display visible avatars
          ...employees.take(maxVisible).map((employee) {
            int index = employees.indexOf(employee);
            return Positioned(
              left: index * overlapOffset,
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: const Color(0xFFF9F7F3),
                  radius: (avatarSize - 4) / 2,
                  child: Text(
                    _getInitials(employee),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }),

          // Show "+X more" indicator if there are more employees
          if (employees.length > maxVisible)
            Positioned(
              left: maxVisible * overlapOffset,
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[600],
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
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

  // Helper method to get initials from email
  String _getInitials(String email) {
    if (email.isEmpty) return '?';

    // Extract name part from email (before @)
    String name = email.split('@').first;

    // If name contains dots or underscores, split and take first letters
    List<String> parts = name.split(RegExp(r'[._]'));
    if (parts.length > 1) {
      return (parts[0].isNotEmpty ? parts[0][0] : '') +
          (parts[1].isNotEmpty ? parts[1][0] : '');
    }

    // Otherwise, take first letter
    return name[0].toUpperCase();
  }
}
