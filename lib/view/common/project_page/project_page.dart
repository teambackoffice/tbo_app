import 'package:flutter/material.dart';
import 'package:tbo_app/view/common/project_page/project_details.dart';

class CommonProjectPage extends StatefulWidget {
  const CommonProjectPage({super.key});

  @override
  _CommonProjectPageState createState() => _CommonProjectPageState();
}

class _CommonProjectPageState extends State<CommonProjectPage> {
  String selectedFilter = 'All';
  String selectedDate = '';

  @override
  void initState() {
    super.initState();
    // Set today's date when the page loads
    final now = DateTime.now();
    selectedDate =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year.toString().substring(2)}';
  }

  final List<String> filterOptions = ['All', 'Open', 'Progress', 'Completed'];

  final List<Map<String, dynamic>> projects = [
    {
      'planningName': 'Project Planning Name',
      'projectName': 'Onshore Website',
      'projectType': 'Internal',
      'status': 'Open',
    },
    {
      'planningName': 'Project Planning Name',
      'projectName': 'Onshore Website',
      'projectType': 'Internal',
      'status': 'Progress',
    },
    {
      'planningName': 'Project Planning Name',
      'projectName': 'Onshore Website',
      'projectType': 'Internal',
      'status': 'Completed',
    },
    {
      'planningName': 'Project Planning Name',
      'projectName': 'Onshore Website',
      'projectType': 'Exetrnal',
      'status': 'Open',
    },
    {
      'planningName': 'Project Planning Name',
      'projectName': 'Onshore Website',
      'projectType': 'Internal',
      'status': 'Open',
    },
    {
      'planningName': 'Project Planning Name',
      'projectName': 'Onshore Website',
      'projectType': 'Internal',
      'status': 'Open',
    },
    {
      'planningName': 'Project Planning Name',
      'projectName': 'Onshore Website',
      'projectType': 'Internal',
      'status': 'Open',
    },
    {
      'planningName': 'Project Planning Name',
      'projectName': 'Onshore Website',
      'projectType': 'Internal',
      'status': 'Open',
    },
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return Color(0xFF129476);
      case 'Progress':
        return Color(0xFF007BFF);
      case 'Completed':
        return Colors.green;
      default:
        return Color(0xFF28A745);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Text(
            'Projects',
            style: TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Filter Row
            Row(
              children: [
                // Status Filter Dropdown
                Expanded(
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedFilter,
                        isExpanded: true,
                        icon: Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey.shade600,
                            size: 24,
                          ),
                        ),
                        items: filterOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedFilter = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                // Date Filter
                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(0xFF28A745),
                                onPrimary: Colors.white,
                                onSurface: Colors.black,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate =
                              '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year.toString().substring(2)}';
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(26),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectedDate,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 20,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            // Projects List
            Expanded(
              child: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectDetailsPage(),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Project Planning Name Label
                                    Text(
                                      project['planningName'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    // Project Name
                                    Text(
                                      project['projectName'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    // Project Type Label
                                    Text(
                                      'Project Type',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    // Project Type Value
                                    Text(
                                      project['projectType'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Status Badge
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: getStatusColor(project['status']),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  project['status'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
