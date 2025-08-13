import 'package:flutter/material.dart';

class CRMAllLeadsPage extends StatelessWidget {
  const CRMAllLeadsPage({super.key});

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          LeadCard(
            status: 'Closed',
            statusColor: Color(0xFF4CAF50),
            companyName: 'Calicut Textiles',
            location: 'Calicut',
          ),
          SizedBox(height: 12),
          LeadCard(
            status: 'Contacted',
            statusColor: Color(0xFF2196F3),
            companyName: 'Carry Fresh Hypermarket',
            location: 'Calicut',
          ),
          SizedBox(height: 12),
          LeadCard(
            status: 'Proposal Sent',
            statusColor: Color(0xFFFF9800),
            companyName: 'Elham Digital',
            location: 'Calicut',
          ),
          SizedBox(height: 12),
          LeadCard(
            status: 'Closed',
            statusColor: Color(0xFF4CAF50),
            companyName: 'Calicut Textiles',
            location: 'Calicut',
          ),
          SizedBox(height: 12),
          LeadCard(
            status: 'Proposal Sent',
            statusColor: Color(0xFFFF9800),
            companyName: 'Calicut Textiles',
            location: 'Calicut',
          ),
        ],
      ),
    );
  }
}

class LeadCard extends StatelessWidget {
  final String status;
  final Color statusColor;
  final String companyName;
  final String location;

  const LeadCard({
    super.key,
    required this.status,
    required this.statusColor,
    required this.companyName,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              companyName,
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
                  location,
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
    );
  }
}
