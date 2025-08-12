import 'package:flutter/material.dart';
import 'package:tbo_app/view/employee/dashboard/homepage.dart';
import 'package:tbo_app/view/employee/profile/profile.dart';
import 'package:tbo_app/view/employee/projects/projects.dart';
import 'package:tbo_app/view/employee/task_page/task_page.dart';

class EmployeeBottomNavigation extends StatefulWidget {
  final int initialIndex;
  const EmployeeBottomNavigation({super.key, this.initialIndex = 0});

  @override
  State<EmployeeBottomNavigation> createState() =>
      _EmployeeBottomNavigationState();
}

class _EmployeeBottomNavigationState extends State<EmployeeBottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Homepage(),
    const TaskPage(),
    ProjectsPage(),
    const ProfilePage(),
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
              'assets/user.png',
              width: 18,
              height: 24,
              color: _selectedIndex == 3 ? Colors.orange : Colors.grey,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
