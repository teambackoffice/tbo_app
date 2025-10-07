import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/all_employees._controller.dart';
import 'package:tbo_app/controller/employee_assignments_controller.dart';
import 'package:tbo_app/controller/task_employee_assign.dart';
import 'package:tbo_app/modal/employee_assignment_modal.dart';
import 'package:tbo_app/services/post_notification_service.dart';
import 'package:tbo_app/view/common/project_page/employee_assign_dialog.dart';

class ProjectTasks extends StatefulWidget {
  final String? projectId;
  const ProjectTasks({super.key, required this.projectId});

  @override
  _ProjectTasksState createState() => _ProjectTasksState();
}

class _ProjectTasksState extends State<ProjectTasks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployeeAssignmentsController>(
        context,
        listen: false,
      ).feetchemployeeassignments(projectId: widget.projectId!);
    });
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTaskDialog(
          onTaskAdded: (String project, String task, String employee) {
            Provider.of<EmployeeAssignmentsController>(
              context,
              listen: false,
            ).feetchemployeeassignments(projectId: widget.projectId!);
          },
        );
      },
    );
  }

  void _showEmployeeAssignmentDialog(
    BuildContext context,
    TaskAssignment taskAssignment,
  ) {
    // Pre-load employees if not already loaded
    final allEmployeesController = Provider.of<AllEmployeesController>(
      context,
      listen: false,
    );

    if (allEmployeesController.allEmployees == null) {
      allEmployeesController.fetchallemployees();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => AllEmployeesController(),
            ),
            ChangeNotifierProvider(
              create: (context) => TaskEmployeeAssignController(),
            ),
          ],
          child: EmployeeAssignmentDialog(
            taskId: taskAssignment.task,
            taskSubject: taskAssignment.taskSubject,
            onEmployeeAssigned: (String employeeId, String employeeName) {
              _assignEmployeeToTask(
                taskAssignment.task,
                employeeId,
                employeeName,
              );
            },
          ),
        );
      },
    );
  }

  // Add this import at the top of your file

  void _assignEmployeeToTask(
    String taskId,
    String employeeId,
    String employeeName,
  ) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 12),
              Text('Assigning $employeeName to task...'),
            ],
          ),
          duration: Duration(seconds: 3),
        ),
      );

      final assignmentController = Provider.of<EmployeeAssignmentsController>(
        context,
        listen: false,
      );

      String? assignmentId;
      TaskAssignment? currentTask;

      for (var assignment in assignmentController.allLeads?.data ?? []) {
        for (var task in assignment.taskAssignments) {
          if (task.task == taskId) {
            assignmentId = assignment.assignmentId;
            currentTask = task;
            break;
          }
        }
        if (assignmentId != null) break;
      }

      if (assignmentId == null || currentTask == null) {
        throw Exception('Assignment not found for task');
      }

      final taskAssignments = [
        {"task_id": taskId, "employee_id": employeeId},
      ];

      final taskAssignController = TaskEmployeeAssignController();

      await taskAssignController.updateAssignmentEmployees(
        assignmentId: assignmentId,
        taskAssignments: taskAssignments,
        subTaskAssignments: [],
      );

      if (taskAssignController.error != null) {
        throw Exception(taskAssignController.error);
      }

      // ✅ Get the ASSIGNED employee's email (not the logged-in user's email)
      final allEmployeesController = Provider.of<AllEmployeesController>(
        context,
        listen: false,
      );

      String? assignedEmployeeEmail;

      // Find the assigned employee by their ID
      if (allEmployeesController.allEmployees != null) {
        try {
          final employee = allEmployeesController.allEmployees!.message
              .firstWhere(
                (emp) => emp.name == employeeId,
                orElse: () => throw Exception('Employee not found'),
              );

          // ✅ Get employee's email (check your Message model for correct field name)
          // Common field names: email, userEmail, emailAddress, userId
          assignedEmployeeEmail =
              employee.userId; // Adjust this based on your model
        } catch (e) {
          throw Exception('Could not find assigned employee details');
        }
      } else {
        throw Exception('Employee list not loaded');
      }

      if (assignedEmployeeEmail.isEmpty) {
        throw Exception('Employee email not found for $employeeName');
      }

      // ✅ Get current logged-in user's details for "assigned by" name
      final storage = FlutterSecureStorage();
      String? currentUserEmail = await storage.read(key: "email");
      String? currentUserFullName = await storage.read(key: "full_name");

      // Use full name if available, otherwise use email, otherwise use 'Admin'
      String assignerName =
          currentUserFullName ?? currentUserEmail?.split('@')[0] ?? 'Admin';

      // ✅ Send notification to the ASSIGNED employee's email
      final notificationSent =
          await PostNotificationService.sendTaskAssignmentNotification(
            employeeEmail:
                assignedEmployeeEmail, // ✅ Use assigned employee's email
            taskSubject: currentTask.taskSubject,
            taskId: taskId,
            assignerName: assignerName,
          );

      if (!notificationSent) {
        // Don't throw error - task was assigned successfully
      } else {}

      // Refresh the task list
      Provider.of<EmployeeAssignmentsController>(
        context,
        listen: false,
      ).feetchemployeeassignments(projectId: widget.projectId!);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully assigned $employeeName to task!'),
          backgroundColor: Color(0xFF34C759),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to assign employee: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
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
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Tasks',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _showAddTaskDialog,
            child: Text(
              'Add Task',
              style: TextStyle(
                color: Color(0xFF1C7690),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<EmployeeAssignmentsController>(
        builder: (context, employeeAssignmentsController, child) {
          if (employeeAssignmentsController.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFF1C7690)),
            );
          }

          if (employeeAssignmentsController.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error: ${employeeAssignmentsController.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      employeeAssignmentsController.feetchemployeeassignments(
                        projectId: widget.projectId!,
                      );
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final assignments =
              employeeAssignmentsController.allLeads?.data ?? [];

          final List<TaskAssignment> allTasks = [];
          for (var assignment in assignments) {
            allTasks.addAll(assignment.taskAssignments);
          }

          if (allTasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No tasks available',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: allTasks.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  taskAssignment: allTasks[index],
                  onDelete: () {
                    _showDeleteConfirmation(context, allTasks[index]);
                  },
                  onAssignEmployee: () {
                    _showEmployeeAssignmentDialog(context, allTasks[index]);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, TaskAssignment task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text(
            'Are you sure you want to delete "${task.taskSubject}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<EmployeeAssignmentsController>(
                  context,
                  listen: false,
                ).feetchemployeeassignments(projectId: widget.projectId!);
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

class TaskCard extends StatelessWidget {
  final TaskAssignment taskAssignment;
  final VoidCallback onDelete;
  final VoidCallback onAssignEmployee;

  const TaskCard({
    super.key,
    required this.taskAssignment,
    required this.onDelete,
    required this.onAssignEmployee,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(taskAssignment.assignmentStatus),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  taskAssignment.assignmentStatus.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.delete_outline,
                    color: Color(0xFFFF3B30),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            taskAssignment.taskSubject,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.assignment, size: 16, color: Color(0xFF8E8E93)),
              SizedBox(width: 4),
              Text(
                'Task ID: ${taskAssignment.task}',
                style: TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.work_outline, size: 16, color: Color(0xFF8E8E93)),
              SizedBox(width: 4),
              Text(
                'Workload: ${taskAssignment.workloadPercentage}%',
                style: TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              if (taskAssignment.employee == null ||
                  taskAssignment.employeeName == null)
                GestureDetector(
                  onTap: onAssignEmployee,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF1C7690).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xFF1C7690), width: 1),
                    ),
                    child: Text(
                      'Assign Employee',
                      style: TextStyle(
                        color: Color(0xFF1C7690),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              else ...[
                Text(
                  'Assigned to: ',
                  style: TextStyle(
                    color: Color(0xFF8E8E93),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF1C7690),
                  child: Text(
                    taskAssignment.employeeName?.toString()[0].toUpperCase() ??
                        'U',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    taskAssignment.employeeName?.toString() ?? 'Unknown',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Color(0xFF34C759);
      case 'in progress':
      case 'working':
        return Color(0xFFFF9500);
      case 'pending':
        return Color(0xFF8E8E93);
      case 'overdue':
        return Color(0xFFFF3B30);
      default:
        return Color(0xFF1C7690);
    }
  }
}

class AddTaskDialog extends StatefulWidget {
  final Function(String, String, String) onTaskAdded;

  const AddTaskDialog({super.key, required this.onTaskAdded});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _employeeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _projectController.text = 'Onshore Website';
    _taskController.text = 'Task1';
    _employeeController.text = 'Jasir';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xFFF2F2F7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Project',
                    style: TextStyle(
                      color: Color(0xFF8E8E93),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFE5E5EA), width: 1),
                    ),
                    child: TextFormField(
                      controller: _projectController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Task',
                    style: TextStyle(
                      color: Color(0xFF8E8E93),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFE5E5EA), width: 1),
                    ),
                    child: TextFormField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Employee',
                    style: TextStyle(
                      color: Color(0xFF8E8E93),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFE5E5EA), width: 1),
                    ),
                    child: TextFormField(
                      controller: _employeeController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onTaskAdded(
                          _projectController.text,
                          _taskController.text,
                          _employeeController.text,
                        );
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1C7690),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Add Task',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _projectController.dispose();
    _taskController.dispose();
    _employeeController.dispose();
    super.dispose();
  }
}
