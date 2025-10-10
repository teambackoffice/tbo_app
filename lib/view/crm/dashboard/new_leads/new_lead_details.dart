import 'package:flutter/material.dart';
import 'package:tbo_app/modal/all_lead_list_modal.dart';

class LeadDetailPage extends StatelessWidget {
  final Leads lead;

  const LeadDetailPage({super.key, required this.lead});

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

            // Scrollable Content
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        lead.status ?? "Unknown",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Lead Name
                    Text(
                      lead.leadName ?? "N/A",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Contact Information Section
                    _buildSectionTitle("Contact Information"),
                    const SizedBox(height: 12),
                    _buildInfoCard([
                      _buildInfoRow(
                        Icons.business,
                        "Company",
                        lead.companyName ?? "N/A",
                      ),
                      _buildInfoRow(
                        Icons.email_outlined,
                        "Email",
                        lead.emailId ?? "N/A",
                      ),
                      _buildInfoRow(
                        Icons.phone_outlined,
                        "Mobile",
                        lead.mobileNo ?? "N/A",
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // Lead Information Section
                    _buildSectionTitle("Lead Information"),
                    const SizedBox(height: 12),
                    _buildInfoCard([
                      _buildInfoRow(
                        Icons.person_outline,
                        "Lead Owner",
                        lead.leadOwner ?? "N/A",
                      ),
                      _buildInfoRow(
                        Icons.source_outlined,
                        "Source",
                        lead.source ?? "N/A",
                      ),
                      _buildInfoRow(
                        Icons.campaign_outlined,
                        "Campaign",
                        lead.campaignName?.toString() ?? "N/A",
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // Business Details Section
                    _buildSectionTitle("Business Details"),
                    const SizedBox(height: 12),
                    _buildInfoCard([
                      _buildInfoRow(
                        Icons.location_on_outlined,
                        "Territory",
                        lead.territory ?? "N/A",
                      ),
                      _buildInfoRow(
                        Icons.category_outlined,
                        "Market Segment",
                        lead.marketSegment ?? "N/A",
                      ),
                      _buildInfoRow(
                        Icons.interests_outlined,
                        "Lead Segment",
                        lead.customLeadSegment ?? "N/A",
                      ),
                      _buildInfoRow(
                        Icons.work_outline,
                        "Project Type",
                        lead.customProjectType ?? "N/A",
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showQuotationDialog(context);
                        },
                        icon: const Icon(Icons.description_outlined, size: 20),
                        label: const Text("Send Quotation"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1ABC9C),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1ABC9C)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'open':
      case 'new':
        return const Color(0xFF1ABC9C);
      case 'working':
      case 'contacted':
        return const Color(0xFF3498DB);
      case 'qualified':
        return const Color(0xFF9B59B6);
      case 'converted':
        return const Color(0xFF27AE60);
      case 'lost':
      case 'closed':
        return const Color(0xFFE74C3C);
      default:
        return const Color(0xFF95A5A6);
    }
  }

  void _showQuotationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1ABC9C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF1ABC9C),
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Send Quotation",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Are you sure you want to send a quotation to ${lead.leadName ?? 'this lead'}?",
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
                    _buildDialogInfoRow("Company", lead.companyName ?? "N/A"),
                    const SizedBox(height: 8),
                    _buildDialogInfoRow("Email", lead.emailId ?? "N/A"),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement quotation sending logic
                _showSuccessSnackbar(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1ABC9C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Send"),
            ),
          ],
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

  void _showSuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text("Quotation sent successfully!"),
          ],
        ),
        backgroundColor: const Color(0xFF1ABC9C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
