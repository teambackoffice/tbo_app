import 'package:flutter/material.dart';
import 'package:tbo_app/view/admin/dashboard/dashboard.dart';
import 'package:tbo_app/view/admin/leads/leads.dart';
import 'package:tbo_app/view/admin/profile/profile.dart';
import 'package:tbo_app/view/admin/project/project.dart';
import 'package:tbo_app/view/admin/task/task.dart';

class AdminBottomNavigation extends StatefulWidget {
  final int initialIndex;
  const AdminBottomNavigation({super.key, this.initialIndex = 0});

  @override
  State<AdminBottomNavigation> createState() => _AdminBottomNavigationState();
}

class _AdminBottomNavigationState extends State<AdminBottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AdminDashboard(),
    const AdminTaskPage(),
    AdminProjects(),
    const AdminLeads(),
    const AdminProfile(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/home.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 0 ? Colors.orange : Colors.grey,
            ),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/task.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 1 ? Colors.orange : Colors.grey,
            ),
            label: "My Task",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/projects.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 2 ? Colors.orange : Colors.grey,
            ),
            label: "Projects",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/leads.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 3 ? Colors.orange : Colors.grey,
            ),
            label: "leads",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/user.png',
              width: 18,
              height: 24,
              color: _selectedIndex == 4 ? Colors.orange : Colors.grey,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
