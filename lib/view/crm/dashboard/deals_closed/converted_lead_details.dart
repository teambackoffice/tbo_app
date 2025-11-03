import 'package:flutter/material.dart';
import 'package:tbo_app/modal/all_lead_list_modal.dart';

class ConvertedLeadDetails extends StatelessWidget {
  final Leads lead;

  const ConvertedLeadDetails({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Back button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Lead Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
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
                                  lead.status ?? "N/A",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.verified,
                                color: Colors.green.shade400,
                                size: 24,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            lead.leadName ?? "Unnamed Lead",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (lead.companyName != null &&
                              lead.companyName!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.business,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  lead.companyName!,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Contact Information
                    _buildSectionCard(
                      title: "Contact Information",
                      icon: Icons.contact_phone,
                      children: [
                        if (lead.emailId != null && lead.emailId!.isNotEmpty)
                          _buildInfoRow(
                            icon: Icons.email_outlined,
                            label: "Email",
                            value: lead.emailId!,
                            onTap: () {
                              // Add email action
                            },
                          ),
                        if (lead.mobileNo != null && lead.mobileNo!.isNotEmpty)
                          _buildInfoRow(
                            icon: Icons.phone_outlined,
                            label: "Mobile",
                            value: lead.mobileNo!,
                            onTap: () {
                              // Add call action
                            },
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Lead Information
                    _buildSectionCard(
                      title: "Lead Information",
                      icon: Icons.info_outline,
                      children: [
                        _buildInfoRow(
                          icon: Icons.badge_outlined,
                          label: "Lead ID",
                          value: lead.leadId ?? "N/A",
                        ),
                        _buildInfoRow(
                          icon: Icons.person_outline,
                          label: "Lead Owner",
                          value: lead.leadOwner ?? "N/A",
                        ),
                        _buildInfoRow(
                          icon: Icons.source_outlined,
                          label: "Source",
                          value: lead.source ?? "N/A",
                        ),
                        if (lead.campaignName != null &&
                            lead.campaignName.toString().isNotEmpty)
                          _buildInfoRow(
                            icon: Icons.campaign_outlined,
                            label: "Campaign",
                            value: lead.campaignName.toString(),
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Business Details
                    _buildSectionCard(
                      title: "Business Details",
                      icon: Icons.business_center_outlined,
                      children: [
                        if (lead.territory != null &&
                            lead.territory!.isNotEmpty)
                          _buildInfoRow(
                            icon: Icons.location_on_outlined,
                            label: "Territory",
                            value: lead.territory!,
                          ),
                        if (lead.marketSegment != null &&
                            lead.marketSegment!.isNotEmpty)
                          _buildInfoRow(
                            icon: Icons.pie_chart_outline,
                            label: "Market Segment",
                            value: lead.marketSegment!,
                          ),
                        if (lead.customLeadSegment != null &&
                            lead.customLeadSegment!.isNotEmpty)
                          _buildInfoRow(
                            icon: Icons.category_outlined,
                            label: "Lead Segment",
                            value: lead.customLeadSegment!,
                          ),
                        if (lead.customProjectType != null &&
                            lead.customProjectType!.isNotEmpty)
                          _buildInfoRow(
                            icon: Icons.work_outline,
                            label: "Project Type",
                            value: lead.customProjectType!,
                          ),
                      ],
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

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: Colors.grey.shade700),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey.shade400,
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    switch (status.toLowerCase()) {
      case 'converted':
        return Colors.green;
      case 'lead':
        return Colors.blue;
      case 'open':
        return Colors.orange;
      case 'replied':
        return Colors.purple;
      case 'opportunity':
        return Colors.teal;
      case 'quotation':
        return Colors.indigo;
      case 'lost quotation':
        return Colors.red;
      case 'interested':
        return Colors.amber;
      case 'do not contact':
        return Colors.grey.shade700;
      default:
        return Colors.grey;
    }
  }
}
