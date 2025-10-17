import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/get_timesheet_controller.dart';
import 'package:tbo_app/modal/timesheet_modal.dart';
import 'package:tbo_app/view/employee/timesheet/new_timesheet/new_timesheet.dart';
import 'package:tbo_app/view/employee/timesheet/new_timesheet/view_details.dart';

class EmployeeSchedulePage extends StatefulWidget {
  const EmployeeSchedulePage({super.key});

  @override
  _EmployeeSchedulePageState createState() => _EmployeeSchedulePageState();
}

class _EmployeeSchedulePageState extends State<EmployeeSchedulePage> {
  String selectedFilter = 'All';
  DateTime? selectedDate;
  GetTimesheetController? _controller;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? _employeeId;
  bool _isLoadingEmployeeId = true;

  @override
  void initState() {
    super.initState();
    _loadEmployeeIdAndTimesheets();
  }

  Future<void> _loadEmployeeIdAndTimesheets() async {
    try {
      final employeeId = await _secureStorage.read(key: 'employee_id');

      setState(() {
        _employeeId = employeeId;
        _isLoadingEmployeeId = false;
      });

      if (mounted) {
        _loadTimesheets();
      }
    } catch (e) {
      setState(() {
        _isLoadingEmployeeId = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load employee information: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _loadTimesheets() {
    _controller = Provider.of<GetTimesheetController>(context, listen: false);
    _controller?.fetchtimesheet(employee: _employeeId);
  }

  List<Datum> get filteredEmployees {
    if (_controller?.allLeads?.data == null) return [];

    List<Datum> filtered = _controller!.allLeads!.data;

    if (selectedFilter != 'All') {
      if (selectedFilter == 'Approved') {
        filtered = filtered
            .where((emp) => emp.status.toLowerCase() == 'approved')
            .toList();
      } else if (selectedFilter == 'Rejected') {
        filtered = filtered
            .where((emp) => emp.status.toLowerCase() == 'rejected')
            .toList();
      } else if (selectedFilter == 'Send to Approval') {
        filtered = filtered
            .where(
              (emp) =>
                  emp.status.toLowerCase() == 'draft' ||
                  emp.status.toLowerCase() == 'pending',
            )
            .toList();
      }
    }

    if (selectedDate != null) {
      filtered = filtered.where((emp) {
        return emp.startDate.day == selectedDate!.day &&
            emp.startDate.month == selectedDate!.month &&
            emp.startDate.year == selectedDate!.year;
      }).toList();
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

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'draft':
      case 'pending':
        return 'Send to Approval';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'draft':
      case 'pending':
        return Color(0xFFF3F3F3);
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  void _navigateToCreateTimesheet() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateNewTimesheet()),
    );
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
      body: Consumer<GetTimesheetController>(
        builder: (context, controller, child) {
          _controller = controller;

          if (_isLoadingEmployeeId) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 16),
                  Text(
                    'Loading employee information...',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            );
          }

          if (_employeeId == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off_outlined,
                    size: 64,
                    color: Colors.orange[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Employee information not found',
                    style: TextStyle(
                      color: Colors.orange[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Please login again to continue',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Back to Login'),
                  ),
                ],
              ),
            );
          }

          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator(color: Colors.teal));
          }

          // Check if there's no data (status 204 or empty response)
          bool hasNoTimesheets =
              controller.allLeads == null ||
              controller.allLeads?.data == null ||
              controller.allLeads!.data.isEmpty;

          // Show error only if it's not a 204 status or empty response
          if (controller.error != null && !hasNoTimesheets) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                  SizedBox(height: 16),
                  Text(
                    'Error loading timesheets',
                    style: TextStyle(
                      color: Colors.red[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    controller.error!,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadTimesheets,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // If no timesheets exist, show empty state with create button
          if (hasNoTimesheets) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'No timesheets yet',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Create your first timesheet to get started',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _navigateToCreateTimesheet,
                    icon: Icon(Icons.add, size: 20),
                    label: Text(
                      'Create Timesheet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1C7690),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 2,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
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
                        Icon(
                          Icons.calendar_today,
                          color: Colors.teal,
                          size: 20,
                        ),
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
                              cursor: SystemMouseCursors.click,
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
                        Spacer(),
                        Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFF1C7690),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton.icon(
                            onPressed: _navigateToCreateTimesheet,
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16,
                            ),
                            label: Text(
                              'New',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
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
                        itemCount: filteredEmployees.length,
                        itemBuilder: (context, index) {
                          return _buildEmployeeCard(filteredEmployees[index]);
                        },
                      ),
              ),
            ],
          );
        },
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

  Widget _buildEmployeeCard(Datum employee) {
    Color statusColor = _getStatusColor(employee.status);
    String statusText = _getStatusText(employee.status);

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
                        employee.employeeName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        employee.employee,
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
                      color:
                          employee.status.toLowerCase() == 'pending' ||
                              employee.status.toLowerCase() == 'draft'
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
                        _formatDate(employee.startDate),
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
                        '${employee.totalHours.toStringAsFixed(2)} Hrs',
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
                      MaterialPageRoute(
                        builder: (context) =>
                            ViewDetails(timesheetData: employee),
                      ),
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
