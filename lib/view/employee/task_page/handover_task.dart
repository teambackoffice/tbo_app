import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/all_employees._controller.dart';
import 'package:tbo_app/controller/employee_handover_controller.dart';
import 'package:tbo_app/modal/all_employees.modal.dart';
import 'package:tbo_app/widgets/authenticated_avatar.dart';

class CreateHandoverPage extends StatefulWidget {
  final String taskId;
  // final String assignmentID;
  const CreateHandoverPage({
    super.key,
    required this.taskId,
    // required this.assignmentID,
  });

  @override
  State<CreateHandoverPage> createState() => _CreateHandoverPageState();
}

class _CreateHandoverPageState extends State<CreateHandoverPage> {
  final _formKey = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();

  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _handoverEmployeeIdController =
      TextEditingController();
  final TextEditingController _taskIdController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _handoverType = "Temporary";
  String? _selectedReason;
  DateTime? _fromDate;
  DateTime? _toDate;

  Message? _selectedEmployee;

  @override
  void initState() {
    super.initState();
    _loadEmployeeId();
    // No separate task record — use the assignment ID as the task reference
    // _taskIdController.text = widget.assignmentID;
  }

  Future<void> _loadEmployeeId() async {
    try {
      final employeeId = await _storage.read(key: 'employee_original_id');
      if (employeeId != null) {
        setState(() {
          _employeeIdController.text = employeeId;
        });
      }
    } catch (e) {
      print('Error loading employee ID: $e');
    }
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  Future<void> _submitHandover() async {
    if (_formKey.currentState!.validate()) {
      // Validate dates for temporary handover
      if (_handoverType == "Temporary") {
        if (_fromDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select start date")),
          );
          return;
        }
        if (_toDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select end date")),
          );
          return;
        }
        if (_toDate!.isBefore(_fromDate!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("End date must be after start date")),
          );
          return;
        }
      }

      final controller = Provider.of<TaskHandoverController>(
        context,
        listen: false,
      );

