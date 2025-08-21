import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tbo_app/modal/project_list_modal.dart';

class CommonProjectPageDetails extends StatelessWidget {
  final ProjectDetails project;
  const CommonProjectPageDetails({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        project.projectName!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Project ID
                      Text(
                        project.name!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Project details
                      project.projectType?.isEmpty ?? true
                          ? const SizedBox.shrink()
                          : _buildDetailRow(
                              'Project Type',
                              project.projectType ?? '',
                            ),
                      _buildDetailRow('Department', 'Digital Marketing'),
                      _buildDetailRow('Priority', project.priority!),
                      project.expectedStartDate == null
                          ? const SizedBox.shrink()
                          : _buildDetailRow(
                              'Expected Start Date',
                              DateFormat(
                                'dd MMM yyyy',
                              ).format(project.expectedStartDate!),
                            ),

                      project.expectedEndDate == null
                          ? const SizedBox.shrink()
                          : _buildDetailRow(
                              'Expected End Date',
                              DateFormat(
                                'dd MMM yyyy',
                              ).format(project.expectedEndDate!),
                            ),

                      const SizedBox(height: 12),
                      // Description
                      (project.notes?.isEmpty ?? true)
                          ? const SizedBox.shrink()
                          : Text(
                              project.notes!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.5,
                                letterSpacing: 0.2,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20), // Add bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 50),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
