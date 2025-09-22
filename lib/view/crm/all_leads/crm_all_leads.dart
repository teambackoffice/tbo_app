import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/all_lead_list_controller.dart';
import 'package:tbo_app/view/crm/all_leads/crm_leads_details.dart';

class CRMAllLeadsPage extends StatefulWidget {
  const CRMAllLeadsPage({super.key});

  @override
  State<CRMAllLeadsPage> createState() => _CRMAllLeadsPageState();
}

class _CRMAllLeadsPageState extends State<CRMAllLeadsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<AllLeadListController>(
        context,
        listen: false,
      ).fetchAllLeadList();
    });
  }

  // Helper method to get status color based on status string
  Color getStatusColor(String? status) {
    if (status == null) return Colors.grey;

    switch (status.toLowerCase()) {
      case 'open':
      case 'fresh':
        return Colors.blue;
      case 'replied':
      case 'working':
        return Colors.orange;
      case 'quotation':
      case 'proposal':
        return Colors.red;
      case 'interested':
        return Colors.amber;

      case 'converted':
      case 'won':
        return Colors.green;
      case 'Do not contact':
      case 'closed':
      default:
        return Colors.blue; // Default color
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        title: const Text(
          'All Leads',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AllLeadListController>(
        builder: (context, controller, child) {
          final leads = controller.allLeads?.data ?? [];
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.error != null) {
            return Center(child: Text('Error: ${controller.error}'));
          } else if (leads.isEmpty) {
            return const Center(child: Text('No leads available'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: leads.length,
            itemBuilder: (context, index) {
              final lead = leads[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < leads.length - 1 ? 12 : 0,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CRMLeadsDetails(leadId: lead.leadId),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: getStatusColor(lead.status),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              lead.status ?? 'Unknown',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            lead.companyName ?? 'Unknown Company',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                lead.territory ?? 'Unknown Location',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
