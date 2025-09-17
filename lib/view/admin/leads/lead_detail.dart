import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/create_project_planning_controller.dart';
import 'package:tbo_app/modal/all_lead_list_modal.dart';
import 'package:tbo_app/view/admin/leads/project_planning.dart';

class LeadDetailsPage extends StatelessWidget {
  final Leads lead;
  const LeadDetailsPage({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 16,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Company Name
                        _buildInfoField('Company Name', lead.leadName!),
                        const SizedBox(height: 24),

                        // Lead Segment
                        _buildInfoField(
                          'Lead Segment',
                          lead.customLeadSegment!,
                        ),
                        const SizedBox(height: 24),

                        // Lead Type
                        _buildInfoField('Lead Type', 'High[Harcoded]'),
                        const SizedBox(height: 24),

                        // Full Name
                        _buildInfoField('Full Name', lead.companyName!),
                        const SizedBox(height: 24),

                        // Email
                        _buildInfoField('Email', lead.emailId ?? 'N/A'),
                        const SizedBox(height: 24),

                        // Phone Number
                        _buildInfoField('Phone Number', lead.mobileNo!),
                        const SizedBox(height: 24),

                        // Location
                        _buildInfoField(
                          'Project Type',
                          lead.customProjectType!,
                        ),
                        const SizedBox(height: 24),

                        // Status
                        _buildStatusField('Status', lead.status!),
                        SizedBox(height: 50),

                        // Project Planning Button
                        lead.status == "Converted"
                            ? Consumer<ProjectPlanningController>(
                                builder: (context, controller, child) {
                                  return SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: controller.isLoading
                                          ? null
                                          : () async {
                                              try {
                                                // 🔥 CHANGE 2: Await the API response and extract planning_id
                                                String
                                                response = await controller
                                                    .createProjectPlanning(
                                                      planningName:
                                                          lead.leadName!,
                                                      leadSegment: lead
                                                          .customLeadSegment!,
                                                    );

                                                // 🔥 CHANGE 3: Parse the response to get planning_id
                                                String? planningId =
                                                    _extractPlanningId(
                                                      response,
                                                    );

                                                if (planningId != null) {
                                                  // Navigate with planning_id
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProjectPlanningScreen(
                                                            lead: lead,
                                                            planningId:
                                                                planningId, // 🔥 PASS PLANNING_ID
                                                          ),
                                                    ),
                                                  );
                                                } else {
                                                  // Show error if planning_id not found
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Failed to get planning ID',
                                                      ),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                // Show error message
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Error: $e'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF1C7690,
                                        ),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            28,
                                          ),
                                        ),
                                      ),
                                      child: controller.isLoading
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Text(
                                              'Project Planning',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ),
                                  );
                                },
                              )
                            : SizedBox(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Add this method to your LeadDetailsPage class
  String? _extractPlanningId(String response) {
    try {
      Map<String, dynamic> jsonResponse = json.decode(response);
      String? planningId = jsonResponse['data']?['planning_id']?.toString();

      print("Extracted planning_id: $planningId");
      return planningId;
    } catch (e) {
      print('Error parsing response: $e');
      return null;
    }
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF4CAF50),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
