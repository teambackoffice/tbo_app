import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
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
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // Change to spaceAround for even closer spacing
              children: [
                _buildNavItem(0, 'assets/home.png', 'Dashboard'),
                _buildNavItem(1, 'assets/task.png', 'All Leads'),
                _buildNavItem(2, 'assets/user.png', 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              width: index == 2
                  ? 18
                  : 24, // Keep the original sizing for profile icon
              height: 24,
              color: isSelected ? Colors.orange : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
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

// Alternative approach - using the original BottomNavigationBar with reduced padding
