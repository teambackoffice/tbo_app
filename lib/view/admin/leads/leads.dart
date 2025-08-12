import 'package:flutter/material.dart';

class AdminLeads extends StatelessWidget {
  const AdminLeads({super.key});

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    switch (status.toLowerCase()) {
      case 'closed':
        backgroundColor = const Color(0xFF27AE60);
        break;
      case 'contacted':
        backgroundColor = const Color(0xFF3B5998);
        break;
      case 'proposal sent':
        backgroundColor = const Color(0xFFF39C12);
        break;
      default:
        backgroundColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
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
    );
  }

  Widget _buildLeadCard(String companyName, String location, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildStatusBadge(status)],
            ),
            const SizedBox(height: 8),
            Text(
              companyName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30),
            const Text(
              'All Leads',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildLeadCard('Calicut Textiles', 'Calicut', 'Closed'),
                  _buildLeadCard(
                    'Carry Fresh Hypermarket',
                    'Kottakkal',
                    'Contacted',
                  ),
                  _buildLeadCard('Elham Digital', 'Calicut', 'Proposal Sent'),
                  _buildLeadCard('Calicut Textiles', 'Calicut', 'Closed'),
                  _buildLeadCard(
                    'Calicut Textiles',
                    'Calicut',
                    'Proposal Sent',
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
