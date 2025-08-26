import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tbo_app/modal/task_list_modal.dart';

class AdminCompleteDetails extends StatelessWidget {
  final TaskDetails task;
  const AdminCompleteDetails({super.key, required this.task});
  static const double avatarSize = 32.0;
  static const double overlapOffset = 24.0;
  static const int maxVisible = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar with back button and delete option
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_outlined),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                // Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Priority Chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C7690),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          task.priority,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Title
                      Text(
                        task.subject!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: const [
                          SizedBox(width: 6),
                          Text(
                            "Assigned To",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                      task.assignedUsers.isNotEmpty
                          ? SizedBox(
                              height: avatarSize,
                              child: Stack(
                                children: [
                                  // Display visible avatars
                                  ...task.assignedUsers.take(maxVisible).map((
                                    employee,
                                  ) {
                                    int index = task.assignedUsers.indexOf(
                                      employee,
                                    );
                                    return Positioned(
                                      left: index * overlapOffset,
                                      child: Container(
                                        width: avatarSize,
                                        height: avatarSize,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          backgroundColor: const Color(
                                            0xFFF9F7F3,
                                          ),
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
                                  if (task.assignedUsers.length > maxVisible)
                                    Positioned(
                                      left: maxVisible * overlapOffset,
                                      child: Container(
                                        width: avatarSize,
                                        height: avatarSize,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey[600],
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            "+${task.assignedUsers.length - maxVisible}",
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
                            )
                          : Text(
                              " No one assigned",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                      const SizedBox(height: 12),
                      // Time
                      Row(
                        children: const [
                          Icon(Icons.access_time, size: 18),
                          SizedBox(width: 6),
                          Text(
                            "Start Time",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      task.expStartDate != null
                          ? Text(
                              DateFormat('dd-MM-yy').format(
                                task.expStartDate!,
                              ), // Use task start date
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : Text(
                              "No start date",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                      const SizedBox(height: 12),
                      // Due Date
                      Row(
                        children: const [
                          Icon(Icons.calendar_today, size: 18),
                          SizedBox(width: 6),
                          Text(
                            "Due Date",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      task.expEndDate != null
                          ? Text(
                              DateFormat('dd-MM-yy').format(task.expEndDate!),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : Text(
                              "No due date",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),

                      const SizedBox(height: 16),
                      // Description
                      Text(
                        task.description ?? "",
                        style: TextStyle(fontSize: 16, height: 1.4),
                      ),
                      const SizedBox(height: 24),

                      // Action buttons at bottom
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
