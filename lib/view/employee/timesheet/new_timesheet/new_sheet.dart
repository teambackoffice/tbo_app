import 'package:flutter/material.dart';
import 'package:tbo_app/view/employee/timesheet/new_timesheet/new_timesheet.dart';

class AddTimesheetPage extends StatefulWidget {
  final TimesheetEntry? entry;
  final bool isEdit;

  const AddTimesheetPage({super.key, this.entry, this.isEdit = false});

  @override
  _AddTimesheetPageState createState() => _AddTimesheetPageState();
}

class _AddTimesheetPageState extends State<AddTimesheetPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _activityTypeController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();
  final TextEditingController _totalHoursController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.entry != null) {
      _activityTypeController.text = widget.entry!.activityType;
      _projectNameController.text = widget.entry!.projectName;
      _taskController.text = widget.entry!.task;
      _fromTimeController.text = widget.entry!.fromTime;
      _toTimeController.text = widget.entry!.toTime;
      _totalHoursController.text = widget.entry!.totalHours;
      _descriptionController.text = widget.entry!.description;
    }
  }

  void _selectTime(TextEditingController controller) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      String formattedTime = picked.format(context);
      setState(() {
        controller.text = formattedTime;
      });
      _calculateTotalHours();
    }
  }

  void _calculateTotalHours() {
    if (_fromTimeController.text.isNotEmpty &&
        _toTimeController.text.isNotEmpty) {
      // This is a simplified calculation - you might want to implement proper time calculation
      setState(() {
        _totalHoursController.text = "2.05 Hr"; // Placeholder calculation
      });
    }
  }

  void _saveTimesheet() {
    if (_formKey.currentState!.validate()) {
      final entry = TimesheetEntry(
        activityType: _activityTypeController.text,
        projectName: _projectNameController.text,
        task: _taskController.text,
        fromTime: _fromTimeController.text,
        toTime: _toTimeController.text,
        totalHours: _totalHoursController.text,
        description: _descriptionController.text,
      );

      Navigator.pop(context, entry);
    }
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    bool isDropdown = false,
    bool isTimePicker = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF2E7D7B), width: 1),
          ),
          child: isDropdown
              ? DropdownButtonFormField<String>(
                  value: controller.text.isEmpty ? null : controller.text,
                  items: const [
                    DropdownMenuItem(
                      value: "Development",
                      child: Text("Development"),
                    ),
                    DropdownMenuItem(
                      value: "Production",
                      child: Text("Production"),
                    ),
                    DropdownMenuItem(
                      value: "Meeting with Lead",
                      child: Text("Meeting with Lead"),
                    ),
                    DropdownMenuItem(
                      value: "Meeting with Client",
                      child: Text("Meeting with Client"),
                    ),
                  ],
                  onChanged: (value) {
                    controller.text = value ?? '';
                  },
                  decoration: InputDecoration(
                    hintText: label,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                )
              : TextFormField(
                  controller: controller,
                  readOnly: isTimePicker,
                  onTap: isTimePicker ? () => _selectTime(controller) : null,
                  decoration: InputDecoration(
                    hintText: label,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    suffixIcon: isDropdown
                        ? Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey[600],
                          )
                        : isTimePicker
                        ? Icon(Icons.access_time, color: Colors.grey[600])
                        : null,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios, size: 20),
                  ),
                  Spacer(),
                ],
              ),
            ),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildInputField(
                        'Activity Type',
                        _activityTypeController,
                        isDropdown: true,
                      ),
                      _buildInputField('Project Name', _projectNameController),
                      _buildInputField('Task', _taskController),
                      _buildInputField(
                        'From Time',
                        _fromTimeController,
                        isTimePicker: true,
                      ),
                      _buildInputField(
                        'To Time',
                        _toTimeController,
                        isTimePicker: true,
                      ),
                      _buildInputField('Total Hours', _totalHoursController),

                      // Description field (larger)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFF2E7D7B),
                                width: 1,
                              ),
                            ),
                            child: TextFormField(
                              controller: _descriptionController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: 'Description',
                                hintStyle: TextStyle(color: Colors.grey[500]),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom buttons
            Padding(
              padding: EdgeInsets.all(16.0),
              child: widget.isEdit
                  ? Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveTimesheet,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2E7D7B),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(
                              'Edit Timesheet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveTimesheet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2E7D7B),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          'Add Timesheet',
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
      ),
    );
  }

  @override
  void dispose() {
    _activityTypeController.dispose();
    _projectNameController.dispose();
    _taskController.dispose();
    _fromTimeController.dispose();
    _toTimeController.dispose();
    _totalHoursController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
