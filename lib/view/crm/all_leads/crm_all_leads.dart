import 'package:flutter/material.dart';
import 'package:tbo_app/view/crm/all_leads/crm_leads_details.dart';

class Lead {
  final String status;
  final Color statusColor;
  final String companyName;
  final String location;

  const Lead({
    required this.status,
    required this.statusColor,
    required this.companyName,
    required this.location,
  });
}

class CRMAllLeadsPage extends StatelessWidget {
  const CRMAllLeadsPage({super.key});

  // Sample lead data
  final List<Lead> leads = const [
    Lead(
      status: 'Closed',
      statusColor: Color(0xFF4CAF50),
      companyName: 'Calicut Textiles',
      location: 'Calicut',
    ),
    Lead(
      status: 'Contacted',
      statusColor: Color(0xFF2196F3),
      companyName: 'Carry Fresh Hypermarket',
      location: 'Calicut',
    ),
    Lead(
      status: 'Proposal Sent',
      statusColor: Color(0xFFFF9800),
      companyName: 'Elham Digital',
      location: 'Calicut',
    ),
    Lead(
      status: 'Closed',
      statusColor: Color(0xFF4CAF50),
      companyName: 'Calicut Textiles',
      location: 'Calicut',
    ),
    Lead(
      status: 'Proposal Sent',
      statusColor: Color(0xFFFF9800),
      companyName: 'Calicut Textiles',
      location: 'Calicut',
    ),
  ];

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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: leads.length,
        itemBuilder: (context, index) {
          final lead = leads[index];
          return Padding(
            padding: EdgeInsets.only(bottom: index < leads.length - 1 ? 12 : 0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CRMLeadsDetails(),
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
                          color: lead.statusColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          lead.status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        lead.companyName,
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
                            lead.location,
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
      ),
    );
  }
}
