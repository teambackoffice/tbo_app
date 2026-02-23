import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/create_timesheet_controller.dart';
import 'package:tbo_app/controller/get_timesheet_controller.dart';
import 'package:tbo_app/view/employee/timesheet/new_timesheet/new_sheet.dart';

class TimesheetEntry {
  String activityType;
  String projectName;
  String projectId; // Add project ID
  String task;
  String taskId; // Add task ID
  String fromTime;
  String toTime;
  String totalHours;
  String description;

  TimesheetEntry({
    required this.activityType,
    required this.projectName,
    required this.projectId,
    required this.task,
    required this.taskId,
    required this.fromTime,
    required this.toTime,
    required this.totalHours,
    required this.description,
  });

  // Convert to API format
  Map<String, dynamic> toApiFormat() {
    return {
      "activity_type": activityType,
      "from_time": fromTime,
      "to_time": toTime,
      "hours": double.tryParse(totalHours) ?? 0.0,
      "project": projectId,
      "task": taskId,
      "description": description,
    };
  }
}

class CreateNewTimesheet extends StatefulWidget {
  const CreateNewTimesheet({super.key});

  @override
  _CreateNewTimesheetState createState() => _CreateNewTimesheetState();
}

class _CreateNewTimesheetState extends State<CreateNewTimesheet> {
  List<TimesheetEntry> entries = [];
  List<bool> expandedStates = [];

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String? _employeeId;
  String? _sid;
  bool _isLoadingEmployeeData = true;

  @override
  void initState() {
    super.initState();
    _loadEmployeeData();
  }

  Future<void> _loadEmployeeData() async {
    try {
      _employeeId = await _secureStorage.read(key: 'employee_original_id');
      _sid = await _secureStorage.read(key: 'sid');

      if (_employeeId == null || _sid == null) {
        _showError('Employee data not found. Please login again.');
      }
    } catch (e) {
      _showError('Failed to load employee data: $e');
    } finally {
      setState(() {
        _isLoadingEmployeeData = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _addNewEntry() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTimesheetPage()),
    );

    if (result != null) {
      setState(() {
        entries.add(result);
        expandedStates.add(false);
      });
    }
  }

  void _editEntry(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddTimesheetPage(entry: entries[index], isEdit: true),
      ),
    );

    if (result != null) {
      setState(() {
        entries[index] = result;
      });
    }
  }

  void _deleteEntry(int index) {
    setState(() {
      entries.removeAt(index);
      expandedStates.removeAt(index);
    });
  }

  void _toggleExpansion(int index) {
    setState(() {
      expandedStates[index] = !expandedStates[index];
    });
  }

  Future<void> _saveTimesheet() async {
    if (_employeeId == null || _sid == null) {
      _showError('Employee data not available. Please login again.');
      return;
    }

    if (entries.isEmpty) {
      _showError('Please add at least one timesheet entry.');
      return;
    }

    // Calculate start and end dates from entries
    final sortedEntries = entries.toList()
      ..sort((a, b) => a.fromTime.compareTo(b.fromTime));

    final startDate = sortedEntries.first.fromTime;
    final endDate = sortedEntries.last.toTime;

    // Convert entries to API format
    final timeLogs = entries.map((entry) => entry.toApiFormat()).toList();

    try {
      final controller = Provider.of<CreateTimesheetController>(
        context,
        listen: false,
      );

      await controller.createTimesheet(
        sid: _sid!,
        employee: _employeeId!,
        startDate: startDate,
        endDate: endDate,
        timeLogs: timeLogs,
      );

      if (controller.errorMessage != null) {
        _showError('Failed to save timesheet: ${controller.errorMessage}');
      } else {
        _showSuccess('Timesheet saved successfully!');
        // Navigate back and signal the timesheet list to reload
        Navigator.pop(context);
        context.read<GetTimesheetController>().fetchtimesheet(
          employee: _employeeId,
        );
      }
    } catch (e) {
      _showError('An error occurred: $e');
    }
  }

  Widget _buildAddRowButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextButton(
        onPressed: _addNewEntry,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child: Text(
          'Add Row',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            height: 200,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Are You Sure to Delete \nTimesheet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black26),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'No',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _deleteEntry(index);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingEmployeeData) {
      return Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Consumer<CreateTimesheetController>(
          builder: (context, controller, child) {
            return Stack(
              children: [
                Column(
                  children: [
                    // Header section
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: Colors.black87,
                            ),
                          ),
                          Spacer(),
                          if (entries.isNotEmpty) _buildAddRowButton(),
                        ],
                      ),
                    ),
                    // List of entries or empty state
                    Expanded(
                      child: entries.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'No timesheet has been added yet',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  _buildAddRowButton(),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              itemCount: entries.length,
                              itemBuilder: (context, index) {
                                final entry = entries[index];
                                final isExpanded = expandedStates[index];

                                return Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Always visible header section
                                      Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  entry.activityType,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () =>
                                                      _toggleExpansion(index),
                                                  child: Icon(
                                                    isExpanded
                                                        ? Icons
                                                              .keyboard_arrow_up
                                                        : Icons
                                                              .keyboard_arrow_down,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              entry.projectName,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            SizedBox(height: 12),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'From time',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                      Text(
                                                        DateFormat(
                                                          'dd-MM-yy, hh:mm a',
                                                        ).format(
                                                          DateTime.parse(
                                                            entry.fromTime,
                                                          ),
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'To Time',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                      Text(
                                                        DateFormat(
                                                          'dd-MM-yy, hh:mm a',
                                                        ).format(
                                                          DateTime.parse(
                                                            entry.toTime,
                                                          ),
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Total Working Hour',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              entry.totalHours,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Expandable section
                                      if (isExpanded) ...[
                                        Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Task Name
                                              Text(
                                                'Task Name',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              Text(
                                                entry.task,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),

                                              // Description (only shown in expanded view)
                                              if (entry
                                                  .description
                                                  .isNotEmpty) ...[
                                                SizedBox(height: 12),
                                                Text(
                                                  'Description',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                Text(
                                                  entry.description,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],

                                              SizedBox(height: 12),

                                              // Edit and Delete buttons
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () =>
                                                        _editEntry(index),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.edit_outlined,
                                                          size: 18,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          'Edit',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 20),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        _showDeleteConfirmationDialog(
                                                          index,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.delete,
                                                          size: 18,
                                                          color:
                                                              Colors.red[400],
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.red[400],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),

                    // Save button (only show when there are entries)
                    if (entries.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.isLoading
                                ? null
                                : _saveTimesheet,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2E7D7B),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: controller.isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                  ],
                ),

                // Loading overlay
                if (controller.isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
