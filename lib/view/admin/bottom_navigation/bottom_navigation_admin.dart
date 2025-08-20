import 'package:flutter/material.dart';
import 'package:tbo_app/view/admin/dashboard/dashboard.dart';
import 'package:tbo_app/view/admin/leads/leads.dart';
import 'package:tbo_app/view/admin/profile/profile.dart';
import 'package:tbo_app/view/admin/task/task.dart';
import 'package:tbo_app/view/common/project_page/project_page.dart';

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
    CommonProjectPage(),
    const AdminLeadsPage(),
    const AdminProfile(),
  ];

  @override
  void initState() {
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ), // Adjust this value to control spacing
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // Change to spaceAround for closer spacing
              children: [
                _buildNavItem(0, 'assets/home.png', 'Dashboard', 24, 24),
                _buildNavItem(1, 'assets/task.png', 'My Task', 24, 24),
                _buildNavItem(2, 'assets/projects.png', 'Projects', 24, 24),
                _buildNavItem(3, 'assets/leads.png', 'Leads', 24, 24),
                _buildNavItem(4, 'assets/user.png', 'Profile', 18, 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    String iconPath,
    String label,
    double width,
    double height,
  ) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 6,
        ), // Reduced horizontal padding for closer items
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              width: width,
              height: height,
              color: isSelected ? Colors.orange : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11, // Slightly smaller font for 5 items
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.orange : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
