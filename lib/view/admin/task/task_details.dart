import 'package:flutter/material.dart';
import 'package:tbo_app/modal/task_list_modal.dart';

class AdminTaskDetailsPage extends StatelessWidget {
  final TaskDetails task;

  const AdminTaskDetailsPage({super.key, required this.task});

  Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'urgent':
        return const Color(0xFFEF4444);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'low':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Color getPriorityBackgroundColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'urgent':
        return const Color(0xFFFEF2F2);
      case 'medium':
        return const Color(0xFFFFFBEB);
      case 'low':
        return const Color(0xFFECFDF5);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF10B981);
      case 'working':
        return const Color(0xFF3B82F6);
      case 'open':
        return const Color(0xFFF59E0B);
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Color getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFFECFDF5);
      case 'working':
        return const Color(0xFFEFF6FF);
      case 'open':
        return const Color(0xFFFFFBEB);
      case 'cancelled':
        return const Color(0xFFFEF2F2);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Not set';
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

  String calculateTimeRemaining(DateTime? endDate) {
    if (endDate == null) return 'Not set';
    final now = DateTime.now();
    final difference = endDate.difference(now);

    if (difference.isNegative) {
      final overdueDays = difference.inDays.abs();
      if (overdueDays > 0) {
        return 'Overdue by $overdueDays day${overdueDays != 1 ? 's' : ''}';
      }
      return 'Overdue';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays != 1 ? 's' : ''} remaining';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours != 1 ? 's' : ''} remaining';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes != 1 ? 's' : ''} remaining';
    } else {
      return 'Due very soon';
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
    } else if (difference.inDays <= 3) {
      return const Color(0xFF3B82F6);
    } else {
      return const Color(0xFF10B981);
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeRemaining = calculateTimeRemaining(task.expEndDate);
    final timeColor = getTimeRemainingColor(task.expEndDate);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
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
        title: const Text(
          'Task Details',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2D7D8C), Color(0xFF3A9AAB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2D7D8C).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task ID Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      task.name,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Task Subject
                  Text(
                    task.subject ?? task.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Priority and Status Row
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Priority Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: getPriorityColor(task.priority),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              task.priority.toUpperCase(),
                              style: TextStyle(
                                color: getPriorityColor(task.priority),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: getStatusColor(task.status),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              task.status.toUpperCase(),
                              style: TextStyle(
                                color: getStatusColor(task.status),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Time Remaining Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: timeColor,
                            ),
                            const SizedBox(width: 6),
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
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Timeline Section
            _buildSectionHeader('Timeline', Icons.schedule_rounded),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
              child: Column(
                children: [
                  // Start Date
                  _buildTimelineRow(
                    icon: Icons.play_circle_outline_rounded,
                    label: 'Start Date',
                    value: formatDate(task.expStartDate),
                    iconColor: const Color(0xFF10B981),
                    isFirst: true,
                  ),

                  // End Date
                  _buildTimelineRow(
                    icon: Icons.flag_outlined,
                    label: 'Due Date',
                    value: formatDate(task.expEndDate),
                    iconColor: const Color(0xFFEF4444),
                  ),

                  // Created Date
                  _buildTimelineRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Created On',
                    value: formatDate(task.creation),
                    iconColor: const Color(0xFF3B82F6),
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Assignment Section
            _buildSectionHeader('Assignment', Icons.assignment_rounded),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
              child: Column(
                children: [
                  // Project
                  _buildInfoRow(
                    icon: Icons.folder_outlined,
                    label: 'Project',
                    value: task.project ?? 'Not assigned',
                    iconColor: const Color(0xFF8B5CF6),
                  ),

                  const SizedBox(height: 20),

                  // Assigned To with Avatar
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person_outline_rounded,
                          color: Color(0xFF6B7280),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Assigned To',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF2D7D8C),
                                        Color(0xFF3A9AAB),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      (task.assignedUsers ?? 'U')[0]
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    task.assignedUsers ?? 'Not assigned',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF111827),
                                      fontWeight: FontWeight.w600,
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
                    ],
                  ),

                  if (task.customEstimatedHours != null) ...[
                    const SizedBox(height: 20),
                    _buildInfoRow(
                      icon: Icons.timer_outlined,
                      label: 'Estimated Hours',
                      value: '${task.customEstimatedHours} hours',
                      iconColor: const Color(0xFF14B8A6),
                    ),
                  ],

                  if (task.parentTask != null) ...[
                    const SizedBox(height: 20),
                    _buildInfoRow(
                      icon: Icons.account_tree_outlined,
                      label: 'Parent Task',
                      value: task.parentTask!,
                      iconColor: const Color(0xFF6366F1),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Description Section
            if (task.description != null && task.description!.isNotEmpty) ...[
              _buildSectionHeader('Description', Icons.description_outlined),
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
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
                child: Text(
                  task.description!,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF374151),
                    height: 1.6,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2D7D8C).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF2D7D8C), size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Column(
      children: [
        if (!isFirst)
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: Container(
              width: 2,
              height: 16,
              color: const Color(0xFFE5E7EB),
            ),
          ),
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF111827),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: Container(
              width: 2,
              height: 16,
              color: const Color(0xFFE5E7EB),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF111827),
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
