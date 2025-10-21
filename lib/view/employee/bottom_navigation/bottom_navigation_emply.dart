import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbo_app/view/employee/dashboard/homepage.dart';
import 'package:tbo_app/view/employee/profile/profile.dart';
import 'package:tbo_app/view/employee/task_page/task_page.dart';
import 'package:tbo_app/view/employee/timesheet/timesheet.dart';

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
    TasksPage(),
    EmployeeSchedulePage(),
    const ProfilePage(),
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
        height: 70.h, // responsive height
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.r,
              offset: Offset(0, -2.h),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, 'assets/home.png', 'Dashboard', 24.w, 24.h),
            _buildNavItem(1, 'assets/task.png', 'My Task', 24.w, 24.h),
            _buildNavItem(2, 'assets/cloak_icon.png', 'Timesheet', 24.w, 24.h),
            _buildNavItem(3, 'assets/user.png', 'Profile', 18.w, 24.h),
          ],
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

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              width: width.w, // responsive width
              height: height.h, // responsive height
              color: isSelected ? Colors.orange : Colors.grey,
            ),
            SizedBox(height: 4.h), // responsive spacing
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp, // responsive font
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
