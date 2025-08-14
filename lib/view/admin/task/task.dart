import 'package:flutter/material.dart';
import 'package:tbo_app/view/admin/task/completed/completed.dart';
import 'package:tbo_app/view/admin/task/inprogress/inprogress.dart';
import 'package:tbo_app/view/admin/task/todo/todo.dart';

class AdminTaskPage extends StatefulWidget {
  const AdminTaskPage({super.key});

  @override
  State<AdminTaskPage> createState() => _AdminTaskPageState();
}

class _AdminTaskPageState extends State<AdminTaskPage>
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
      backgroundColor: const Color(0xFFF9F7F3), // light gray background
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
                  _buildTab(Icons.access_time, "Open"),
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
                  AdminToDoTaskList(),
                  AdminInProgressTaskList(),
                  AdminCompleteTaskList(),
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
}