      try {
        await controller.createHandover(
          fromEmployee: _employeeIdController.text,
          toEmployee: _selectedEmployee!.name,
          // No separate task record — use assignment ID as both task & employeeTask
          task: widget.taskId,
          employeeTask: widget.taskId,
          handoverReason:
              _selectedReason!, // Use selected reason instead of text field
          handoverNotes: _notesController.text.isNotEmpty
              ? _notesController.text
              : "No additional notes",
          handoverType: _handoverType,
          leaveStartDate: _handoverType == "Temporary"
              ? _fromDate?.toIso8601String().split("T").first
              : null,
          leaveEndDate: _handoverType == "Temporary"
              ? _toDate?.toIso8601String().split("T").first
              : null,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Handover created successfully")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskHandoverController = Provider.of<TaskHandoverController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Task Handover"),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // From Employee ID
              TextFormField(
                controller: _employeeIdController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'From Employee ID',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              // Handover To Employee
              TextFormField(
                controller: _handoverEmployeeIdController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Handover To Employee',
                  hintText: 'Tap to select employee',
                  prefixIcon: Icon(Icons.person_add),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Please select an employee"
                    : null,
                onTap: () async {
                  final selectedEmployee = await showModalBottomSheet<Message>(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    isScrollControlled: true,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    builder: (context) {
                      return const EmployeeSelectionSheet();
                    },
                  );

                  if (selectedEmployee != null) {
                    setState(() {
                      _selectedEmployee = selectedEmployee;
                      _handoverEmployeeIdController.text =
                          selectedEmployee.employeeName;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Task ID
              TextFormField(
                controller: TextEditingController(text: widget.taskId),
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Task ID',
                  prefixIcon: Icon(Icons.task),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              // Handover Type Dropdown
              DropdownButtonFormField<String>(
                initialValue: _handoverType,
                decoration: const InputDecoration(
                  labelText: "Handover Type",
                  prefixIcon: Icon(Icons.swap_horiz),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Temporary",
                    child: Text("Temporary"),
                  ),
                  DropdownMenuItem(
                    value: "Permanent",
                    child: Text("Permanent"),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _handoverType = val;
                      // Clear dates when switching types
                      _fromDate = null;
                      _toDate = null;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Reason Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedReason,
                decoration: const InputDecoration(
                  labelText: 'Handover Reason',
                  prefixIcon: Icon(Icons.info_outline),
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Select reason for handover'),
                items: const [
                  DropdownMenuItem(value: "Leave", child: Text("Leave")),
                  DropdownMenuItem(
                    value: "Sick Leave",
                    child: Text("Sick Leave"),
                  ),
                  DropdownMenuItem(
                    value: "Maternity Leave",
                    child: Text("Maternity Leave"),
                  ),
                  DropdownMenuItem(
                    value: "Personal Emergency",
                    child: Text("Personal Emergency"),
                  ),
                  DropdownMenuItem(value: "Training", child: Text("Training")),
                  DropdownMenuItem(
                    value: "Project Change",
                    child: Text("Project Change"),
                  ),
                  DropdownMenuItem(value: "Other", child: Text("Other")),
                ],
                validator: (value) =>
                    value == null ? "Please select a reason" : null,
                onChanged: (val) {
                  setState(() {
                    _selectedReason = val;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Notes
              TextFormField(
                controller: _notesController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Handover Notes (Optional)',
                  hintText:
                      'Add any additional notes or instructions for the handover...',
                  prefixIcon: Icon(Icons.note_alt_outlined),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),

              // Date pickers - only show for temporary handover
              if (_handoverType == "Temporary") ...[
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickDate(isStart: true),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: "Start Date *",
                            prefixIcon: const Icon(Icons.date_range),
                            border: const OutlineInputBorder(),
                            fillColor: _fromDate == null
                                ? Colors.red.withOpacity(0.1)
                                : null,
                            filled: _fromDate == null,
                          ),
                          child: Text(
                            _fromDate != null
                                ? _fromDate!.toIso8601String().split("T").first
                                : "Select start date",
                            style: TextStyle(
                              color: _fromDate == null
                                  ? Colors.grey[600]
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickDate(isStart: false),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: "End Date *",
                            prefixIcon: const Icon(Icons.date_range),
                            border: const OutlineInputBorder(),
                            fillColor: _toDate == null
                                ? Colors.red.withOpacity(0.1)
                                : null,
                            filled: _toDate == null,
                          ),
                          child: Text(
                            _toDate != null
                                ? _toDate!.toIso8601String().split("T").first
                                : "Select end date",
                            style: TextStyle(
                              color: _toDate == null ? Colors.grey[600] : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ] else
                const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: taskHandoverController.isLoading
                      ? null
                      : _submitHandover,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: taskHandoverController.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Submit Handover",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _handoverEmployeeIdController.dispose();
    _taskIdController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

class EmployeeSelectionSheet extends StatefulWidget {
  const EmployeeSelectionSheet({super.key});

  @override
  State<EmployeeSelectionSheet> createState() => _EmployeeSelectionSheetState();
}

class _EmployeeSelectionSheetState extends State<EmployeeSelectionSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Message> _filteredEmployees = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterEmployees);
  }

  void _filterEmployees() {
    final controller = Provider.of<AllEmployeesController>(
      context,
      listen: false,
    );
    if (controller.allEmployees != null) {
      setState(() {
        _filteredEmployees = controller.allEmployees!.message.where((emp) {
          return emp.employeeName.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ) ||
              emp.designation.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ) ||
              emp.department.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              );
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AllEmployeesController>(context);

    if (controller.allEmployees == null && !controller.isLoading) {
      Future.microtask(() => controller.fetchallemployees());
    }

    // Initialize filtered list
    if (_filteredEmployees.isEmpty && controller.allEmployees != null) {
      _filteredEmployees = controller.allEmployees!.message;
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            height: 5,
            width: 40,
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Select Employee",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          if (controller.isLoading)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Loading employees..."),
                  ],
                ),
              ),
            )
          else if (controller.error != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(
                      "Error: ${controller.error}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => controller.fetchallemployees(),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search employees...",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterEmployees();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
            ),

            // Employee count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${_filteredEmployees.length} employee(s) found",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Employee list
            Expanded(
              child: _filteredEmployees.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_off,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No employees found",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Try adjusting your search",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: _filteredEmployees.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1, indent: 72),
                      itemBuilder: (context, index) {
                        final emp = _filteredEmployees[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: AuthenticatedAvatar(
                            radius: 24,
                            imageUrl: emp.imageUrl,
                            name: emp.employeeName,
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            initialsColor: Theme.of(context).primaryColor,
                            initialsFontSize: 14,
                          ),
                          title: Text(
                            emp.employeeName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2),
                              Text(
                                emp.designation,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                emp.department,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                          onTap: () {
                            Navigator.pop(context, emp);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      },
                    ),
            ),
          ],

          // Safe area padding at bottom
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
