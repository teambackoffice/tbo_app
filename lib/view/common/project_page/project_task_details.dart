import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tbo_app/modal/get_admin_task_list_modal.dart';

class ProjectTaskDetailPage extends StatefulWidget {
  final Task task;
  final String? projectName;

  const ProjectTaskDetailPage({
    super.key,
    required this.task,
    this.projectName,
  });

  @override
  State<ProjectTaskDetailPage> createState() => _ProjectTaskDetailPageState();
}

class _ProjectTaskDetailPageState extends State<ProjectTaskDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  // --- Style Helpers (same as list page) ---
  _StatusStyle _getStatusStyle(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return _StatusStyle(
          color: const Color(0xFF3B82F6),
          bg: const Color(0xFFEFF6FF),
          icon: Icons.radio_button_unchecked_rounded,
        );
      case 'working':
        return _StatusStyle(
          color: const Color(0xFFF59E0B),
          bg: const Color(0xFFFFFBEB),
          icon: Icons.timelapse_rounded,
        );
      case 'completed':
        return _StatusStyle(
          color: const Color(0xFF10B981),
          bg: const Color(0xFFECFDF5),
          icon: Icons.check_circle_outline_rounded,
        );
      case 'cancelled':
        return _StatusStyle(
          color: const Color(0xFFEF4444),
          bg: const Color(0xFFFEF2F2),
          icon: Icons.cancel_outlined,
        );
      default:
        return _StatusStyle(
          color: const Color(0xFF6B7280),
          bg: const Color(0xFFF9FAFB),
          icon: Icons.help_outline_rounded,
        );
    }
  }

  _PriorityStyle _getPriorityStyle(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return _PriorityStyle(
          color: const Color(0xFFEF4444),
          label: '↑ High',
          bg: const Color(0xFFFEF2F2),
        );
      case 'medium':
        return _PriorityStyle(
          color: const Color(0xFFF59E0B),
          label: '→ Medium',
          bg: const Color(0xFFFFFBEB),
        );
      case 'low':
        return _PriorityStyle(
          color: const Color(0xFF10B981),
          label: '↓ Low',
          bg: const Color(0xFFECFDF5),
        );
      default:
        return _PriorityStyle(
          color: const Color(0xFF6B7280),
          label: priority,
          bg: const Color(0xFFF9FAFB),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final statusStyle = _getStatusStyle(task.status);
    final priorityStyle = _getPriorityStyle(task.priority);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(task, statusStyle),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusAndPriorityRow(
                        statusStyle,
                        priorityStyle,
                        task,
                      ),
                      const SizedBox(height: 20),
                      if (task.description.isNotEmpty) ...[
                        _buildSection(
                          title: 'Description',
                          icon: Icons.notes_rounded,
                          child: Text(
                            task.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF475569),
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      _buildAssigneeSection(task),
                      const SizedBox(height: 16),
                      _buildDatesSection(task),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Sliver App Bar ---
  Widget _buildSliverAppBar(Task task, _StatusStyle statusStyle) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black.withOpacity(0.08),
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0F172A),
            size: 18,
          ),
        ),
      ),

      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 96, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Text(
                    'Task Detail',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF129476),
                      letterSpacing: 1.2,
                    ),
                  ),
                  if (widget.projectName != null) ...[
                    const Text(
                      '  /  ',
                      style: TextStyle(fontSize: 11, color: Color(0xFFCBD5E1)),
                    ),
                    Flexible(
                      child: Text(
                        widget.projectName!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF94A3B8),
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              Text(
                task.subject,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                  height: 1.25,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // --- Status & Priority Row ---
  Widget _buildStatusAndPriorityRow(
    _StatusStyle statusStyle,
    _PriorityStyle priorityStyle,
    Task task,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoTile(
            label: 'Status',
            icon: statusStyle.icon,
            iconColor: statusStyle.color,
            bgColor: statusStyle.bg,
            value: task.status,
            valueColor: statusStyle.color,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoTile(
            label: 'Priority',
            icon: Icons.flag_rounded,
            iconColor: priorityStyle.color,
            bgColor: priorityStyle.bg,
            value: task.priority,
            valueColor: priorityStyle.color,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required String label,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: valueColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Section Wrapper ---
  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 15, color: const Color(0xFF129476)),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  // --- Assignee Section ---
  Widget _buildAssigneeSection(Task task) {
    return _buildSection(
      title: 'Assigned To',
      icon: Icons.person_outline_rounded,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF129476).withOpacity(0.7),
                  const Color(0xFF129476),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                task.employeeName.isNotEmpty
                    ? task.employeeName[0].toUpperCase()
                    : 'N',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.employeeName.isNotEmpty
                      ? task.employeeName
                      : 'Not Assigned',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: task.employeeName.isNotEmpty
                        ? const Color(0xFF0F172A)
                        : const Color(0xFF94A3B8),
                  ),
                ),
                if (task.employeeName.isNotEmpty)
                  const Text(
                    'Team Member',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          if (task.employeeName.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 13,
                    color: Color(0xFF129476),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Message',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF129476),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // --- Dates Section ---
  Widget _buildDatesSection(Task task) {
    final hasStart = task.expectedStartDate != null;
    final hasEnd = task.expectedEndDate != null;

    if (!hasStart && !hasEnd) return const SizedBox.shrink();

    DateTime? startDate = hasStart
        ? DateTime.tryParse(task.expectedStartDate!)
        : null;
    DateTime? endDate = hasEnd
        ? DateTime.tryParse(task.expectedEndDate!)
        : null;

    // Calculate days left/overdue
    String? daysLabel;
    Color? daysColor;
    if (endDate != null) {
      final now = DateTime.now();
      final diff = endDate.difference(now).inDays;
      if (task.status.toLowerCase() == 'completed') {
        daysLabel = 'Completed';
        daysColor = const Color(0xFF10B981);
      } else if (diff < 0) {
        daysLabel = '${diff.abs()}d overdue';
        daysColor = const Color(0xFFEF4444);
      } else if (diff == 0) {
        daysLabel = 'Due today';
        daysColor = const Color(0xFFF59E0B);
      } else {
        daysLabel = '$diff days left';
        daysColor = const Color(0xFF129476);
      }
    }

    return _buildSection(
      title: 'Timeline',
      icon: Icons.calendar_today_rounded,
      child: Column(
        children: [
          Row(
            children: [
              if (hasStart) ...[
                Expanded(
                  child: _buildDateBlock(
                    label: 'Start Date',
                    date: startDate!,
                    icon: Icons.play_circle_outline_rounded,
                    color: const Color(0xFF3B82F6),
                    bg: const Color(0xFFEFF6FF),
                  ),
                ),
              ],
              if (hasStart && hasEnd)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: Colors.grey.shade400,
                  ),
                ),
              if (hasEnd) ...[
                Expanded(
                  child: _buildDateBlock(
                    label: 'End Date',
                    date: endDate!,
                    icon: Icons.flag_outlined,
                    color: const Color(0xFF129476),
                    bg: const Color(0xFFECFDF5),
                  ),
                ),
              ],
            ],
          ),
          if (daysLabel != null) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: daysColor!.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  daysLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: daysColor,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateBlock({
    required String label,
    required DateTime date,
    required IconData icon,
    required Color color,
    required Color bg,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            DateFormat('MMM d, y').format(date),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            DateFormat('EEEE').format(date),
            style: TextStyle(
              fontSize: 11,
              color: color.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: const Color(0xFF64748B)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Status Change Bottom Sheet ---
  void _showStatusSheet(BuildContext context, Task task) {
    final statuses = [
      _StatusOption(
        'Open',
        Icons.radio_button_unchecked_rounded,
        const Color(0xFF3B82F6),
        const Color(0xFFEFF6FF),
      ),
      _StatusOption(
        'Working',
        Icons.timelapse_rounded,
        const Color(0xFFF59E0B),
        const Color(0xFFFFFBEB),
      ),
      _StatusOption(
        'Completed',
        Icons.check_circle_outline_rounded,
        const Color(0xFF10B981),
        const Color(0xFFECFDF5),
      ),
      _StatusOption(
        'Cancelled',
        Icons.cancel_outlined,
        const Color(0xFFEF4444),
        const Color(0xFFFEF2F2),
      ),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          16,
          24,
          MediaQuery.of(context).padding.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Change Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...statuses.map((s) {
              final isCurrent =
                  task.status.toLowerCase() == s.label.toLowerCase();
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // TODO: call controller to update status
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isCurrent ? s.bg : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCurrent
                          ? s.color.withOpacity(0.3)
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: s.bg,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Icon(s.icon, size: 17, color: s.color),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        s.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isCurrent ? s.color : const Color(0xFF0F172A),
                        ),
                      ),
                      const Spacer(),
                      if (isCurrent)
                        Icon(Icons.check_rounded, size: 18, color: s.color),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// --- Helper Classes ---
class _StatusStyle {
  final Color color;
  final Color bg;
  final IconData icon;
  const _StatusStyle({
    required this.color,
    required this.bg,
    required this.icon,
  });
}

class _PriorityStyle {
  final Color color;
  final String label;
  final Color bg;
  const _PriorityStyle({
    required this.color,
    required this.label,
    required this.bg,
  });
}

class _StatusOption {
  final String label;
  final IconData icon;
  final Color color;
  final Color bg;
  const _StatusOption(this.label, this.icon, this.color, this.bg);
}
