import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbo_app/view/admin/dashboard/dashboard.dart';
import 'package:tbo_app/view/admin/leads/leads.dart';
import 'package:tbo_app/view/admin/profile/profile.dart';
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
    CommonProjectPage(),
    AdminLeadsPage(),
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
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 60.h, // responsive height if using ScreenUtil
          padding: EdgeInsets.symmetric(horizontal: 20.w),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(0, 'assets/home.png', 'Dashboard', 24.w, 24.h),
              _buildNavItem(1, 'assets/projects.png', 'Projects', 24.w, 24.h),
              _buildNavItem(2, 'assets/leads.png', 'Leads', 24.w, 24.h),
              _buildNavItem(3, 'assets/user.png', 'Profile', 18.w, 24.h),
            ],
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
