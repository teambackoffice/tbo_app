import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbo_app/view/crm/all_leads/crm_all_leads.dart';
import 'package:tbo_app/view/crm/dashboard/crm_dashboard.dart';
import 'package:tbo_app/view/crm/profile/crm_profile.dart';

class CRMBottomNavigation extends StatefulWidget {
  final int initialIndex;
  const CRMBottomNavigation({super.key, this.initialIndex = 0});

  @override
  State<CRMBottomNavigation> createState() => _CRMBottomNavigationState();
}

class _CRMBottomNavigationState extends State<CRMBottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const CRMDashboardPage(),
    const CRMAllLeadsPage(),
    const CRMProfilePage(),
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
            _buildNavItem(0, 'assets/home.png', 'Dashboard'),
            _buildNavItem(1, 'assets/task.png', 'All Leads'),
            _buildNavItem(2, 'assets/user.png', 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    bool isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              width: index == 2 ? 18.w : 24.w, // responsive width
              height: 24.h, // responsive height
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
