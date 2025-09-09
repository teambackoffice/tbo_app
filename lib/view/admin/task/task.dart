import 'package:flutter/material.dart';
import 'package:tbo_app/view/admin/task/todo/todo_details.dart';

class AdminTaskPage extends StatefulWidget {
  const AdminTaskPage({super.key});

  @override
  _AdminTaskPageState createState() => _AdminTaskPageState();
}

class _AdminTaskPageState extends State<AdminTaskPage> {
  String selectedFilter = 'All';
  String selectedDate = '';

  @override
  void initState() {
    super.initState();
    // Set today's date when the page loads
    final now = DateTime.now();
    selectedDate =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year.toString().substring(2)}';
  }

  final List<String> filterOptions = ['All', 'Open', 'Progress', 'Completed'];

  final List<Map<String, dynamic>> tasks = [
    {
      'name': 'Task Name 1',
      'priority': 'High',
      'time': '18 Hours',
      'dueDate': '15-07-25',
      'assignedAvatars': 3,
    },
    {
      'name': 'Task Name 2',
      'priority': 'Medium',
      'time': '18 Hours',
      'dueDate': '15-07-25',
      'assignedAvatars': 3,
    },
    {
      'name': 'Task Name 3',
      'priority': 'Low',
      'time': '18 Hours',
      'dueDate': '15-07-25',
      'assignedAvatars': 3,
    },
  ];

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Color(0xFF2D7D8C);
      case 'Medium':
        return Color(0xFF2D7D8C);
      case 'Low':
        return Color(0xFF2D7D8C);
      default:
        return Color(0xFF2D7D8C);
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
          'Tasks',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Add task functionality
            },
            child: Text(
              'Add Task',
              style: TextStyle(
                color: Color(0xFF2D7D8C),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filter Row
            Row(
              children: [
                // Status Filter Dropdown
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedFilter,
                        isExpanded: true,
                        icon: Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                        ),
                        items: filterOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedFilter = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                // Date Filter
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate =
                              '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year.toString().substring(2)}';
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectedDate,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            // Tasks List
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminTodoDetails(task: null),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.all(20),
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
                          // Priority Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: getPriorityColor(task['priority']),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              task['priority'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          // Task Name
                          Text(
                            task['name'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 16),
                          // Task Details Row
                          Row(
                            children: [
                              // Time Column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Time',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      task['time'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Due Date Column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Due Date',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      task['dueDate'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Assigned To Column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Assigned to',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: List.generate(
                                        task['assignedAvatars'],
                                        (avatarIndex) => Container(
                                          margin: EdgeInsets.only(
                                            right:
                                                avatarIndex <
                                                    task['assignedAvatars'] - 1
                                                ? 8
                                                : 0,
                                          ),
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF2D7D8C),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.person,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
