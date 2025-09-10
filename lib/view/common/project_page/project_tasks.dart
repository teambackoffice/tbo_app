import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final List<String> assignedEmployees;

  Task({
    required this.id,
    required this.title,
    required this.assignedEmployees,
  });
}

class ProjectTasks extends StatefulWidget {
  const ProjectTasks({super.key});

  @override
  _ProjectTasksState createState() => _ProjectTasksState();
}

class _ProjectTasksState extends State<ProjectTasks> {
  List<Task> tasks = [
    Task(
      id: 'Task 1',
      title: 'Gather Client Requirements',
      assignedEmployees: [],
    ),
    Task(
      id: 'Task 2',
      title: 'Create UI/UX Wireframes',
      assignedEmployees: ['Employee 1', 'Employee 2', 'Employee 3'],
    ),
    Task(
      id: 'Task 3',
      title: 'Develop Frontend',
      assignedEmployees: ['Employee 1', 'Employee 2', 'Employee 3'],
    ),
    Task(
      id: 'Task 4',
      title: 'Integrate Backend & Database',
      assignedEmployees: ['Employee 1', 'Employee 2', 'Employee 3'],
    ),
    Task(
      id: 'Task 5',
      title: 'Testing & Deployment',
      assignedEmployees: ['Employee 1', 'Employee 2', 'Employee 3'],
    ),
  ];

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTaskDialog(
          onTaskAdded: (String project, String task, String employee) {
            setState(() {
              tasks.add(
                Task(
                  id: 'Task ${tasks.length + 1}',
                  title: task,
                  assignedEmployees: employee.isNotEmpty ? [employee] : [],
                ),
              );
            });
          },
        );
      },
    );
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return TaskCard(
              task: tasks[index],
              onDelete: () {
                setState(() {
                  tasks.removeAt(index);
                });
              },
            );
          },
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;

  const TaskCard({super.key, required this.task, required this.onDelete});

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
              Text(
                task.id,
                style: TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
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
          SizedBox(height: 8),
          Text(
            task.title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              if (task.assignedEmployees.isEmpty)
                Text(
                  'Assign Employees',
                  style: TextStyle(
                    color: Color(0xFF1C7690),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )
              else ...[
                Text(
                  'Assigned Employees',
                  style: TextStyle(
                    color: Color(0xFF8E8E93),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 8),
                Row(
                  children: task.assignedEmployees.take(3).map((employee) {
                    int index = task.assignedEmployees.indexOf(employee);
                    return Container(
                      margin: EdgeInsets.only(right: 4),
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: _getAvatarColor(index),
                        child: Text(
                          employee[0].toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _getAvatarColor(int index) {
    List<Color> colors = [
      Color(0xFF34C759),
      Color(0xFFFF9500),
      Color(0xFFFF3B30),
      Color(0xFF007AFF),
      Color(0xFF5856D6),
    ];
    return colors[index % colors.length];
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
                        'Add Employee',
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
