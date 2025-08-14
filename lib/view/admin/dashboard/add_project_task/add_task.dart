import 'package:flutter/material.dart';

class AddNewTaskPage extends StatefulWidget {
  const AddNewTaskPage({super.key});

  @override
  State<AddNewTaskPage> createState() => _AddNewTaskPageState();
}

class _AddNewTaskPageState extends State<AddNewTaskPage> {
  String? selectedProject;
  String? selectedPriority = "Medium";
  List<String> selectedEmployees = ["Jasir"]; // Changed to List
  DateTime? startDate;
  TimeOfDay? allocatedTime;

  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // Available employees list
  final List<String> availableEmployees = [
    "Jasir",
    "Anas",
    "Najath",
    "Sarah",
    "Ahmed",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F7F3),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 18,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Add New Task",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Select Project"),
            const SizedBox(height: 8),
            _buildDropdownField(
              label: "Select Project",
              value: selectedProject,
              items: ["Project A", "Project B"],
              onChanged: (value) => setState(() => selectedProject = value),
            ),
            const SizedBox(height: 15),
            _buildLabel("Task"),
            const SizedBox(height: 8),
            _buildTextField("Task Name", controller: taskNameController),
            const SizedBox(height: 15),
            _buildLabel("Priority"),
            const SizedBox(height: 8),
            _buildDropdownField(
              label: "Priority",
              value: selectedPriority,
              items: ["Low", "Medium", "High"],
              onChanged: (value) => setState(() => selectedPriority = value),
            ),
            const SizedBox(height: 15),
            _buildLabel("Select Employees"),
            const SizedBox(height: 8),
            _buildMultiSelectEmployeeField(), // New multi-select field
            const SizedBox(height: 15),
            _buildLabel("Start Date"),
            const SizedBox(height: 8),
            _buildDatePickerField("Expected Start Date", startDate, () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() => startDate = picked);
              }
            }),
            const SizedBox(height: 15),
            _buildLabel("Allocated Time"),
            const SizedBox(height: 8),
            _buildTimePickerField("Time in Hour", allocatedTime, () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                setState(() => allocatedTime = picked);
              }
            }),
            const SizedBox(height: 15),
            _buildTextField("Notes", controller: notesController, maxLines: 4),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _createTask();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C7690),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Create Task",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // New multi-select employee field
  Widget _buildMultiSelectEmployeeField() {
    return GestureDetector(
      onTap: _showEmployeeSelectionDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF1C7690)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: selectedEmployees.isEmpty
                  ? const Text(
                      "Select Employees",
                      style: TextStyle(color: Colors.grey),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: selectedEmployees.map((employee) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C7690).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF1C7690),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                employee,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF1C7690),
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedEmployees.remove(employee);
                                  });
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Color(0xFF1C7690),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // Show unique animated dialog for employee selection
  void _showEmployeeSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F7F3),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with gradient background
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF1C7690),
                            const Color(0xFF1C7690).withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.group,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Select Team Members",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Choose who will work on this task",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Selected count indicator
                    if (selectedEmployees.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(
                          top: 16,
                          left: 20,
                          right: 20,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C7690).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF1C7690).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: const Color(0xFF1C7690),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${selectedEmployees.length} member${selectedEmployees.length == 1 ? '' : 's'} selected",
                              style: TextStyle(
                                color: const Color(0xFF1C7690),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Employee list with custom cards
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: availableEmployees.length,
                          itemBuilder: (context, index) {
                            final employee = availableEmployees[index];
                            final isSelected = selectedEmployees.contains(
                              employee,
                            );

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    setDialogState(() {
                                      if (isSelected) {
                                        selectedEmployees.remove(employee);
                                      } else {
                                        selectedEmployees.add(employee);
                                      }
                                    });
                                    setState(() {}); // Update main widget
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(
                                              0xFF1C7690,
                                            ).withOpacity(0.08)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF1C7690)
                                            : Colors.grey.withOpacity(0.3),
                                        width: isSelected ? 2 : 1,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFF1C7690,
                                                ).withOpacity(0.1),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Row(
                                      children: [
                                        // Avatar
                                        CircleAvatar(
                                          radius: 22,
                                          backgroundColor: isSelected
                                              ? const Color(0xFF1C7690)
                                              : Colors.grey.withOpacity(0.2),
                                          child: Text(
                                            employee[0].toUpperCase(),
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.grey[600],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),

                                        // Employee info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                employee,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: isSelected
                                                      ? const Color(0xFF1C7690)
                                                      : Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "Team Member",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Selection indicator
                                        AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          child: isSelected
                                              ? Container(
                                                  padding: const EdgeInsets.all(
                                                    4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFF1C7690,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                )
                                              : Container(
                                                  padding: const EdgeInsets.all(
                                                    4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.grey
                                                          .withOpacity(0.4),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.add,
                                                    color: Colors.grey,
                                                    size: 16,
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Action buttons
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                ),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: selectedEmployees.isEmpty
                                  ? null
                                  : () {
                                      Navigator.of(context).pop();
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1C7690),
                                disabledBackgroundColor: Colors.grey
                                    .withOpacity(0.3),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: selectedEmployees.isNotEmpty ? 2 : 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Assign Task${selectedEmployees.length > 1 ? ' (${selectedEmployees.length})' : ''}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField(
    String hint, {
    TextEditingController? controller,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1C7690)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1C7690)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1C7690), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(label, style: const TextStyle(color: Colors.grey)),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1C7690)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1C7690)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1C7690), width: 1.5),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDatePickerField(
    String hint,
    DateTime? date,
    VoidCallback onTap,
  ) {
    return TextField(
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: date == null
            ? hint
            : "${date.day}/${date.month}/${date.year}",
        suffixIcon: const Icon(Icons.calendar_today, size: 20),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1C7690)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1C7690)),
        ),
      ),
    );
  }

  Widget _buildTimePickerField(
    String hint,
    TimeOfDay? time,
    VoidCallback onTap,
  ) {
    return TextField(
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: time == null
            ? hint
            : "${time.hour}:${time.minute.toString().padLeft(2, '0')}",
        suffixIcon: const Icon(Icons.access_time, size: 20),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1C7690)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1C7690)),
        ),
      ),
    );
  }

  void _createTask() {
    // Handle task creation logic here
    print('Selected Project: $selectedProject');
    print('Task Name: ${taskNameController.text}');
    print('Priority: $selectedPriority');
    print('Selected Employees: $selectedEmployees'); // Now prints list
    print('Start Date: $startDate');
    print('Allocated Time: $allocatedTime');
    print('Notes: ${notesController.text}');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Task assigned to ${selectedEmployees.length} employee(s) successfully!',
        ),
        backgroundColor: const Color(0xFF1C7690),
      ),
    );

    // Navigate back or to another screen
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    taskNameController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
