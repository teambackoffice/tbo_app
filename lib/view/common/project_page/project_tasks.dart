import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/get_admin_Task_list_controller.dart';
import 'package:tbo_app/modal/get_admin_task_list_modal.dart';
import 'package:tbo_app/view/common/project_page/project_task_details.dart';

class ProjectTasksListPage extends StatefulWidget {
  final String? projectId;
  final String? projectName;

  const ProjectTasksListPage({super.key, this.projectId, this.projectName});

  @override
  State<ProjectTasksListPage> createState() => _ProjectTasksListPageState();
}

class _ProjectTasksListPageState extends State<ProjectTasksListPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Open',
    'Working',
    'Completed',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetAdminTaskListController>().fetchProjectDetails(
        widget.projectId!,
      );
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  // --- Color & Style Helpers ---

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
        return _PriorityStyle(color: const Color(0xFFEF4444), label: '↑ High');
      case 'medium':
        return _PriorityStyle(
          color: const Color(0xFFF59E0B),
          label: '→ Medium',
        );
      case 'low':
        return _PriorityStyle(color: const Color(0xFF10B981), label: '↓ Low');
      default:
        return _PriorityStyle(color: const Color(0xFF6B7280), label: priority);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Consumer<GetAdminTaskListController>(
        builder: (context, controller, child) {
          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              _buildSliverAppBar(controller),
              if (!controller.isLoading && controller.errorMessage == null)
                _buildFilterBar(controller),
              _buildBody(controller),
            ],
          );
        },
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  // --- Sliver App Bar ---

  Widget _buildSliverAppBar(GetAdminTaskListController controller) {
    final tasks = controller.projectDetails?.data.tasks ?? [];
    final completedCount = tasks
        .where((t) => t.status.toLowerCase() == 'completed')
        .length;
    final progress = tasks.isEmpty ? 0.0 : completedCount / tasks.length;

    return SliverAppBar(
      expandedHeight: 160,
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
          padding: const EdgeInsets.fromLTRB(20, 90, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Project Tasks',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF129476),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.projectName ?? '',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              if (!controller.isLoading && tasks.isNotEmpty) ...[
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: const Color(0xFFE2E8F0),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF129476),
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$completedCount/${tasks.length} done',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        // title: Padding(
        //   padding: const EdgeInsets.only(left: 8),
        //   child: Text(
        //     widget.projectName ?? '',
        //     style: const TextStyle(
        //       fontSize: 16,
        //       fontWeight: FontWeight.w700,
        //       color: Color(0xFF0F172A),
        //       letterSpacing: -0.3,
        //     ),
        //   ),
        // ),
      ),
    );
  }

  // --- Filter Bar ---

  Widget _buildFilterBar(GetAdminTaskListController controller) {
    final tasks = controller.projectDetails?.data.tasks ?? [];

    Map<String, int> counts = {'All': tasks.length};
    for (final t in tasks) {
      final s = t.status;
      counts[s] = (counts[s] ?? 0) + 1;
    }

    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(bottom: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: _filters.map((f) {
              final isActive = _selectedFilter == f;
              final count = counts[f] ?? 0;
              if (f != 'All' && count == 0) return const SizedBox.shrink();

              return GestureDetector(
                onTap: () => setState(() => _selectedFilter = f),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF129476)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(
                        f,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? Colors.white
                              : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.white.withOpacity(0.25)
                              : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isActive
                                ? Colors.white
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // --- Body ---

  Widget _buildBody(GetAdminTaskListController controller) {
    if (controller.isLoading) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF129476),
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    if (controller.errorMessage != null) {
      return SliverFillRemaining(child: _buildErrorState(controller));
    }

    final allTasks = controller.projectDetails?.data.tasks ?? [];
    final tasks = _selectedFilter == 'All'
        ? allTasks
        : allTasks.where((t) => t.status == _selectedFilter).toList();

    if (tasks.isEmpty) {
      return SliverFillRemaining(child: _buildEmptyState());
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: _buildTaskCard(tasks[index], index, tasks),
          );
        }, childCount: tasks.length),
      ),
    );
  }

  // --- Task Card ---

  Widget _buildTaskCard(Task task, int index, List<Task> tasks) {
    final statusStyle = _getStatusStyle(task.status);
    final priorityStyle = _getPriorityStyle(task.priority);
    final hasDate =
        task.expectedStartDate != null || task.expectedEndDate != null;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 60).clamp(0, 400)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProjectTaskDetailPage(
                    task: tasks[index],
                    projectName: widget.projectName,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: status icon + subject + status chip
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: statusStyle.bg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          statusStyle.icon,
                          size: 18,
                          color: statusStyle.color,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.subject,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                                letterSpacing: -0.2,
                                height: 1.3,
                              ),
                            ),
                            if (task.description.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                task.description,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF94A3B8),
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusStyle.bg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          task.status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: statusStyle.color,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  const Divider(color: Color(0xFFF1F5F9), height: 1),
                  const SizedBox(height: 12),

                  // Bottom row: assignee + priority + dates
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 26,
                        height: 26,
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
                                : 'N/A',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: task.employeeName.isNotEmpty
                            ? Text(
                                task.employeeName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              )
                            : const Text(
                                'Not Assigned',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                      const SizedBox(width: 8),

                      // Priority badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: priorityStyle.color.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          priorityStyle.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: priorityStyle.color,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Date row
                  if (hasDate) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 12,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 6),
                          if (task.expectedStartDate != null)
                            Text(
                              DateFormat(
                                'MMM d',
                              ).format(DateTime.parse(task.expectedStartDate!)),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          if (task.expectedStartDate != null &&
                              task.expectedEndDate != null)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                '→',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                          if (task.expectedEndDate != null)
                            Text(
                              DateFormat(
                                'MMM d, y',
                              ).format(DateTime.parse(task.expectedEndDate!)),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Empty State ---

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.task_alt_rounded,
                size: 40,
                color: Color(0xFF129476),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Tasks Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedFilter == 'All'
                  ? 'Create your first task to get started'
                  : 'No "$_selectedFilter" tasks in this project',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF94A3B8),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Error State ---

  Widget _buildErrorState(GetAdminTaskListController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 40,
                color: Color(0xFFEF4444),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage ?? 'Unable to load tasks.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF94A3B8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () =>
                  controller.fetchProjectDetails(widget.projectId!),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF129476),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- FAB ---

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () => _showCreateTaskSheet(context),
      backgroundColor: const Color(0xFF129476),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
      label: const Text(
        'New Task',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 14,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  void _showCreateTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Create Task',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Task creation will be implemented here.',
              style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF129476),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Got it',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 8),
          ],
        ),
      ),
    );
  }
}

// --- Helper Data Classes ---

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
  const _PriorityStyle({required this.color, required this.label});
}
