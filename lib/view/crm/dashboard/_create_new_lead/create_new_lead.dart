import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/all_lead_list_controller.dart';
import 'package:tbo_app/controller/create_new_lead_controller.dart';

class CreateLeadForm extends StatefulWidget {
  const CreateLeadForm({super.key});

  @override
  State<CreateLeadForm> createState() => _CreateLeadFormState();
}

class _CreateLeadFormState extends State<CreateLeadForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _selectedLeadSource = 'Advertisement';
  final String _selectedLeadStatus = 'New';
  String _selectedMarketSegment = 'Lower Income';
  String _selectedCustomLeadSegment = 'Erpnext';
  String _selectedProjectType = 'Internal';
  String _selectedDepartment = 'Accounts';
  String _selectedPriority = 'Medium';

  final List<String> _leadSources = [
    'Advertisement',
    'Campaign',
    'Cold Calling',
    'Customer\'s Vendor',
    'Exhibition',
    'Existing Customer',
    'IRFAD',
    'LEADS COLLECTIONS',
  ];

  final List<String> _marketSegments = [
    'Lower Income',
    'Middle Income',
    'Upper Income',
  ];

  final List<String> _customLeadSegments = ['Erpnext', 'Digital'];

  final List<String> _projectTypes = ['Internal', 'External'];

  final List<String> _departments = [
    'Accounts',
    'Business development - TBO',
    'DIGITAL MARKETING - TBO',
    'ERPNext - TBO',
    'Human Resources',
    'Information Technology - TBO',
    'Management',
    'Marketing',
  ];

  final List<String> _priorities = ['Low', 'Medium', 'High', 'Urgent'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F7F3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Lead Form',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Lead Name'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _fullNameController,
                hintText: 'Enter lead name',
              ),
              const SizedBox(height: 20),

              _buildLabel('Email'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hintText: 'Enter email address',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              _buildLabel('Phone Number'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _phoneController,
                hintText: 'Enter phone number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              _buildLabel('Company Name'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _companyController,
                hintText: 'Enter company name',
              ),
              const SizedBox(height: 20),

              _buildLabel('Lead Source'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedLeadSource,
                items: _leadSources,
                onChanged: (value) {
                  setState(() {
                    _selectedLeadSource = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              _buildLabel('Market Segment'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedMarketSegment,
                items: _marketSegments,
                onChanged: (value) {
                  setState(() {
                    _selectedMarketSegment = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              _buildLabel('Custom Lead Segment'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedCustomLeadSegment,
                items: _customLeadSegments,
                onChanged: (value) {
                  setState(() {
                    _selectedCustomLeadSegment = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

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

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _createLead,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C7690),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Create Lead',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF6B7280),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1C7690), width: 1.5),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 16),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: InputBorder.none,
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
        border: Border.all(color: const Color(0xFF1C7690), width: 1.5),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
        ),
        style: const TextStyle(fontSize: 16, color: Colors.black),
        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
        items: items.map((String item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  void _createLead() async {
    if (_formKey.currentState!.validate()) {
      final leadData = {
        'lead_name': _fullNameController.text,
        'email_id': _emailController.text,
        'mobile_no': _phoneController.text,
        'company_name': _companyController.text,
        'source': _selectedLeadSource,
        'status': "Open",
        'market_segment': _selectedMarketSegment,
        'custom_lead_segment': _selectedCustomLeadSegment,
        'custom_project_type': _selectedProjectType,
        'custom_department': _selectedDepartment,
        'custom_priority': _selectedPriority,
        'territory': "India",
      };

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      // Call the provider
      final controller = Provider.of<CreateNewLeadController>(
        context,
        listen: false,
      );
      final success = await controller.createLead(leadData);

      // Hide loading
      Navigator.of(context).pop();

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lead created successfully!'),
            backgroundColor: Color(0xFF2D7A7B),
          ),
        );
        // Navigate back
        Navigator.of(context).pop();
        Provider.of<AllLeadListController>(
          context,
          listen: false,
        ).fetchAllLeadList();
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create lead. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _notesController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
