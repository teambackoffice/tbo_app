import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String? _planningId;

  @override
  void initState() {
    super.initState();
    _loadSavedPlanningId();
  }

  // ✅ Load saved planning id from local storage
  Future<void> _loadSavedPlanningId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Use lead name or a unique ID field instead of the object itself
      _planningId = prefs.getString("planning_${widget.lead.leadName}");
    });
  }

  // ✅ Save planning Id locally
  Future<void> _savePlanningId(String planningId) async {
    final prefs = await SharedPreferences.getInstance();
    // Use the same key pattern
    await prefs.setString("planning_${widget.lead.leadName}", planningId);
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
                          _buildInfoField(
                            'Project Type',
                            widget.lead.customProjectType ?? 'N/A',
                          ),
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
                          _buildStatusField(
                            'Status',
                            widget.lead.status ?? 'N/A',
                          ),
                          const SizedBox(height: 50),

                          // ✅ Project Planning Button Logic
                          if (widget.lead.status == "Converted")
                            Consumer<ProjectPlanningController>(
                              builder: (context, controller, child) {
                                // ✅ If planning exists → show OPEN button
                                if (_planningId != null) {
                                  return _buildOpenContainer();
                                }
                                // ✅ If not exists → show CREATE button
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

  // ✅ Create Button UI
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

  // ✅ Open Button UI
  Widget _buildOpenContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFDFF5E1), // light green
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: const Center(
        child: Text(
          "Project Created",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  // ✅ Create planning → Save locally → Navigate
  Future<void> _handleProjectPlanning(
    ProjectPlanningController controller,
  ) async {
    try {
      String response = await controller.createProjectPlanning(
        planningName: widget.lead.leadName ?? '',
        leadSegment: widget.lead.customLeadSegment ?? '',
      );

      String? planningId = _extractPlanningId(response);

      if (planningId == null) {
        _showError("Failed to create project planning");
        return;
      }

      // ✅ Save planning ID locally
      await _savePlanningId(planningId);

      setState(() {
        _planningId = planningId;
      });

      // ✅ Navigate to project planning screen
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProjectPlanningScreen(lead: widget.lead, planningId: planningId),
        ),
      );
    } catch (e) {
      if (!mounted) return;

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

  // ✅ Parse planning ID from API response
  String? _extractPlanningId(String response) {
    try {
      final jsonResponse = json.decode(response);
      return jsonResponse['data']?['planning_id']?.toString() ??
          jsonResponse['data']?['name']?.toString() ??
          jsonResponse['planning_id']?.toString() ??
          jsonResponse['name']?.toString();
    } catch (e) {
      return null;
    }
  }

  // ✅ SnackBar helper
  void _showError(String message, {bool isWarning = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isWarning ? Colors.orange : Colors.red,
      ),
    );
  }

  // ✅ UI helper widgets
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
