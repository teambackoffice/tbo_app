import 'package:flutter/material.dart';
import 'package:tbo_app/view/admin/task/completed/complete_details.dart';

class AdminCompleteTaskList extends StatelessWidget {
  const AdminCompleteTaskList({super.key});

  @override
  Widget build(BuildContext context) {
    // Local task list (inside the widget)
    final List<Map<String, String>> tasks = [
      {
        "title": "Champion Car Wash App",
        "priority": "High",
        "time": "18 Hours",
        "dueDate": "15-07-25",
        "assignedTo": "Shameer",
      },
      {
        "title": "Onshore Website",
        "priority": "Medium",
        "time": "18 Hours",
        "dueDate": "15-07-25",
        "assignedTo": "Jasir",
      },
      {
        "title": "Flyday Website",
        "priority": "High",
        "time": "18 Hours",
        "dueDate": "15-07-25",
        "assignedTo": "Ajmal",
      },
      {
        "title": "Chundakadan Website",
        "priority": "Medium",
        "time": "20 Hours",
        "dueDate": "15-07-25",
        "assignedTo": "Thanha",
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        var task = tasks[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminCompleteDetails()),
            );
          },
          child: Container(
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
                Row(
                  children: [
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
                        task["priority"]!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF00AD85), // ✅ Inside fill color
                        border: Border.all(color: Colors.green[800]!, width: 1),
                      ),
                      child: const Icon(
                        Icons.done,
                        size: 18,
                        color: Colors
                            .white, // Icon color contrasts with background
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Task title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        task["title"]!,
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
                    const Icon(
                      Icons.access_time_outlined,
                      size: 16,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "Time",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    SizedBox(width: 60),
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "Due Date",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    SizedBox(width: 60),
                    const Text(
                      "Assigned To",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Time & Due Date values
                Row(
                  children: [
                    Text(
                      task["time"]!,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 60),
                    Text(
                      task["dueDate"]!,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 60),
                    Text(
                      task["assignedTo"]!,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
