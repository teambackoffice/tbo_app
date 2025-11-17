import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/date_request_controller.dart';

class CreateDateRequest extends StatefulWidget {
  final String? taskId;
  const CreateDateRequest({super.key, this.taskId});

  @override
  _CreateDateRequestState createState() => _CreateDateRequestState();
}

class _CreateDateRequestState extends State<CreateDateRequest> {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  late final TextEditingController _taskIdController;
  final _reasonController = TextEditingController();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _employeeIdController.dispose();
    _taskIdController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _loadEmployeeId() async {
    final employeeId = await _secureStorage.read(
      key: 'employee_original_id',
    ); // make sure your key matches
    if (employeeId != null) {
      setState(() {
        _employeeIdController.text = employeeId;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _taskIdController = TextEditingController(text: widget.taskId ?? '');
    _loadEmployeeId();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submitDateRequest(CreateDateRequestController controller) async {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select both Start and End dates'),
          ),
        );
        return;
      }

      if (_endDate!.isBefore(_startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End date must be after start date')),
        );
        return;
      }

      await controller.createEmployeeDateRequest(
        employee: _employeeIdController.text,
        task: _taskIdController.text,
        requestedStartDate:
            "${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}",
        requestedEndDate:
            "${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}",
        reason: _reasonController.text,
      );

      if (controller.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${controller.errorMessage}")),
        );
      } else if (controller.responseData != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Rounded corners
              ),
              contentPadding: const EdgeInsets.all(20),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Success Icon
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Success!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Date request submitted successfully!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop(); // Go back
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('OK'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CreateDateRequestController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Date Request')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date Request Form',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Employee ID
                      TextFormField(
                        controller: _employeeIdController,
                        decoration: const InputDecoration(
                          labelText: 'Employee ID',
                          hintText: 'Enter your employee ID',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter employee ID'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Task ID
                      TextFormField(
                        controller: _taskIdController,
                        decoration: const InputDecoration(
                          labelText: 'Task ID',
                          hintText: 'Enter task ID',
                          prefixIcon: Icon(Icons.task),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter task ID'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Start Date
                      InkWell(
                        onTap: () => _selectDate(context, true),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.blue[700],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _startDate != null
                                    ? 'Start Date: ${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                                    : 'Select Start Date',
                                style: TextStyle(
                                  color: _startDate != null
                                      ? Colors.black
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // End Date
                      InkWell(
                        onTap: () => _selectDate(context, false),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.blue[700],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _endDate != null
                                    ? 'End Date: ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                                    : 'Select End Date',
                                style: TextStyle(
                                  color: _endDate != null
                                      ? Colors.black
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Reason
                      TextFormField(
                        controller: _reasonController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Reason for Date Request',
                          hintText: 'Enter reason for your date request',
                          prefixIcon: Icon(Icons.description),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter reason for date request'
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading
                      ? null
                      : () => _submitDateRequest(controller),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: controller.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Submit Date Request',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
