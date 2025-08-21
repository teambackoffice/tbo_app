import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tbo_app/modal/task_list_modal.dart';
import 'package:tbo_app/view/employee/task_page/inprogress/request_time.dart';

class InprogressDetails extends StatelessWidget {
  final TaskDetails task;
  const InprogressDetails({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4), // light cream background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Card Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Priority Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E7C92),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        task.priority,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Title
                    const Text(
                      "#########",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Time
                    Row(
                      children: const [
                        Icon(Icons.access_time, size: 18),
                        SizedBox(width: 8),
                        Text(
                          "Start Date",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd MMM yyyy').format(task.expStartDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),

                    // Due Date
                    Row(
                      children: const [
                        Icon(Icons.calendar_today, size: 18),
                        SizedBox(width: 8),
                        Text(
                          "Due Date",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd MMM yyyy').format(task.expEndDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text(
                      task.description,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 24),

                    // Buttons
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C7690),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Mark as Completed",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF0E7C92)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RequestTimePage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Request Time",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF0E7C92),
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
      ),
    );
  }
}
