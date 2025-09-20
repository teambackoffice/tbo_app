import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/project_list_controller.dart';
import 'package:tbo_app/modal/project_list_modal.dart';
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
  final TextEditingController _projectIdController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _taskIdController = TextEditingController();
  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();
  final TextEditingController _totalHoursController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;

  // Controllers for project and task data
  GetProjectListController? _projectController;
  List<ProjectDetails> _projects = [];
  bool _isLoadingProjects = false;

  // Mock task data - Replace with actual task API when available
  final List<Map<String, String>> _tasks = [
    {'id': 'TASK-2025-00001', 'name': 'UI Development'},
    {'id': 'TASK-2025-00002', 'name': 'Backend Integration'},
    {'id': 'TASK-2025-00003', 'name': 'Testing & QA'},
    {'id': 'TASK-2025-00004', 'name': 'Bug Fixes'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();

    // Initialize project controller and load projects
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _projectController = Provider.of<GetProjectListController>(
        context,
        listen: false,
      );
      _loadProjects();
    });

    if (widget.entry != null) {
      _activityTypeController.text = widget.entry!.activityType;
      _projectNameController.text = widget.entry!.projectName;
      _projectIdController.text = widget.entry!.projectId;
      _taskController.text = widget.entry!.task;
      _taskIdController.text = widget.entry!.taskId;
      _fromTimeController.text = widget.entry!.fromTime;
      _toTimeController.text = widget.entry!.toTime;
      _totalHoursController.text = widget.entry!.totalHours;
      _descriptionController.text = widget.entry!.description;
    }
  }

  Future<void> _loadProjects() async {
    if (_projectController == null) return;

    setState(() {
      _isLoadingProjects = true;
    });

    try {
      await _projectController!.fetchprojectlist();
      if (_projectController!.projectList?.data != null) {
        setState(() {
          _projects = _projectController!.projectList!.data!;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load projects: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoadingProjects = false;
      });
    }
  }

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      _updateTimeControllers();
    }
  }

  void _selectTime(bool isFromTime) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isFromTime) {
          _fromTime = picked;
        } else {
          _toTime = picked;
        }
      });
      _updateTimeControllers();
      _calculateTotalHours();
    }
  }

  void _updateTimeControllers() {
    if (_selectedDate != null && _fromTime != null) {
      final fromDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _fromTime!.hour,
        _fromTime!.minute,
      );
      _fromTimeController.text = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(fromDateTime);
    }

    if (_selectedDate != null && _toTime != null) {
      final toDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _toTime!.hour,
        _toTime!.minute,
      );
      _toTimeController.text = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(toDateTime);
    }
  }

  void _calculateTotalHours() {
    if (_fromTime != null && _toTime != null) {
      final fromMinutes = _fromTime!.hour * 60 + _fromTime!.minute;
      final toMinutes = _toTime!.hour * 60 + _toTime!.minute;

      if (toMinutes > fromMinutes) {
        final totalMinutes = toMinutes - fromMinutes;
        final hours = totalMinutes / 60;
        setState(() {
          _totalHoursController.text = hours.toStringAsFixed(2);
        });
      }
    }
  }

  void _saveTimesheet() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _fromTime == null || _toTime == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please select date and time')));
        return;
      }

      final entry = TimesheetEntry(
        activityType: _activityTypeController.text,
        projectName: _projectNameController.text,
        projectId: _projectIdController.text,
        task: _taskController.text,
        taskId: _taskIdController.text,
        fromTime: _fromTimeController.text,
        toTime: _toTimeController.text,
        totalHours: _totalHoursController.text,
        description: _descriptionController.text,
      );

      Navigator.pop(context, entry);
    }
  }

  Widget _buildTaskDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task',
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
          child: DropdownButtonFormField<String>(
            value: _taskIdController.text.isEmpty
                ? null
                : _taskIdController.text,
            items: _tasks.map((task) {
              return DropdownMenuItem<String>(
                value: task['id'],
                child: Text(task['name']!),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                final selectedTask = _tasks.firstWhere(
                  (task) => task['id'] == value,
                );
                setState(() {
                  _taskIdController.text = selectedTask['id']!;
                  _taskController.text = selectedTask['name']!;
                });
              }
            },
            decoration: InputDecoration(
              hintText: 'Select Task',
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a task';
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
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
          child: InkWell(
            onTap: _selectDate,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                          : 'Select Date',
                      style: TextStyle(
                        fontSize: 16,
                        color: _selectedDate != null
                            ? Colors.black87
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                  Icon(Icons.calendar_today, color: Colors.grey[600]),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTimeSelector(String label, bool isFromTime) {
    final time = isFromTime ? _fromTime : _toTime;
    final controller = isFromTime ? _fromTimeController : _toTimeController;

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
          child: InkWell(
            onTap: () => _selectTime(isFromTime),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      time != null ? time.format(context) : 'Select Time',
                      style: TextStyle(
                        fontSize: 16,
                        color: time != null ? Colors.black87 : Colors.grey[500],
                      ),
                    ),
                  ),
                  Icon(Icons.access_time, color: Colors.grey[600]),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildProjectDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project',
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
          child: _isLoadingProjects
              ? Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Loading projects...'),
                    ],
                  ),
                )
              : DropdownButtonFormField<String>(
                  value: _projectIdController.text.isEmpty
                      ? null
                      : _projectIdController.text,
                  items: _projects.map((project) {
                    return DropdownMenuItem<String>(
                      value: project.name, // Using 'name' as the project ID
                      child: Text(
                        project.projectName ??
                            project.name ??
                            'Unnamed Project',
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      final selectedProject = _projects.firstWhere(
                        (project) => project.name == value,
                      );
                      setState(() {
                        _projectIdController.text = selectedProject.name ?? '';
                        _projectNameController.text =
                            selectedProject.projectName ??
                            selectedProject.name ??
                            '';
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Select Project',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a project';
                    }
                    return null;
                  },
                ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    bool isDropdown = false,
    bool isReadOnly = false,
    int maxLines = 1,
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
                    DropdownMenuItem(
                      value: "Planning",
                      child: Text("Planning"),
                    ),
                    DropdownMenuItem(
                      value: "Communication",
                      child: Text("Communication"),
                    ),
                    DropdownMenuItem(value: "Testing", child: Text("Testing")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      controller.text = value ?? '';
                    });
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
                  readOnly: isReadOnly,
                  maxLines: maxLines,
                  decoration: InputDecoration(
                    hintText: label,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  validator: maxLines == 1
                      ? (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        }
                      : null,
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
        child: Consumer<GetProjectListController>(
          builder: (context, projectController, child) {
            // Update project controller reference
            _projectController ??= projectController;

            return Column(
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
                      SizedBox(width: 16),
                      Text(
                        widget.isEdit ? 'Edit Timesheet' : 'Add Timesheet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      // Refresh button for projects
                      if (!_isLoadingProjects)
                        IconButton(
                          onPressed: _loadProjects,
                          icon: Icon(Icons.refresh, size: 20),
                          tooltip: 'Refresh Projects',
                        ),
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

                          _buildProjectDropdown(),

                          _buildTaskDropdown(),

                          _buildDateSelector(),

                          Row(
                            children: [
                              Expanded(
                                child: _buildTimeSelector('From Time', true),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _buildTimeSelector('To Time', false),
                              ),
                            ],
                          ),

                          _buildInputField(
                            'Total Hours',
                            _totalHoursController,
                            isReadOnly: true,
                          ),

                          _buildInputField(
                            'Description',
                            _descriptionController,
                            maxLines: 4,
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
                                  'Update',
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
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _activityTypeController.dispose();
    _projectNameController.dispose();
    _projectIdController.dispose();
    _taskController.dispose();
    _taskIdController.dispose();
    _fromTimeController.dispose();
    _toTimeController.dispose();
    _totalHoursController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
