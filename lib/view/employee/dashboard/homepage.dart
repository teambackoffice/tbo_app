import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/employee_task_list_controller.dart';
import 'package:tbo_app/controller/task_count_controller.dart';
import 'package:tbo_app/modal/employee_task_list_modal.dart';
import 'package:tbo_app/view/employee/bottom_navigation/bottom_navigation_emply.dart';
import 'package:tbo_app/view/employee/dashboard/high_task_details.dart';
import 'package:tbo_app/view/employee/dashboard/medium_task_details.dart';
import 'package:tbo_app/view/employee/dashboard/notification/notification.dart';

class Homepage extends StatefulWidget {
  final Function(int)? onTabChange;
  const Homepage({super.key, this.onTabChange});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    // Initialize the task count data when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<TaskCountController>(
        context,
        listen: false,
      );
      controller.fetchTaskSummary(status: "all"); // or whatever status you need
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskByEmployeeController>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile & Notification
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE8F4F2),
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e'
                                '?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello Ahmad !",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Web Designer",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF5A7B8C),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.notifications_outlined),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  "All your activities in\none place",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recent Tasks",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const EmployeeBottomNavigation(initialIndex: 1),
                          ),
                        );
                      },
                      child: const Text(
                        "See all",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Inline Task Cards (Static for now)
                Consumer<TaskByEmployeeController>(
                  builder: (context, taskController, _) {
                    if (taskController.isLoading) {
                      return SizedBox(
                        height: 218,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (taskController.errorMessage != null) {
                      return Container(
                        height: 218,
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Error loading tasks",
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => taskController.fetchTasks(),
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Filter working tasks and get first 2
                    final workingTasks =
                        taskController.taskListResponse?.data
                            .where(
                              (task) => task.status.toLowerCase() == 'open',
                            )
                            .take(2)
                            .toList() ??
                        [];

                    // If no working tasks, show open tasks
                    final tasksToShow = workingTasks.isEmpty
                        ? (taskController.taskListResponse?.data
                                  .take(2)
                                  .toList() ??
                              [])
                        : workingTasks;

                    if (tasksToShow.isEmpty) {
                      return Container(
                        height: 218,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            "No tasks available",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      );
                    }

                    return Row(
                      children: [
                        // First task or placeholder
                        Expanded(
                          child: tasksToShow.isNotEmpty
                              ? _buildDynamicTaskCard(
                                  context,
                                  task: tasksToShow[0],
                                )
                              : _buildPlaceholderCard(context, "No Task"),
                        ),
                        const SizedBox(width: 16),
                        // Second task or placeholder
                        Expanded(
                          child: tasksToShow.length > 1
                              ? _buildDynamicTaskCard(
                                  context,
                                  task: tasksToShow[1],
                                )
                              : _buildPlaceholderCard(context, "No Task"),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Task Overview",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    // Add refresh button for debugging
                    IconButton(
                      onPressed: () {
                        final controller = Provider.of<TaskCountController>(
                          context,
                          listen: false,
                        );
                        controller.fetchTaskSummary(status: "all");
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Task Overview Pie Chart with Provider
                Consumer<TaskCountController>(
                  builder: (context, controller, _) {
                    if (controller.isLoading) {
                      return Container(
                        height: 238,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (controller.errorMessage != null) {
                      return Container(
                        height: 238,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Error: ${controller.errorMessage}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  controller.fetchTaskSummary(status: "all");
                                },
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Check if we have data
                    final hasData =
                        controller.taskSummaryData != null &&
                        (controller.openTask > 0 ||
                            controller.workingTask > 0 ||
                            controller.completedTask > 0);

                    if (!hasData) {
                      return Container(
                        height: 238,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "No task data available",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      );
                    }

                    return Container(
                      height: 238,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 140,
                            width: 140,
                            child: PieChart(
                              PieChartData(
                                centerSpaceRadius: 50,
                                sectionsSpace: 4,
                                sections: _buildPieChartSections(controller),
                              ),
                            ),
                          ),
                          const SizedBox(width: 80),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Indicator(
                                  color: const Color(0xFFFF9500),
                                  text: "Open Task",
                                  value: "${controller.openTask}",
                                ),
                                const SizedBox(height: 16),
                                Indicator(
                                  color: const Color(0xFFF5DEB3),
                                  text: "Working Task",
                                  value: "${controller.workingTask}",
                                ),
                                const SizedBox(height: 16),
                                Indicator(
                                  color: const Color(0xFF4CAF50),
                                  text: "Completed Task",
                                  value: "${controller.completedTask}",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicTaskCard(BuildContext context, {required Task task}) {
    // Determine card color based on priority
    Color cardColor;
    Color priorityBgColor;

    switch (task.priority.toLowerCase()) {
      case 'high':
        cardColor = const Color(0xFF475569);
        priorityBgColor = const Color(0xFFFFE5E5);
        break;
      case 'medium':
        cardColor = const Color(0xFF475569);
        priorityBgColor = const Color(0xFFFFF3E0);
        break;
      case 'low':
        cardColor = const Color(0xFF129476);
        priorityBgColor = const Color(0xFFE0E7FF);
        break;
      default:
        cardColor = const Color(0xFF64748B);
        priorityBgColor = const Color(0xFFF1F5F9);
    }

    // Format the expected end date
    String formattedDate = "No Due Date";
    if (task.expEndDate != null && task.expEndDate!.isNotEmpty) {
      try {
        final date = DateTime.parse(task.expEndDate!);
        formattedDate =
            "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString().substring(2)}";
      } catch (e) {
        formattedDate = task.expEndDate!;
      }
    }

    return Container(
      padding: const EdgeInsets.all(15),
      height: 218,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: priorityBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              task.priority,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            task.subject.length > 20
                ? "${task.subject.substring(0, 20)}..."
                : task.subject,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: Colors.white70,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                "Progress",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "${task.progress?.toInt() ?? 0}%",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigate to task details based on priority or create a generic task detail page
                  if (task.priority.toLowerCase() == 'high') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HighTaskDetails(),
                      ),
                    );
                  } else if (task.priority.toLowerCase() == 'medium') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MediumTaskDetails(),
                      ),
                    );
                  }
                  // You might want to create a generic TaskDetailsPage and pass the task data
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.arrow_outward,
                    color: Colors.black,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderCard(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.all(15),
      height: 218,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(
    TaskCountController controller,
  ) {
    List<PieChartSectionData> sections = [];

    if (controller.openTask > 0) {
      sections.add(
        PieChartSectionData(
          color: const Color(0xFFFF9500),
          value: controller.openTask.toDouble(),
          radius: 30,
          showTitle: false,
        ),
      );
    }

    if (controller.workingTask > 0) {
      sections.add(
        PieChartSectionData(
          color: const Color(0xFFF5DEB3),
          value: controller.workingTask.toDouble(),
          radius: 30,
          showTitle: false,
        ),
      );
    }

    if (controller.completedTask > 0) {
      sections.add(
        PieChartSectionData(
          color: const Color(0xFF4CAF50),
          value: controller.completedTask.toDouble(),
          radius: 30,
          showTitle: false,
        ),
      );
    }

    // If no data, show a placeholder section
    if (sections.isEmpty) {
      sections.add(
        PieChartSectionData(
          color: Colors.grey.shade300,
          value: 1,
          radius: 30,
          showTitle: false,
        ),
      );
    }

    return sections;
  }

  // Helper to build static task card
  Widget _buildTaskCard(
    BuildContext context, {
    required Color color,
    required String priority,
    required String title,
    required String dueDate,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      height: 218,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: priority == "High"
                  ? const Color(0xFFFFE5E5)
                  : const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              priority,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: Colors.white70,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                "Time",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "18 Hours",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dueDate,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.arrow_outward,
                    color: Colors.black,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Indicator Widget
class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final String value;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
