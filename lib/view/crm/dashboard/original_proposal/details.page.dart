import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/all_lead_list_controller.dart';
import 'package:tbo_app/modal/all_lead_list_modal.dart';

class ProposalSentDetails extends StatelessWidget {
  final Leads lead;

  const ProposalSentDetails({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
            Container(
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
                    onPressed: () => _showConvertDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1ABC9C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Mark as Converted",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Convert Lead",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: Text(
            "Are you sure you want to mark '${lead.leadName}' as converted?",
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _handleConvert(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1ABC9C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text("Convert"),
            ),
          ],
        );
      },
    );
  }

  void _handleConvert(BuildContext context) {
    // TODO: Add your API call here to update the lead status
    // After successful conversion, refresh the list and go back

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${lead.leadName} marked as converted!"),
        backgroundColor: const Color(0xFF27AE60),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    // Refresh the lead list
    Provider.of<AllLeadListController>(
      context,
      listen: false,
    ).fetchAllLeadList(status: "Quotation");

    // Go back to previous screen
    Navigator.pop(context);
  }
}

class _InfoItem {
  final String label;
  final String? value;

  _InfoItem({required this.label, this.value});
}
