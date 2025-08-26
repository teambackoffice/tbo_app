import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/create_project_controller.dart';

class AddNewProjectPage extends StatefulWidget {
  const AddNewProjectPage({super.key});

  @override
  State<AddNewProjectPage> createState() => _AddNewProjectPageState();
}

class _AddNewProjectPageState extends State<AddNewProjectPage>
    with TickerProviderStateMixin {
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectIdController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final DateFormat _displayFormat = DateFormat('d-M-yyyy');
  final DateFormat _apiFormat = DateFormat('yyyy-MM-dd');

  String _selectedProjectType = 'Select Project Type';
  String _selectedDepartment = 'Select Department';
  String _selectedPriority = 'Select Priority';

  final List<String> _projectTypes = [
    'Select Project Type',
    'Internal',
    'External',
    'Other',
  ];

  final List<String> _departments = [
    'Select Department',
    'Accounts',
    'Human Resources',
    'Management',
    'Production',
    'Operations',
  ];

  final List<String> _priorities = [
    'Select Priority',
    'Low',
    'Medium',
    'High',
    'Critical',
  ];

  // Replace your existing _selectDate method with this:
  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      // Display format: 29-8-2025
      controller.text = _displayFormat.format(picked);
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
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
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              await _createProject();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLoading
                            ? const Color(0xFF2E7D7D).withOpacity(0.7)
                            : const Color(0xFF2E7D7D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Creating...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : const Text(
                              'Create Project',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                );
              },
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

  Future<void> _createProject() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    _animationController.forward();

    try {
      // Convert display dates to API format
      String apiStartDate = _convertToApiFormat(_startDateController.text);
      String apiEndDate = _convertToApiFormat(_endDateController.text);

      print('Start Date (Display): ${_startDateController.text}'); // 29-8-2025
      print('Start Date (API): $apiStartDate'); // 2025-08-29

      await Provider.of<CreateProjectController>(
        context,
        listen: false,
      ).createProject(
        projectName: _projectNameController.text,
        status: "Open",
        startDate: apiStartDate, // API format
        endDate: apiEndDate, // API format
        projectType: _selectedProjectType,
        priority: _selectedPriority,
        department: _selectedDepartment,
        notes: _notesController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Project created successfully!'),
            backgroundColor: Color(0xFF2E7D7D),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating project: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _animationController.reverse();
      }
    }
  }

  String _convertToApiFormat(String displayDate) {
    if (displayDate.isEmpty) return '';
    try {
      DateTime date = _displayFormat.parse(displayDate);
      return _apiFormat.format(date);
    } catch (e) {
      return '';
    }
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _projectIdController.dispose();
    _notesController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _animationController.dispose(); // Add this line
    super.dispose();
  }
}
