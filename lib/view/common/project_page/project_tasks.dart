import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/all_employees._controller.dart';
import 'package:tbo_app/controller/employee_assignments_controller.dart';
import 'package:tbo_app/controller/task_employee_assign.dart';
import 'package:tbo_app/modal/all_employees.modal.dart';
import 'package:tbo_app/modal/employee_assignment_modal.dart';

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
            // TODO: Implement API call to add new task
            // For now, refresh the data
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

  void _assignEmployeeToTask(
    String taskId,
    String employeeId,
    String employeeName,
  ) async {
    try {
      // Show loading indicator
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

      // Get the assignment controller to find the assignment ID
      final assignmentController = Provider.of<EmployeeAssignmentsController>(
        context,
        listen: false,
      );

      // Find the assignment that contains this task
      String? assignmentId;
      for (var assignment in assignmentController.allLeads?.data ?? []) {
        for (var task in assignment.taskAssignments) {
          if (task.task == taskId) {
            assignmentId = assignment.assignmentId;
            break;
          }
        }
        if (assignmentId != null) break;
      }

      if (assignmentId == null) {
        throw Exception('Assignment not found for task');
      }

      // Create the task assignment payload
      final taskAssignments = [
        {"task_id": taskId, "employee_id": employeeId},
      ];

      // Call the API using TaskEmployeeAssignController
      final taskAssignController = TaskEmployeeAssignController();

      await taskAssignController.updateAssignmentEmployees(
        assignmentId: assignmentId,
        taskAssignments: taskAssignments,
        subTaskAssignments: [], // Empty for now, add if you have subtasks
      );

      // Check for errors
      if (taskAssignController.error != null) {
        throw Exception(taskAssignController.error);
      }

      // Refresh the task list
      Provider.of<EmployeeAssignmentsController>(
        context,
        listen: false,
      ).feetchemployeeassignments(projectId: widget.projectId!);

      // Show success message
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully assigned $employeeName to task!'),
          backgroundColor: Color(0xFF34C759),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Hide loading and show error
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

          // Flatten all task assignments from all assignments
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
                    // TODO: Implement API call to delete task
                    // For now, show a confirmation dialog
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
                // TODO: Implement actual delete API call
                // For now, just refresh the data
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
            // Close button
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

            // Form content
            Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project field
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

                  // Task field
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

                  // Employee field
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

                  // Add Employee button
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

// Employee Assignment Dialog
class EmployeeAssignmentDialog extends StatefulWidget {
  final String taskId;
  final String taskSubject;
  final Function(String employeeId, String employeeName) onEmployeeAssigned;

  const EmployeeAssignmentDialog({
    super.key,
    required this.taskId,
    required this.taskSubject,
    required this.onEmployeeAssigned,
  });

  @override
  _EmployeeAssignmentDialogState createState() =>
      _EmployeeAssignmentDialogState();
}

class _EmployeeAssignmentDialogState extends State<EmployeeAssignmentDialog> {
  Message? selectedEmployee;
  TextEditingController searchController = TextEditingController();
  List<Message> filteredEmployees = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AllEmployeesController>(
        context,
        listen: false,
      ).fetchallemployees();
    });
  }

  void _filterEmployees(List<Message> employees, String query) {
    setState(() {
      if (query.isEmpty) {
        filteredEmployees = employees;
      } else {
        filteredEmployees = employees
            .where(
              (employee) =>
                  employee.employeeName.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  employee.designation.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  employee.department.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF1C7690),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Assign Employee',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Task: ${widget.taskSubject}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFE5E5EA), width: 1),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    final controller = Provider.of<AllEmployeesController>(
                      context,
                      listen: false,
                    );
                    if (controller.allEmployees != null) {
                      _filterEmployees(controller.allEmployees!.message, value);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Search employees...',
                    hintStyle: TextStyle(color: Color(0xFF8E8E93)),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF8E8E93)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),

            // Employee List
            Expanded(
              child: Consumer<AllEmployeesController>(
                builder: (context, controller, child) {
                  if (controller.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1C7690),
                      ),
                    );
                  }

                  if (controller.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Error loading employees',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            controller.error!,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => controller.fetchallemployees(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF1C7690),
                            ),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (controller.allEmployees == null ||
                      controller.allEmployees!.message.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No employees found',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  // Initialize filtered list if empty
                  if (filteredEmployees.isEmpty &&
                      searchController.text.isEmpty) {
                    filteredEmployees = controller.allEmployees!.message;
                  }

                  final employeesToShow =
                      filteredEmployees.isEmpty &&
                          searchController.text.isNotEmpty
                      ? <Message>[]
                      : filteredEmployees;

                  if (employeesToShow.isEmpty &&
                      searchController.text.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No employees found for "${searchController.text}"',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: employeesToShow.length,
                    itemBuilder: (context, index) {
                      final employee = employeesToShow[index];
                      final isSelected =
                          selectedEmployee?.name == employee.name;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedEmployee = employee;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(0xFF1C7690).withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Color(0xFF1C7690)
                                  : Color(0xFFE5E5EA),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Employee Avatar
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Color(0xFF1C7690),
                                backgroundImage: employee.imageUrl.isNotEmpty
                                    ? NetworkImage(employee.imageUrl)
                                    : null,
                                child: employee.imageUrl.isEmpty
                                    ? Text(
                                        employee.employeeName.isNotEmpty
                                            ? employee.employeeName[0]
                                                  .toUpperCase()
                                            : 'U',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : null,
                              ),
                              SizedBox(width: 12),

                              // Employee Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      employee.employeeName,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      employee.designation,
                                      style: TextStyle(
                                        color: Color(0xFF8E8E93),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      employee.department,
                                      style: TextStyle(
                                        color: Color(0xFF8E8E93),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Selection Indicator
                              if (isSelected)
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF1C7690),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Action Buttons
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Color(0xFFE5E5EA)),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF8E8E93),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: selectedEmployee != null
                          ? () {
                              widget.onEmployeeAssigned(
                                selectedEmployee!.name,
                                selectedEmployee!.employeeName,
                              );
                              Navigator.of(context).pop();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedEmployee != null
                            ? Color(0xFF1C7690)
                            : Color(0xFFE5E5EA),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Assign',
                        style: TextStyle(
                          color: selectedEmployee != null
                              ? Colors.white
                              : Color(0xFF8E8E93),
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
    searchController.dispose();
    super.dispose();
  }
}
