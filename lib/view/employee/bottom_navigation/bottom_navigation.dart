import 'package:flutter/material.dart';
import 'package:tbo_app/view/employee/mainscreen/homepage.dart';
import 'package:tbo_app/view/employee/profile/profile.dart';
import 'package:tbo_app/view/employee/projects/projects.dart';
import 'package:tbo_app/view/employee/task_page/task_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Homepage(),
    const TaskPage(),
    const ProjectsPage(),
    const ProfilePage(),
  ];

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
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "My Task",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: "Projects",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_sharp),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}