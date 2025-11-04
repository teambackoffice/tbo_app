import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/leads_details_controller.dart';

class CRMLeadsDetails extends StatefulWidget {
  final String? leadId;
  const CRMLeadsDetails({super.key, required this.leadId});

  @override
  State<CRMLeadsDetails> createState() => _CRMLeadsDetailsState();
}

class _CRMLeadsDetailsState extends State<CRMLeadsDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AllLeadsDetailsController>(
        context,
        listen: false,
      ).fetchLeadDetails(leadId: widget.leadId!);
    });
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
      case 'fresh':
        return Colors.blueAccent;
      case 'replied':
      case 'working':
        return Colors.orangeAccent;
      case 'quotation':
      case 'proposal':
        return Colors.purpleAccent;
      case 'interested':
        return Colors.amber;
      case 'converted':
      case 'won':
        return Colors.green;
      case 'closed':
      case 'do not contact':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'open':
      case 'fresh':
        return Icons.refresh;
      case 'working':
        return Icons.work_outline;
      case 'quotation':
        return Icons.description_outlined;
      case 'interested':
        return Icons.star_outline;
      case 'converted':
      case 'won':
        return Icons.check_circle_outline;
      case 'closed':
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        title: const Text(
          'Lead Details',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AllLeadsDetailsController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.error != null) {
            return Center(child: Text('Error: ${controller.error}'));
          } else if (controller.leadDetails == null) {
            return const Center(child: Text('No lead details available'));
          }

          final lead = controller.leadDetails!.data;
          final statusColor = getStatusColor(lead.status);
          final statusIcon = getStatusIcon(lead.status);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status chip
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            statusColor.withOpacity(0.9),
                            statusColor.withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, color: Colors.white, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            lead.status.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Company Name
                  Text(
                    lead.companyName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Territory
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        lead.territory,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Divider
                  const Divider(height: 1, thickness: 0.6),

                  const SizedBox(height: 16),

                  // Contact Info Section
                  _infoRow(Icons.person_outline, "Lead Name", lead.leadName),
                  _infoRow(Icons.phone_outlined, "Mobile No", lead.mobileNo),
                  _infoRow(Icons.email_outlined, "Email ID", lead.emailId),
                  _infoRow(
                    Icons.business_outlined,
                    "Lead Owner",
                    lead.leadOwner,
                  ),

                  const SizedBox(height: 16),

                  const Divider(height: 1, thickness: 0.6),

                  const SizedBox(height: 16),

                  // Additional Details
                  const Text(
                    "Additional Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _infoRow(
                    Icons.category_outlined,
                    "Market Segment",
                    lead.marketSegment,
                  ),
                  _infoRow(Icons.source_outlined, "Lead Source", lead.source),
                  _infoRow(
                    Icons.layers_outlined,
                    "Lead Segment",
                    lead.customLeadSegment ?? "N/A",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: Colors.grey[700]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                Text(
                  value ?? "N/A",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
