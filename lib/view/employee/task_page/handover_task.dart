import 'package:flutter/material.dart';

// Create Handover Page
class CreateHandoverPage extends StatefulWidget {
  const CreateHandoverPage({super.key});

  @override
  _CreateHandoverPageState createState() => _CreateHandoverPageState();
}

class _CreateHandoverPageState extends State<CreateHandoverPage> {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  final _taskIdController = TextEditingController();
  final _reasonController = TextEditingController();
  final _handoverEmployeeIdController = TextEditingController();

  String _handoverType = 'permanent';
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _employeeIdController.dispose();
    _taskIdController.dispose();
    _reasonController.dispose();
    _handoverEmployeeIdController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  void _submitHandover() async {
    if (_formKey.currentState!.validate()) {
      if (_handoverType == 'temporary' &&
          (_fromDate == null || _toDate == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please select both From and To dates for temporary handover',
            ),
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Show success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Task handover created successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Go back to home
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Task Handover')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Handover Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Employee ID
                      TextFormField(
                        controller: _employeeIdController,
                        decoration: InputDecoration(
                          labelText: 'Employee ID',
                          hintText: 'Enter your employee ID',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter employee ID';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Task ID
                      TextFormField(
                        controller: _taskIdController,
                        decoration: InputDecoration(
                          labelText: 'Task ID',
                          hintText: 'Enter task ID to handover',
                          prefixIcon: Icon(Icons.task),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter task ID';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Handover To Employee ID
                      TextFormField(
                        controller: _handoverEmployeeIdController,
                        decoration: InputDecoration(
                          labelText: 'Handover To Employee ID',
                          hintText: 'Enter recipient employee ID',
                          prefixIcon: Icon(Icons.person_add),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter handover employee ID';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Reason
                      TextFormField(
                        controller: _reasonController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Reason for Handover',
                          hintText: 'Enter reason for task handover',
                          prefixIcon: Icon(Icons.description),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter reason for handover';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Handover Type
                      Text(
                        'Handover Type',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text('Permanent'),
                              value: 'permanent',
                              groupValue: _handoverType,
                              onChanged: (String? value) {
                                setState(() {
                                  _handoverType = value!;
                                  _fromDate = null;
                                  _toDate = null;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text('Temporary'),
                              value: 'temporary',
                              groupValue: _handoverType,
                              onChanged: (String? value) {
                                setState(() {
                                  _handoverType = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      // Date Selection for Temporary Handover
                      if (_handoverType == 'temporary') ...[
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => _selectDate(context, true),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today),
                                      SizedBox(width: 8),
                                      Text(
                                        _fromDate != null
                                            ? 'From: ${_fromDate!.day}/${_fromDate!.month}/${_fromDate!.year}'
                                            : 'Select From Date',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: () => _selectDate(context, false),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today),
                                      SizedBox(width: 8),
                                      Text(
                                        _toDate != null
                                            ? 'To: ${_toDate!.day}/${_toDate!.month}/${_toDate!.year}'
                                            : 'Select To Date',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitHandover,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Submit Handover',
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

// Data Model
class HandoverRequest {
  final String id;
  final String employeeId;
  final String taskId;
  final String handoverToId;
  final String reason;
  final String type;
  final String status;
  final DateTime? fromDate;
  final DateTime? toDate;
  final DateTime createdDate;

  HandoverRequest({
    required this.id,
    required this.employeeId,
    required this.taskId,
    required this.handoverToId,
    required this.reason,
    required this.type,
    required this.status,
    this.fromDate,
    this.toDate,
    required this.createdDate,
  });
}
