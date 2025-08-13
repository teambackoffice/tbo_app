import 'package:flutter/material.dart';

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

  String _selectedLeadSource = 'Website';
  String _selectedLeadStatus = 'New';

  final List<String> _leadSources = [
    'Website',
    'Social Media',
    'Email Campaign',
    'Phone Call',
    'Referral',
    'Event',
    'Advertisement',
  ];

  final List<String> _leadStatuses = [
    'New',
    'Contacted',
    'Qualified',
    'Proposal',
    'Negotiation',
    'Closed Won',
    'Closed Lost',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
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
              _buildLabel('Full Name'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _fullNameController,
                hintText: 'Enter full name',
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

              _buildLabel('Lead Status'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedLeadStatus,
                items: _leadStatuses,
                onChanged: (value) {
                  setState(() {
                    _selectedLeadStatus = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              _buildLabel('Notes'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _notesController,
                hintText: 'Add additional notes',
                maxLines: 5,
              ),
              const SizedBox(height: 40),

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
        value: value,
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

  void _createLead() {
    if (_formKey.currentState!.validate()) {
      // Handle form submission
      print('Full Name: ${_fullNameController.text}');
      print('Email: ${_emailController.text}');
      print('Phone: ${_phoneController.text}');
      print('Company: ${_companyController.text}');
      print('Lead Source: $_selectedLeadSource');
      print('Lead Status: $_selectedLeadStatus');
      print('Notes: ${_notesController.text}');

      // Show success message or navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lead created successfully!'),
          backgroundColor: Color(0xFF2D7A7B),
        ),
      );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
