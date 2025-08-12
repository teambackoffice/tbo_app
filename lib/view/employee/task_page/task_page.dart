import 'package:flutter/material.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // light gray background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Tasks",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // TabBar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0xFF1C7690), // Selected tab fill
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: const Color(0xFF1C7690), width: 1),
                ),
                indicatorPadding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 8,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFF1C7690),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: [
                  _buildTab(Icons.access_time, "To Do"),
                  _buildTab(Icons.incomplete_circle, "In Progress"),
                  _buildTab(Icons.check_circle, "Completed"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // TabBarView
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTaskList(),
                  _buildTaskList(),
                  _buildTaskList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(IconData icon, String text) {
    return Tab(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF1C7690), width: 1),
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14),
            const SizedBox(width: 6),
            Text(text, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    List<Map<String, String>> tasks = [
      {
        "title": "Champion Car Wash App",
        "priority": "High",
        "time": "18 Hours",
        "dueDate": "15-07-25",
      },
      {
        "title": "Onshore Website",
        "priority": "Medium",
        "time": "18 Hours",
        "dueDate": "15-07-25",
      },
      {
        "title": "Flyday Website",
        "priority": "High",
        "time": "18 Hours",
        "dueDate": "15-07-25",
      },
      {
        "title": "Chundakadan Website",
        "priority": "Medium",
        "time": "20 Hours",
        "dueDate": "15-07-25",
      },
    ];

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
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C7690), // dark blue for priority
                  borderRadius: BorderRadius.circular(6),
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
              const SizedBox(height: 12),

              // Task title and arrow
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

              // Time & Due Date
              Row(
                children: [
                  // Time section
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
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(width: 60),
                  // Due Date section
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "Due Date",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
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
                    task["time"]!,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    width: 60,
                  ), // Adjusted spacing to align with labels
                  Text(
                    task["dueDate"]!,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),

                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey[300]!, // border color
                        width: 1, // border width
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_outward,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
