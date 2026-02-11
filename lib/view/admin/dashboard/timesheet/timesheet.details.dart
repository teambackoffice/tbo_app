import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/update_timesheet_controller.dart';
import 'package:tbo_app/modal/timesheet_modal.dart';

class TimesheetApprovalPage extends StatefulWidget {
  final Datum timesheet;

  const TimesheetApprovalPage({super.key, required this.timesheet});

  @override
  State<TimesheetApprovalPage> createState() => _TimesheetApprovalPageState();
}

class _TimesheetApprovalPageState extends State<TimesheetApprovalPage> {
  // Assuming you have a way to get the session ID (sid).
  // For demonstration, I'm setting it to null or a placeholder.
  final String? _sessionId =
      null; // Replace with actual session ID retrieval logic if needed

  Set<int> expandedCards = <int>{};

  @override
  void initState() {
    super.initState();
    // Initialize the service and controller for the mock files provided
    // If using a global Provider, this part would change.
  }

  String formatDate(DateTime date) {
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

  String formatTime(DateTime time) {
    int hour = time.hour;
    int minute = time.minute;
    String period = hour >= 12 ? 'PM' : 'AM';

    if (hour > 12) hour = hour - 12;
    if (hour == 0) hour = 12;

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return const Color(0xFF10B981);
      case 'submitted':
        return const Color(0xFF3B82F6);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'draft':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Color getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return const Color(0xFFD1FAE5);
      case 'submitted':
        return const Color(0xFFDBEAFE);
      case 'pending':
        return const Color(0xFFFEF3C7);
      case 'draft':
        return const Color(0xFFF3F4F6);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  String getStatusDisplayText(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return 'Sent to Approval';
      case 'approved':
        return 'Approved';
      case 'draft':
        return 'Draft';
      case 'pending':
        return 'Pending';
      default:
        return status;
    }
  }

  // --- New Methods for API Integration ---

  Future<void> _updateStatus(String action, String dialogMessage) async {
    final controller = Provider.of<TimesheetStatusController>(
      context,
      listen: false,
    );

    // Show confirmation dialog before proceeding
    final bool? confirm = await _showConfirmationDialog(dialogMessage);

    if (confirm == true) {
      await controller.updateStatus(
        timesheetId: widget
            .timesheet
            .name, // Assuming timesheet ID is in the 'name' field
        action: 'accept',
        sid: _sessionId,
      );

      // Handle response
      if (controller.errorMessage != null) {
        _showErrorMessage(controller.errorMessage!);
      } else {
        _showSuccessMessage('Timesheet successfully ${action}ed.');
        // Optionally pop the screen or refresh the previous list
        Navigator.pop(context, true); // Pass true to indicate a change
      }
    }
  }

  Future<bool?> _showConfirmationDialog(String message) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Action'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D8A),
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // --- Widget Build Methods ---

  @override
  Widget build(BuildContext context) {
    // Wrap the Scaffold in a ChangeNotifierProvider to manage the controller's lifecycle
    return ChangeNotifierProvider(
      create: (context) => TimesheetStatusController(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 18,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Timesheet Details',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header Card with Employee Info
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Employee Info
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2E7D8A), Color(0xFF2E7D8A)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              widget.timesheet.employeeName != null &&
                                      widget.timesheet.employeeName!.isNotEmpty
                                  ? widget.timesheet.employeeName![0]
                                        .toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.timesheet.employeeName ??
                                    "Unknown Employee",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.timesheet.employee ?? "Unknown Employee",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Info Cards Row
                    Row(
                      children: [
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.access_time_rounded,
                            label: 'Total Hours',
                            value: '${widget.timesheet.totalHours.toInt()} hrs',
                            color: const Color(0xFF2E7D8A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Time Logs Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D8A).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.assignment_outlined,
                            color: Color(0xFF2E7D8A),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Time Logs',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${widget.timesheet.timeLogs.length}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D8A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Task Cards
                    if (widget.timesheet.timeLogs.isEmpty)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 64,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No time logs available',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...widget.timesheet.timeLogs.asMap().entries.map((entry) {
                        int index = entry.key;
                        TimeLog timeLog = entry.value;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildTaskCard(
                            index: index,
                            title: timeLog.activityType ?? 'No Activity',
                            subtitle: (timeLog.task?.isNotEmpty ?? false)
                                ? timeLog.task!
                                : (timeLog.project ?? 'No Project'),
                            fromTime: formatTime(timeLog.fromTime),
                            toTime: timeLog.toTime != null
                                ? formatTime(timeLog.toTime!)
                                : 'In Progress',
                            totalHours: '${timeLog.hours.toInt()} Hr',
                            description:
                                timeLog.description ??
                                'No description provided',
                            project: timeLog.project ?? 'No Project',
                          ),
                        );
                      }),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Action Buttons integrated with the controller
        bottomNavigationBar: Consumer<TimesheetStatusController>(
          builder: (context, controller, child) {
            // REMOVED: final bool isTimesheetSubmitted = widget.timesheet.status.toLowerCase() == 'submitted';
            final bool isLoading = controller.isLoading;

            // REMOVED: if (!isTimesheetSubmitted) { return const SizedBox.shrink(); }

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        label: 'Reject',
                        icon: Icons.close_rounded,
                        color: const Color(0xFFEF4444),
                        onPressed: isLoading
                            ? null
                            : () => _updateStatus(
                                'Reject',
                                'Are you sure you want to **reject** this timesheet?',
                              ),
                        isLoading: isLoading,
                        disabledColor: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        label: 'Approve',
                        icon: Icons.check_rounded,
                        color: const Color(0xFF10B981),
                        onPressed: isLoading
                            ? null
                            : () => _updateStatus(
                                'Approve',
                                'Are you sure you want to **approve** this timesheet?',
                              ),
                        isLoading: isLoading,
                        disabledColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    // ... (existing implementation)
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard({
    required int index,
    required String title,
    required String subtitle,
    required String fromTime,
    required String toTime,
    required String totalHours,
    required String description,
    required String project,
  }) {
    // ... (existing implementation)
    final bool isExpanded = expandedCards.contains(index);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isExpanded) {
            expandedCards.remove(index);
          } else {
            expandedCards.add(index);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isExpanded
                ? const Color(0xFF2E7D8A).withOpacity(0.3)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isExpanded
                  ? const Color(0xFF2E7D8A).withOpacity(0.1)
                  : Colors.black.withOpacity(0.04),
              blurRadius: isExpanded ? 20 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              // Main Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2E7D8A), Color(0xFF2E7D8A)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.work_outline_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subtitle,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF64748B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        AnimatedRotation(
                          duration: const Duration(milliseconds: 300),
                          turns: isExpanded ? 0.5 : 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF64748B),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Time Info Cards
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildTimeInfo(
                              icon: Icons.login_rounded,
                              label: 'From',
                              time: fromTime,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: const Color(0xFFE2E8F0),
                          ),
                          Expanded(
                            child: _buildTimeInfo(
                              icon: Icons.logout_rounded,
                              label: 'To',
                              time: toTime,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: const Color(0xFFE2E8F0),
                          ),
                          Expanded(
                            child: _buildTimeInfo(
                              icon: Icons.timer_outlined,
                              label: 'Total',
                              time: totalHours,
                              highlight: true,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Expanded Details
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      crossFadeState: isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: const SizedBox.shrink(),
                      secondChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),

                          // Description
                          _buildDetailSection(
                            icon: Icons.description_outlined,
                            title: 'Description',
                            content: description.isNotEmpty
                                ? description
                                : 'No description provided',
                          ),
                          const SizedBox(height: 16),

                          // Project and Client
                          Row(
                            children: [
                              Expanded(
                                child: _buildDetailSection(
                                  icon: Icons.folder_outlined,
                                  title: 'Project',
                                  content: project.isNotEmpty ? project : 'N/A',
                                  compact: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeInfo({
    required IconData icon,
    required String label,
    required String time,
    bool highlight = false,
  }) {
    // ... (existing implementation)
    return Column(
      children: [
        Icon(
          icon,
          size: 18,
          color: highlight ? const Color(0xFF2E7D8A) : const Color(0xFF64748B),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: highlight
                ? const Color(0xFF2E7D8A)
                : const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailSection({
    required IconData icon,
    required String title,
    required String content,
    bool compact = false,
  }) {
    // ... (existing implementation)
    return Container(
      padding: EdgeInsets.all(compact ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF64748B)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 6 : 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // Updated Action Button with loading state
  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
    required bool isLoading,
    required Color disabledColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        disabledBackgroundColor: disabledColor.withOpacity(0.5),
        disabledForegroundColor: Colors.white.withOpacity(0.7),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
