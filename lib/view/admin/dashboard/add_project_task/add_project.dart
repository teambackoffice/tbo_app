import 'package:flutter/material.dart';

class AddNewProjectPage extends StatefulWidget {
  const AddNewProjectPage({super.key});

  @override
  State<AddNewProjectPage> createState() => _AddNewProjectPageState();
}

class _AddNewProjectPageState extends State<AddNewProjectPage> {
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectIdController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  String _selectedProjectType = 'Project Type';
  String _selectedDepartment = 'ERPNext';
  String _selectedPriority = 'Medium';

  final List<String> _projectTypes = [
    'Project Type',
    'Development',
    'Marketing',
    'Research',
    'Design',
  ];

  final List<String> _departments = [
    'ERPNext',
    'IT',
    'Marketing',
    'Sales',
    'HR',
  ];

  final List<String> _priorities = ['Low', 'Medium', 'High', 'Critical'];

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      controller.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

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

        title: const Text(
          'Add New Project',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project Name
                    _buildLabel('Project Name'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _projectNameController,
                      hintText: 'Project Name',
                    ),
                    const SizedBox(height: 20),

                    // Project ID
                    _buildLabel('Project ID'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _projectIdController,
                      hintText: 'Project ID',
                    ),
                    const SizedBox(height: 20),

                    // Project Type
                    _buildLabel('Project Type'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: _selectedProjectType,
                      items: _projectTypes,
                      onChanged: (value) {
                        setState(() {
                          _selectedProjectType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Department
                    _buildLabel('Department'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: _selectedDepartment,
                      items: _departments,
                      onChanged: (value) {
                        setState(() {
                          _selectedDepartment = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Priority
                    _buildLabel('Priority'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: _selectedPriority,
                      items: _priorities,
                      onChanged: (value) {
                        setState(() {
                          _selectedPriority = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Expected Start Date
                    _buildLabel('Expected Start Date'),
                    const SizedBox(height: 8),
                    _buildDateField(
                      controller: _startDateController,
                      hintText: 'Expected Start Date',
                    ),
                    const SizedBox(height: 20),

                    // Expected End Date
                    _buildLabel('Expected End Date'),
                    const SizedBox(height: 8),
                    _buildDateField(
                      controller: _endDateController,
                      hintText: 'Expected End Date',
                    ),
                    const SizedBox(height: 20),

                    // Notes
                    _buildTextField(
                      controller: _notesController,
                      hintText: 'Notes',
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Create Project Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Handle create project action
                  _createProject();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D7D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Create Project',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1C7690)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1C7690)),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
        dropdownColor: Colors.white,
        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9E9E9E)),
        items: items.map((String item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1C7690)),
      ),
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () => _selectDate(controller),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon: const Icon(
            Icons.calendar_today_outlined,
            color: Color(0xFF9E9E9E),
            size: 20,
          ),
        ),
      ),
    );
  }

  void _createProject() {
    // Handle project creation logic here
    print('Project Name: ${_projectNameController.text}');
    print('Project ID: ${_projectIdController.text}');
    print('Project Type: $_selectedProjectType');
    print('Department: $_selectedDepartment');
    print('Priority: $_selectedPriority');
    print('Start Date: ${_startDateController.text}');
    print('End Date: ${_endDateController.text}');
    print('Notes: ${_notesController.text}');

    // You can add your project creation logic here
    // For example, API calls, database operations, etc.

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Project created successfully!'),
        backgroundColor: Color(0xFF2E7D7D),
      ),
    );

    // Navigate back or to another screen
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _projectIdController.dispose();
    _notesController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }
}
