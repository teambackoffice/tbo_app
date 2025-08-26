import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/task_list_controller.dart';
import 'package:tbo_app/services/login_service.dart';
import 'package:tbo_app/view/employee/task_page/todo/todo_details.dart';

class ToDoTaskList extends StatefulWidget {
  const ToDoTaskList({super.key});

  @override
  State<ToDoTaskList> createState() => _ToDoTaskListState();
}

class _ToDoTaskListState extends State<ToDoTaskList> {
  final _loginService =
      LoginService(); // Assuming you have a LoginService to get stored email

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // ✅ Get stored email
      final email = await _loginService.getStoredEmail();

      // ✅ Call controller with email as assignedUsers
      Provider.of<TaskListController>(context, listen: false).fetchtasklist(
        status: "Open",
        assignedUsers: email, // if null, fallback to empty string
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
            return Container(
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C7690),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      task.priority,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Task title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          task.subject!,
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

                  // Time & Due Date labels
                  Row(
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.access_time_outlined,
                            size: 16,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Start Date",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 60),
                      Row(
                        children: const [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Due Date",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Values row
                  Row(
                    children: [
                      Text(
                        DateFormat('dd MMM yyyy').format(task.expStartDate!),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 60),
                      Text(
                        DateFormat('dd MMM yyyy').format(task.expEndDate!),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TodoDetails(task: task), // Your details page
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_outward,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
