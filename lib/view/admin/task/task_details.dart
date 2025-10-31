import 'package:flutter/material.dart';
import 'package:tbo_app/modal/task_list_modal.dart';

class AdminTaskDetailsPage extends StatelessWidget {
  final TaskDetails task;

  const AdminTaskDetailsPage({super.key, required this.task});

  Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'urgent':
        return Color(0xFFE74C3C);
      case 'medium':
        return Color(0xFFF39C12);
      case 'low':
        return Color(0xFF2D7D8C);
      default:
        return Color(0xFF2D7D8C);
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Color(0xFF27AE60);
      case 'working':
        return Color(0xFF3498DB);
      case 'open':
        return Color(0xFFF39C12);
      case 'cancelled':
        return Color(0xFFE74C3C);
      default:
        return Color(0xFF95A5A6);
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  String calculateTimeRemaining(DateTime? endDate) {
    if (endDate == null) return 'Not set';
    final now = DateTime.now();
    final difference = endDate.difference(now);

    if (difference.isNegative) {
      return 'Overdue';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} Days remaining';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} Hours remaining';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} Minutes remaining';
    } else {
      return 'Due soon';
    }
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
          'Task Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Header Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                  // Task ID
                  Text(
                    task.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12),
                  // Task Subject
                  Text(
                    task.subject ?? task.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Priority and Status Row
                  Row(
                    children: [
                      // Priority Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: getPriorityColor(task.priority),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.flag, color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              task.priority,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      // Status Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusColor(task.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, color: Colors.white, size: 12),
                            SizedBox(width: 6),
                            Text(
                              task.status,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
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
            SizedBox(height: 16),

            // Time Details Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                  Text(
                    'Timeline',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Start Date
                  _buildInfoRow(
                    icon: Icons.play_circle_outline,
                    label: 'Start Date',
                    value: formatDate(task.expStartDate),
                    iconColor: Color(0xFF27AE60),
                  ),
                  SizedBox(height: 16),
                  // End Date
                  _buildInfoRow(
                    icon: Icons.flag_outlined,
                    label: 'Due Date',
                    value: formatDate(task.expEndDate),
                    iconColor: Color(0xFFE74C3C),
                  ),
                  SizedBox(height: 16),

                  // Created Date
                  _buildInfoRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Created On',
                    value: formatDate(task.creation),
                    iconColor: Color(0xFF3498DB),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Project and Assignment Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                  Text(
                    'Assignment Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Project
                  _buildInfoRow(
                    icon: Icons.folder_outlined,
                    label: 'Project',
                    value: task.project ?? 'Not assigned',
                    iconColor: Color(0xFF9B59B6),
                  ),
                  SizedBox(height: 16),
                  // Assigned To
                  _buildInfoRow(
                    icon: Icons.person_outline,
                    label: 'Assigned To',
                    value: task.assignedUsers ?? 'Not assigned',
                    iconColor: Color(0xFF2D7D8C),
                  ),
                  if (task.customEstimatedHours != null) ...[
                    SizedBox(height: 16),
                    _buildInfoRow(
                      icon: Icons.schedule_outlined,
                      label: 'Estimated Hours',
                      value: '${task.customEstimatedHours} hours',
                      iconColor: Color(0xFF16A085),
                    ),
                  ],
                  if (task.parentTask != null) ...[
                    SizedBox(height: 16),
                    _buildInfoRow(
                      icon: Icons.account_tree_outlined,
                      label: 'Parent Task',
                      value: task.parentTask!,
                      iconColor: Color(0xFF34495E),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 16),

            // Description Card
            if (task.description != null && task.description!.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                    Row(
                      children: [
                        Icon(
                          Icons.description_outlined,
                          color: Color(0xFF2D7D8C),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      task.description!,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 32),
          ],
        ),
      ),
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
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
