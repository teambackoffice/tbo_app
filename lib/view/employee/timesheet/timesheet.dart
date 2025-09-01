import 'package:flutter/material.dart';
import 'package:tbo_app/view/employee/timesheet/new_timesheet/new_timesheet.dart';
import 'package:tbo_app/view/employee/timesheet/new_timesheet/view_details.dart';

class EmployeeSchedulePage extends StatefulWidget {
  const EmployeeSchedulePage({super.key});

  @override
  _EmployeeSchedulePageState createState() => _EmployeeSchedulePageState();
}

class _EmployeeSchedulePageState extends State<EmployeeSchedulePage> {
  String selectedFilter =
      'All'; // Current filter: All, Approved, Rejected, Send to Approval
  DateTime? selectedDate; // Selected date filter

  // All employee data - one timesheet per day per employee
  List<EmployeeData> allEmployees = [
    EmployeeData('John Smith', 'T12244649', '26-08-2025', '8:00', 'approved'),
    EmployeeData('John Smith', 'T12244650', '27-08-2025', '9:00', 'pending'),
    EmployeeData('John Smith', 'T12244651', '28-08-2025', '7:30', 'rejected'),
    EmployeeData('John Smith', 'T12244652', '29-08-2025', '8:30', 'approved'),
    EmployeeData('John Smith', 'T12244653', '30-08-2025', '9:15', 'pending'),
    EmployeeData('John Smith', 'T12244654', '31-08-2025', '8:00', 'approved'),
    EmployeeData('John Smith', 'T12244655', '01-09-2025', '7:45', 'rejected'),
    EmployeeData('John Smith', 'T12244656', '02-09-2025', '8:15', 'pending'),
    EmployeeData('Steve Rogers', 'T12244657', '26-08-2025', '9:00', 'approved'),
    EmployeeData('Steve Rogers', 'T12244658', '27-08-2025', '8:30', 'pending'),
    EmployeeData('Steve Rogers', 'T12244659', '28-08-2025', '7:30', 'rejected'),
    EmployeeData('Steve Rogers', 'T12244660', '29-08-2025', '7:00', 'approved'),
    EmployeeData('Steve Rogers', 'T12244661', '30-08-2025', '8:45', 'pending'),
    EmployeeData('Tony Stark', 'T12244662', '26-08-2025', '9:15', 'approved'),
    EmployeeData('Tony Stark', 'T12244663', '27-08-2025', '7:15', 'rejected'),
    EmployeeData('Tony Stark', 'T12244664', '28-08-2025', '8:00', 'pending'),
    EmployeeData('Tony Stark', 'T12244665', '29-08-2025', '9:30', 'approved'),
    EmployeeData('Bruce Banner', 'T12244666', '26-08-2025', '8:15', 'pending'),
    EmployeeData('Bruce Banner', 'T12244667', '27-08-2025', '7:45', 'approved'),
    EmployeeData('Bruce Banner', 'T12244668', '28-08-2025', '9:00', 'rejected'),
  ];

  // Get filtered employees based on selected filter and date
  List<EmployeeData> get filteredEmployees {
    List<EmployeeData> filtered = allEmployees;

    // Filter by status
    if (selectedFilter != 'All') {
      if (selectedFilter == 'Approved') {
        filtered = filtered.where((emp) => emp.status == 'approved').toList();
      } else if (selectedFilter == 'Rejected') {
        filtered = filtered.where((emp) => emp.status == 'rejected').toList();
      } else if (selectedFilter == 'Send to Approval') {
        filtered = filtered.where((emp) => emp.status == 'pending').toList();
      }
    }

    // Filter by date if selected
    if (selectedDate != null) {
      String formattedDate =
          '${selectedDate!.day.toString().padLeft(2, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.year}';
      filtered = filtered.where((emp) => emp.date == formattedDate).toList();
    }

    return filtered;
  }

  String get dateFilterText {
    if (selectedDate == null) {
      return 'All Dates';
    }
    return '${selectedDate!.day.toString().padLeft(2, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _clearDateFilter() {
    setState(() {
      selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Timesheet',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filters Section
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Filter Row
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.teal, size: 20),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.teal),
                          borderRadius: BorderRadius.circular(20),
                          color: selectedDate != null
                              ? Colors.teal.withOpacity(0.1)
                              : Colors.transparent,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              dateFilterText,
                              style: TextStyle(
                                color: Colors.teal,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.teal,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (selectedDate != null) ...[
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: _clearDateFilter,
                        child: MouseRegion(
                          cursor: SystemMouseCursors
                              .click, // 👈 shows pointer on hover (web/desktop)
                          child: Text(
                            "Clear",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                    Spacer(), // Push New button to the right
                    Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFF1C7690),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateNewTimesheet(),
                            ),
                          );
                        },
                        icon: Icon(Icons.add, color: Colors.white, size: 16),
                        label: Text(
                          'New',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Status Filter Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFilterChip('All'),
                    _buildFilterChip('Approved'),
                    _buildFilterChip('Rejected'),
                    _buildFilterChip('Send to Approval'),
                  ],
                ),
              ],
            ),
          ),

          // Results count
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Text(
                  '${filteredEmployees.length} timesheets found',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Employee List
          Expanded(
            child: filteredEmployees.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No timesheets found',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    itemCount: filteredEmployees.length + 1,
                    itemBuilder: (context, index) {
                      if (index < filteredEmployees.length) {
                        return _buildEmployeeCard(filteredEmployees[index]);
                      } else {
                        // Pagination at the end of the list
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Showing 1-${filteredEmployees.length}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 20),
                              Icon(Icons.chevron_left, color: Colors.grey[400]),
                              SizedBox(width: 10),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.grey[400],
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    bool isSelected = selectedFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = filter;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.teal : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          filter,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(EmployeeData employee) {
    Color statusColor;
    String statusText;

    switch (employee.status) {
      case 'approved':
        statusColor = Colors.green;
        statusText = 'Approved';
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = 'Rejected';
        break;
      case 'pending':
        statusColor = Color(0xFFF3F3F3);
        statusText = 'Send to Approval';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        employee.id,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: employee.status == 'pending'
                          ? Colors.black
                          : Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: TextStyle(color: Colors.grey[500], fontSize: 11),
                      ),
                      SizedBox(height: 4),
                      Text(
                        employee.date,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hours Worked',
                        style: TextStyle(color: Colors.grey[500], fontSize: 11),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${employee.startTime}Hrs',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewDetails()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFF1C7690),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'View Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Employee Data Model
class EmployeeData {
  final String name;
  final String id;
  final String date;
  final String startTime;
  final String status; // 'approved', 'rejected', 'pending'

  EmployeeData(this.name, this.id, this.date, this.startTime, this.status);
}
