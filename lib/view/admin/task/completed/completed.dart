import 'package:flutter/material.dart';
import 'package:tbo_app/view/admin/task/completed/complete_details.dart';

class AdminCompleteTaskList extends StatelessWidget {
  const AdminCompleteTaskList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tasks = [
      {
        "title": "Champion Car Wash App",
        "priority": "High",
        "time": "18 Hours",
        "dueDate": "15-07-25",
        "assignedEmployees": [
          {
            "name": "Shameer",
            "image":
                "https://media.istockphoto.com/id/1490901345/photo/happy-male-entrepreneur-at-his-office-desk-looking-at-camera.jpg?s=612x612&w=0&k=20&c=YUcA7EJpGx9CS0SEVJyU0jH6yB9GaUKAOUp98YmBzi0=",
          },
          {
            "name": "Priya",
            "image":
                "https://media.istockphoto.com/id/1489414046/photo/portrait-of-an-attractive-empowered-multiethnic-woman-looking-at-camera-and-charmingly.jpg?s=612x612&w=0&k=20&c=p9-7xtXTjNUUDYJVJmZ2pka98lr2xiFCM1jFLqpgF6Q=",
          },
        ],
      },
      {
        "title": "Onshore Website",
        "priority": "Medium",
        "time": "18 Hours",
        "dueDate": "15-07-25",
        "assignedEmployees": [
          {
            "name": "Jasir",
            "image":
                "https://media.istockphoto.com/id/1490901345/photo/happy-male-entrepreneur-at-his-office-desk-looking-at-camera.jpg?s=612x612&w=0&k=20&c=YUcA7EJpGx9CS0SEVJyU0jH6yB9GaUKAOUp98YmBzi0=",
          },
        ],
      },
      {
        "title": "Flyday Website",
        "priority": "High",
        "time": "18 Hours",
        "dueDate": "15-07-25",
        "assignedEmployees": [
          {
            "name": "Ajmal",
            "image":
                "https://media.istockphoto.com/id/1332104710/photo/shot-of-a-young-male-engineer-working-in-a-server-room.jpg?s=612x612&w=0&k=20&c=msvzP5OAQMSsq8Zh4gasPKabPYq4kWB3t9R4NoNpMZc=",
          },
          {
            "name": "Arjun",
            "image":
                "https://media.istockphoto.com/id/1332104710/photo/shot-of-a-young-male-engineer-working-in-a-server-room.jpg?s=612x612&w=0&k=20&c=msvzP5OAQMSsq8Zh4gasPKabPYq4kWB3t9R4NoNpMZc=",
          },
          {
            "name": "Maya",
            "image":
                "https://media.istockphoto.com/id/1489414046/photo/portrait-of-an-attractive-empowered-multiethnic-woman-looking-at-camera-and-charmingly.jpg?s=612x612&w=0&k=20&c=p9-7xtXTjNUUDYJVJmZ2pka98lr2xiFCM1jFLqpgF6Q=",
          },
        ],
      },
      {
        "title": "Chundakadan Website",
        "priority": "Medium",
        "time": "20 Hours",
        "dueDate": "15-07-25",
        "assignedEmployees": [
          {
            "name": "Thanha",
            "image":
                "https://media.istockphoto.com/id/1489414046/photo/portrait-of-an-attractive-empowered-multiethnic-woman-looking-at-camera-and-charmingly.jpg?s=612x612&w=0&k=20&c=p9-7xtXTjNUUDYJVJmZ2pka98lr2xiFCM1jFLqpgF6Q=",
          },
          {
            "name": "Rahul",
            "image":
                "https://media.istockphoto.com/id/1490901345/photo/happy-male-entrepreneur-at-his-office-desk-looking-at-camera.jpg?s=612x612&w=0&k=20&c=YUcA7EJpGx9CS0SEVJyU0jH6yB9GaUKAOUp98YmBzi0=",
          },
        ],
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        var task = tasks[index];
        List<Map<String, String>> employees = List<Map<String, String>>.from(
          task["assignedEmployees"],
        );

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
                        color: const Color(0xFF00AD85),
                        border: Border.all(color: Colors.green[800]!, width: 1),
                      ),
                      child: const Icon(
                        Icons.done,
                        size: 18,
                        color: Colors.white,
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

                // Time & Due Date & Assigned To labels
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
                    const SizedBox(width: 60),
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
                    const SizedBox(width: 60),
                    const Text(
                      "Assigned To",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Time & Due Date values & Employee Avatars
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Time
                    Text(
                      task["time"]!,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 60),

                    // Due Date
                    Text(
                      task["dueDate"]!,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 60),

                    // Employee Avatars
                    Expanded(child: _buildEmployeeAvatars(employees)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmployeeAvatars(List<Map<String, String>> employees) {
    const int maxVisible = 3; // Maximum number of avatars to show
    const double avatarSize = 32.0;
    const double overlapOffset = 24.0; // How much avatars overlap

    return SizedBox(
      height: avatarSize,
      child: Stack(
        children: [
          // Display visible avatars
          ...employees.take(maxVisible).map((employee) {
            int index = employees.indexOf(employee);
            return Positioned(
              left: index * overlapOffset,
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child:
                      employee["image"] != null && employee["image"]!.isNotEmpty
                      ? Image.network(
                          employee["image"]!,
                          width: avatarSize,
                          height: avatarSize,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Show first letter if image fails to load
                            return Container(
                              width: avatarSize,
                              height: avatarSize,
                              color: Colors.blue[400],
                              child: Center(
                                child: Text(
                                  employee["name"]![0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: avatarSize,
                              height: avatarSize,
                              color: Colors.grey[300],
                              child: Center(
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue[400]!,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          width: avatarSize,
                          height: avatarSize,
                          color: Colors.blue[400],
                          child: Center(
                            child: Text(
                              employee["name"]![0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            );
          }),

          // Show "+X more" indicator if there are more employees
          if (employees.length > maxVisible)
            Positioned(
              left: maxVisible * overlapOffset,
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[600],
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "+${employees.length - maxVisible}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
