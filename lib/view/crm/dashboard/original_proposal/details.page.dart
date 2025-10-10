import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/all_lead_list_controller.dart';
import 'package:tbo_app/controller/edit_lead_controller.dart';
import 'package:tbo_app/modal/all_lead_list_modal.dart';

class ProposalSentDetails extends StatelessWidget {
  final Leads lead;

  const ProposalSentDetails({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditLeadController(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F7F3),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: Colors.black,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "Lead Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(lead.status),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          lead.status ?? "N/A",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Lead Information Card
                      _buildInfoCard(
                        context,
                        title: "Lead Information",
                        items: [
                          _InfoItem(label: "Lead Name", value: lead.leadName),
                          _InfoItem(label: "Company", value: lead.companyName),
                          _InfoItem(label: "Lead ID", value: lead.leadId),
                          _InfoItem(label: "Lead Owner", value: lead.leadOwner),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Contact Information Card
                      _buildInfoCard(
                        context,
                        title: "Contact Information",
                        items: [
                          _InfoItem(label: "Email", value: lead.emailId),
                          _InfoItem(label: "Mobile", value: lead.mobileNo),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Additional Details Card
                      _buildInfoCard(
                        context,
                        title: "Additional Details",
                        items: [
                          _InfoItem(label: "Source", value: lead.source),
                          _InfoItem(label: "Territory", value: lead.territory),
                          _InfoItem(
                            label: "Market Segment",
                            value: lead.marketSegment,
                          ),
                          _InfoItem(
                            label: "Lead Segment",
                            value: lead.customLeadSegment,
                          ),
                          _InfoItem(
                            label: "Project Type",
                            value: lead.customProjectType,
                          ),
                          _InfoItem(
                            label: "Campaign",
                            value: lead.campaignName?.toString(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              // Converted Button at Bottom
              Consumer<EditLeadController>(
                builder: (context, controller, child) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading
                              ? null
                              : () => _showConvertDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1ABC9C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: controller.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Mark as Converted",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
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
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required List<_InfoItem> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => _buildInfoRow(item.label, item.value)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value ?? "N/A",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'quotation':
        return const Color(0xFF1ABC9C);
      case 'converted':
        return const Color(0xFF27AE60);
      case 'open':
        return const Color(0xFF3498DB);
      case 'contacted':
        return const Color(0xFFF39C12);
      default:
        return Colors.grey;
    }
  }

  void _showConvertDialog(BuildContext context) {
    final controller = Provider.of<EditLeadController>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing during loading
      builder: (BuildContext dialogContext) {
        return Consumer<EditLeadController>(
          builder: (context, controller, child) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF27AE60).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF27AE60),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Convert Lead",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Are you sure you want to mark '${lead.leadName ?? 'this lead'}' as converted?",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F7F3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDialogInfoRow("Lead", lead.leadName ?? "N/A"),
                        const SizedBox(height: 8),
                        _buildDialogInfoRow(
                          "Company",
                          lead.companyName ?? "N/A",
                        ),
                        const SizedBox(height: 8),
                        _buildDialogInfoRow(
                          "Current Status",
                          lead.status ?? "N/A",
                        ),
                      ],
                    ),
                  ),
                  if (controller.isLoading) ...[
                    const SizedBox(height: 16),
                    const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF27AE60),
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: controller.isLoading
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: controller.isLoading
                      ? null
                      : () async {
                          // Call the API to update lead status
                          await controller.updateLeadStatus(
                            lead.leadId ?? "",
                            "Converted",
                          );

                          // Close the dialog
                          if (dialogContext.mounted) {
                            Navigator.pop(dialogContext);
                          }

                          // Check if the API call was successful
                          if (controller.message != null &&
                              controller.message!.contains("✅")) {
                            // Success - update local lead status
                            lead.status = "Converted";

                            // Refresh the lead list in background
                            Provider.of<AllLeadListController>(
                              context,
                              listen: false,
                            ).fetchAllLeadList(status: "Quotation");

                            // Show success message
                            if (context.mounted) {
                              _showSnackbar(
                                context,
                                "Lead successfully converted!",
                                true,
                              );
                            }

                            // Navigate back to previous page after short delay
                            await Future.delayed(
                              const Duration(milliseconds: 500),
                            );
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          } else {
                            // Failure - show error message only
                            if (context.mounted) {
                              _showSnackbar(
                                context,
                                "Failed to convert lead. Please try again.",
                                false,
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF27AE60),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Convert"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDialogInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  void _showSnackbar(BuildContext context, String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isSuccess ? const Color(0xFF27AE60) : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String? value;

  _InfoItem({required this.label, this.value});
}
