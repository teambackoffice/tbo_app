import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/create_project_planning_controller.dart';
import 'package:tbo_app/modal/all_lead_list_modal.dart';
import 'package:tbo_app/view/admin/leads/project_planning.dart';

class LeadDetailsPage extends StatefulWidget {
  final Leads lead;
  const LeadDetailsPage({super.key, required this.lead});

  @override
  State<LeadDetailsPage> createState() => _LeadDetailsPageState();
}

class _LeadDetailsPageState extends State<LeadDetailsPage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _planningId;
  bool _isCheckingPlanning = true;

  @override
  void initState() {
    super.initState();
    _checkExistingPlanning();
  }

  // Check if planning already exists in storage
  Future<void> _checkExistingPlanning() async {
    try {
      // Use lead name as key to store/retrieve planning ID
      final key = 'planning_${widget.lead.leadName}';
      final storedPlanningId = await _storage.read(key: key);

      setState(() {
        _planningId = storedPlanningId;
        _isCheckingPlanning = false;
      });

      print("Loaded planning_id from storage: $storedPlanningId");
    } catch (e) {
      print("Error checking planning: $e");
      setState(() {
        _isCheckingPlanning = false;
      });
    }
  }

  // Save planning ID to storage
  Future<void> _savePlanningId(String planningId) async {
    try {
      final key = 'planning_${widget.lead.leadName}';
      await _storage.write(key: key, value: planningId);
      print("Saved planning_id to storage: $planningId");
    } catch (e) {
      print("Error saving planning: $e");
    }
  }

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
              child: SingleChildScrollView(
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
                          _buildInfoField(
                            'Company Name',
                            widget.lead.leadName ?? 'N/A',
                          ),
                          const SizedBox(height: 24),
                          _buildInfoField(
                            'Lead Segment',
                            widget.lead.customLeadSegment ?? 'N/A',
                          ),
                          const SizedBox(height: 24),
                          _buildInfoField('Lead Type', 'High[Hardcoded]'),
                          const SizedBox(height: 24),
                          _buildInfoField(
                            'Full Name',
                            widget.lead.companyName ?? 'N/A',
                          ),
                          const SizedBox(height: 24),
                          _buildInfoField(
                            'Email',
                            widget.lead.emailId ?? 'N/A',
                          ),
                          const SizedBox(height: 24),
                          _buildInfoField(
                            'Phone Number',
                            widget.lead.mobileNo ?? 'N/A',
                          ),
                          const SizedBox(height: 24),
                          _buildInfoField(
                            'Project Type',
                            widget.lead.customProjectType ?? 'N/A',
                          ),
                          const SizedBox(height: 24),
                          _buildStatusField(
                            'Status',
                            widget.lead.status ?? 'N/A',
                          ),
                          const SizedBox(height: 50),

                          // Project Planning Button - Only show if converted and no planning exists
                          if (widget.lead.status == "Converted")
                            Consumer<ProjectPlanningController>(
                              builder: (context, controller, child) {
                                // Show loading while checking existing planning
                                if (_isCheckingPlanning) {
                                  return SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: null,
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
                                      child: const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                // Hide button if planning already exists
                                if (_planningId != null) {
                                  return Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE8F5E9),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFF4CAF50),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.check_circle,
                                              color: Color(0xFF4CAF50),
                                              size: 24,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Project Created',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFF2E7D32),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                // Show create button only if no planning exists
                                return SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: controller.isLoading
                                        ? null
                                        : () => _handleProjectPlanning(
                                            controller,
                                          ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1C7690),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(28),
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
                                            'Create Project Planning',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                          const SizedBox(height: 20),
                        ],
                      ),
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

  Future<void> _handleProjectPlanning(
    ProjectPlanningController controller,
  ) async {
    try {
      String? planningId = _planningId;

      // If no planning exists, create one
      if (planningId == null) {
        String response = await controller.createProjectPlanning(
          planningName: widget.lead.leadName ?? '',
          leadSegment: widget.lead.customLeadSegment ?? '',
        );

        planningId = _extractPlanningId(response);

        if (planningId != null) {
          // Save to storage
          await _savePlanningId(planningId);

          setState(() {
            _planningId = planningId;
          });
        }
      }

      if (planningId != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectPlanningScreen(
              lead: widget.lead,
              planningId: planningId!,
            ),
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to get planning ID'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        // Check if error is due to duplicate planning
        if (e.toString().contains('already exists') ||
            e.toString().contains('duplicate')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Project planning already exists for this lead'),
              backgroundColor: Colors.orange,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  String? _extractPlanningId(String response) {
    try {
      Map<String, dynamic> jsonResponse = json.decode(response);

      // Try multiple possible paths for planning_id
      String? planningId =
          jsonResponse['data']?['planning_id']?.toString() ??
          jsonResponse['data']?['name']?.toString() ??
          jsonResponse['planning_id']?.toString() ??
          jsonResponse['name']?.toString();

      print("Extracted planning_id: $planningId");
      print("Full response: $response");
      return planningId;
    } catch (e) {
      print('Error parsing response: $e');
      print('Response body: $response');
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
