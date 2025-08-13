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
          horizontal: 30,
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
                  .spaceEvenly, // Change to spaceAround for closer spacing
              children: [
                _buildNavItem(0, 'assets/home.png', 'Dashboard', 24, 24),
                _buildNavItem(1, 'assets/task.png', 'My Task', 24, 24),
                _buildNavItem(2, 'assets/projects.png', 'Projects', 24, 24),
                _buildNavItem(3, 'assets/user.png', 'Profile', 18, 24),
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
          horizontal: 10,
        ), // Adjust horizontal padding for item spacing
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
class EmployeeBottomNavigationAlternative extends StatefulWidget {
  final int initialIndex;
  const EmployeeBottomNavigationAlternative({super.key, this.initialIndex = 0});

  @override
  State<EmployeeBottomNavigationAlternative> createState() =>
      _EmployeeBottomNavigationAlternativeState();
}

class _EmployeeBottomNavigationAlternativeState
    extends State<EmployeeBottomNavigationAlternative> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Homepage(),
    const TaskPage(),
    ProjectsPage(),
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
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.grey,
            landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ), // Reduced padding
                  child: Image.asset(
                    'assets/home.png',
                    width: 24,
                    height: 24,
                    color: _selectedIndex == 0 ? Colors.orange : Colors.grey,
                  ),
                ),
                label: "Dashboard",
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ), // Reduced padding
                  child: Image.asset(
                    'assets/task.png',
                    width: 24,
                    height: 24,
                    color: _selectedIndex == 1 ? Colors.orange : Colors.grey,
                  ),
                ),
                label: "My Task",
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ), // Reduced padding
                  child: Image.asset(
                    'assets/projects.png',
                    width: 24,
                    height: 24,
                    color: _selectedIndex == 2 ? Colors.orange : Colors.grey,
                  ),
                ),
                label: "Projects",
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ), // Reduced padding
                  child: Image.asset(
                    'assets/user.png',
                    width: 18,
                    height: 24,
                    color: _selectedIndex == 3 ? Colors.orange : Colors.grey,
                  ),
                ),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
