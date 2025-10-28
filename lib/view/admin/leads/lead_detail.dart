import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/create_project_planning_controller.dart';
import 'package:tbo_app/modal/all_lead_list_modal.dart';
import 'package:tbo_app/utils/app_storage.dart';
import 'package:tbo_app/view/admin/leads/project_planning.dart';

class LeadDetailsPage extends StatefulWidget {
  final Leads lead;
  const LeadDetailsPage({super.key, required this.lead});

  @override
  State<LeadDetailsPage> createState() => _LeadDetailsPageState();
}

class _LeadDetailsPageState extends State<LeadDetailsPage> {
  // ✅ Use the dedicated planning storage
  final FlutterSecureStorage _storage = AppStorage.planningStorage;

  String? _planningId;
  bool _isCheckingPlanning = true;

  @override
  void initState() {
    super.initState();
    _checkExistingPlanning();
  }

  // ✅ Check if planning already exists in storage
  Future<void> _checkExistingPlanning() async {
    try {
      final key = 'planning_${widget.lead.leadName?.trim().toLowerCase()}';
      final storedPlanningId = await _storage.read(key: key);

      setState(() {
        _planningId = storedPlanningId;
        _isCheckingPlanning = false;
      });

      debugPrint("Loaded planning_id from storage: $storedPlanningId");
    } catch (e) {
      debugPrint("Error checking planning: $e");
      setState(() {
        _isCheckingPlanning = false;
      });
    }
  }

  // ✅ Save planning ID to storage
  Future<void> _savePlanningId(String planningId) async {
    try {
      final key = 'planning_${widget.lead.leadName?.trim().toLowerCase()}';
      await _storage.write(key: key, value: planningId);
      debugPrint("Saved planning_id to storage: $planningId");
    } catch (e) {
      debugPrint("Error saving planning: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Custom App Bar
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

            // ✅ Main Card
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
                          _buildInfoField('Lead Type', 'High [Hardcoded]'),
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

                          // ✅ Project Planning Button Logic
                          if (widget.lead.status == "Converted")
                            Consumer<ProjectPlanningController>(
                              builder: (context, controller, child) {
                                // Loading while checking existing planning
                                if (_isCheckingPlanning) {
                                  return _buildLoadingButton();
                                }

                                // If planning exists
                                if (_planningId != null) {
                                  return _buildProjectCreatedCard(_planningId!);
                                }

                                // Otherwise show create button
                                return _buildCreateButton(controller);
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

  // ✅ Create Button Widget
  Widget _buildCreateButton(ProjectPlanningController controller) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: controller.isLoading
            ? null
            : () => _handleProjectPlanning(controller),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  // ✅ Existing Planning Card
  Widget _buildProjectCreatedCard(String planningId) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4CAF50), width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Project Created',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: $planningId',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Loading Button
  Widget _buildLoadingButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1C7690),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        ),
      ),
    );
  }

  // ✅ Handle Project Planning Creation
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
          await _savePlanningId(planningId);
          setState(() => _planningId = planningId);
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
        _showError('Failed to get planning ID');
      }
    } catch (e) {
      if (mounted) {
        if (e.toString().contains('already exists') ||
            e.toString().contains('duplicate')) {
          _showError(
            'Project planning already exists for this lead',
            isWarning: true,
          );
        } else {
          _showError('Error: ${e.toString()}');
        }
      }
    }
  }

  // ✅ Parse planning ID from response
  String? _extractPlanningId(String response) {
    try {
      final jsonResponse = json.decode(response);
      final planningId =
          jsonResponse['data']?['planning_id']?.toString() ??
          jsonResponse['data']?['name']?.toString() ??
          jsonResponse['planning_id']?.toString() ??
          jsonResponse['name']?.toString();

      debugPrint("Extracted planning_id: $planningId");
      return planningId;
    } catch (e) {
      debugPrint('Error parsing response: $e');
      return null;
    }
  }

  // ✅ SnackBar Error Helper
  void _showError(String message, {bool isWarning = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isWarning ? Colors.orange : Colors.red,
      ),
    );
  }

  // ✅ UI Helpers
  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildStatusField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4CAF50),
          ),
        ),
      ],
    );
  }
}
