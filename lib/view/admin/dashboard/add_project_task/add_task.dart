import 'package:flutter/material.dart';

class AddNewTaskPage extends StatefulWidget {
  const AddNewTaskPage({super.key});

  @override
  State<AddNewTaskPage> createState() => _AddNewTaskPageState();
}

class _AddNewTaskPageState extends State<AddNewTaskPage> {
  String? selectedProject;
  String? selectedPriority = "Medium";
  String? selectedEmployee = "Jasir";
  DateTime? startDate;
  TimeOfDay? allocatedTime;

  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F7F3),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8), // space from app bar edges
          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: Colors.white, // optional background
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
            _buildLabel("Select Employee"),
            const SizedBox(height: 8),
            _buildDropdownField(
              label: "Select Employee",
              value: selectedEmployee,
              items: ["Jasir", "Anas", "Najath"],
              onChanged: (value) => setState(() => selectedEmployee = value),
            ),
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
    print('Selected Employee: $selectedEmployee');
    print('Start Date: $startDate');
    print('Allocated Time: $allocatedTime');
    print('Notes: ${notesController.text}');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task created successfully!'),
        backgroundColor: Color(0xFF1C7690),
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
