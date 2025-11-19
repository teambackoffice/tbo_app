import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/employee_task_list_controller.dart';
import 'package:tbo_app/controller/project_list_controller.dart';
import 'package:tbo_app/modal/employee_task_list_modal.dart';
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
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskIdController = TextEditingController();
  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();
  final TextEditingController _totalHoursController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;

  GetProjectListController? _projectController;
  TaskByEmployeeController? _taskController;
  List<ProjectDetails> _projects = [];
  List<Task> _tasks = [];
  bool _isLoadingProjects = false;
  bool _isLoadingTasks = false;

  final List<String> _activityTypes = [
    "Development",
    "Production",
    "Meeting with Lead",
    "Meeting with Client",
    "Planning",
    "Communication",
    "Testing",
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _projectController = Provider.of<GetProjectListController>(
        context,
        listen: false,
      );
      _taskController = Provider.of<TaskByEmployeeController>(
        context,
        listen: false,
      );
      _loadProjects();
      _loadTasks();
    });

    if (widget.entry != null) {
      _activityTypeController.text = widget.entry!.activityType;
      _projectNameController.text = widget.entry!.projectName;
      _projectIdController.text = widget.entry!.projectId;
      _taskNameController.text = widget.entry!.task;
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
      await _projectController!.fetchprojectlist(status: 'Open');
      if (_projectController!.projectList?.data != null) {
        setState(() {
          _projects = _projectController!.projectList!.data!;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load projects: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingProjects = false;
        });
      }
    }
  }

  Future<void> _loadTasks() async {
    if (_taskController == null) return;

    setState(() {
      _isLoadingTasks = true;
    });

    try {
      await _taskController!.fetchTasks();

      // Check if the response is successful and has data
      if (_taskController!.taskListResponse != null &&
          _taskController!.taskListResponse!.success) {
        setState(() {
          _tasks = _taskController!.taskListResponse!.data;
        });

        print('Tasks loaded successfully: ${_tasks.length} tasks');
      } else {
        // Handle error from API
        final errorMsg =
            _taskController!.errorMessage ??
            _taskController!.taskListResponse?.message ??
            'Unknown error';

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load tasks: $errorMsg'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      print('Error loading tasks: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load tasks: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingTasks = false;
        });
      }
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
    // Validate all required fields
    bool hasErrors = false;

    if (_activityTypeController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select an activity type')));
      hasErrors = true;
    }

    if (_projectIdController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select a project')));
      hasErrors = true;
    }

    if (_taskIdController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select a task')));
      hasErrors = true;
    }

    if (_selectedDate == null || _fromTime == null || _toTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select date and time')));
      hasErrors = true;
    }

    if (hasErrors) return;

    if (_formKey.currentState!.validate()) {
      final entry = TimesheetEntry(
        activityType: _activityTypeController.text,
        projectName: _projectNameController.text,
        projectId: _projectIdController.text,
        task: _taskNameController.text,
        taskId: _taskIdController.text,
        fromTime: _fromTimeController.text,
        toTime: _toTimeController.text,
        totalHours: _totalHoursController.text,
        description: _descriptionController.text,
      );

      Navigator.pop(context, entry);
    }
  }

  // Searchable Activity Type Dialog
  Future<void> _showActivityTypeSearch() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => _SearchableDialog(
        title: 'Select Activity Type',
        items: _activityTypes,
        displayText: (item) => item,
        currentValue: _activityTypeController.text,
      ),
    );

    if (selected != null) {
      setState(() {
        _activityTypeController.text = selected;
      });
    }
  }

  // Searchable Project Dialog
  Future<void> _showProjectSearch() async {
    if (_isLoadingProjects) return;

    if (_projects.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No projects available')));
      return;
    }

    final selected = await showDialog<ProjectDetails>(
      context: context,
      builder: (context) => _SearchableDialog<ProjectDetails>(
        title: 'Select Project',
        items: _projects,
        displayText: (project) =>
            project.projectName ?? project.name ?? 'Unnamed Project',
        currentValue: _projectIdController.text,
        compareValue: (project) => project.name ?? '',
      ),
    );

    if (selected != null) {
      setState(() {
        _projectIdController.text = selected.name ?? '';
        _projectNameController.text =
            selected.projectName ?? selected.name ?? '';
      });
    }
  }

  // Searchable Task Dialog
  Future<void> _showTaskSearch() async {
    if (_isLoadingTasks) return;

    if (_tasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No tasks available. Tasks are loaded based on your assignments.',
          ),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    final selected = await showDialog<Task>(
      context: context,
      builder: (context) => _SearchableDialog<Task>(
        title: 'Select Task',
        items: _tasks,
        displayText: (task) => task.subject,
        currentValue: _taskIdController.text,
        compareValue: (task) => task.name,
      ),
    );

    if (selected != null) {
      setState(() {
        _taskIdController.text = selected.name;
        _taskNameController.text = selected.subject;
      });
    }
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

  Widget _buildSearchableField(
    String label,
    TextEditingController controller,
    VoidCallback onTap,
    bool isLoading, {
    bool showError = false,
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
            border: Border.all(
              color: showError && controller.text.isEmpty
                  ? Colors.red
                  : Color(0xFF2E7D7B),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: isLoading ? null : onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.text.isEmpty
                          ? 'Select $label'
                          : controller.text,
                      style: TextStyle(
                        fontSize: 16,
                        color: controller.text.isEmpty
                            ? Colors.grey[500]
                            : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isLoading)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Icon(Icons.search, color: Colors.grey[600]),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
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
          child: TextFormField(
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
        child: Consumer2<GetProjectListController, TaskByEmployeeController>(
          builder: (context, projectController, taskController, child) {
            _projectController ??= projectController;
            _taskController ??= taskController;

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.arrow_back_ios, size: 20),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          widget.isEdit ? 'Edit Timesheet' : 'Add Timesheet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // Refresh button for tasks
                      IconButton(
                        icon: Icon(Icons.refresh, color: Color(0xFF2E7D7B)),
                        onPressed: _isLoadingTasks ? null : _loadTasks,
                        tooltip: 'Refresh Tasks',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildSearchableField(
                            'Activity Type',
                            _activityTypeController,
                            _showActivityTypeSearch,
                            false,
                          ),
                          _buildSearchableField(
                            'Project',
                            _projectNameController,
                            _showProjectSearch,
                            _isLoadingProjects,
                          ),
                          _buildSearchableField(
                            'Task',
                            _taskNameController,
                            _showTaskSearch,
                            _isLoadingTasks,
                          ),
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
    _taskNameController.dispose();
    _taskIdController.dispose();
    _fromTimeController.dispose();
    _toTimeController.dispose();
    _totalHoursController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

// Searchable Dialog Widget
class _SearchableDialog<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String Function(T) displayText;
  final String currentValue;
  final String Function(T)? compareValue;

  const _SearchableDialog({
    required this.title,
    required this.items,
    required this.displayText,
    required this.currentValue,
    this.compareValue,
  });

  @override
  State<_SearchableDialog<T>> createState() => _SearchableDialogState<T>();
}

class _SearchableDialogState<T> extends State<_SearchableDialog<T>> {
  final TextEditingController _searchController = TextEditingController();
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(_filterItems);
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = widget.items.where((item) {
        final text = widget.displayText(item).toLowerCase();
        return text.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _filteredItems.isEmpty
                  ? Center(
                      child: Text(
                        'No items found',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        final displayText = widget.displayText(item);
                        final compareValue = widget.compareValue != null
                            ? widget.compareValue!(item)
                            : displayText;
                        final isSelected = compareValue == widget.currentValue;

                        return ListTile(
                          title: Text(displayText),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF2E7D7B),
                                )
                              : null,
                          onTap: () => Navigator.pop(context, item),
                        );
                      },
                    ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  padding: EdgeInsets.symmetric(vertical: 12),
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
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
