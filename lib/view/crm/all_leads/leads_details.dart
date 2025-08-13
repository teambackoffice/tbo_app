import 'package:flutter/material.dart';

class CRMLeadsDetails extends StatelessWidget {
  const CRMLeadsDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with back arrow
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.arrow_back_ios, color: Colors.grey[600], size: 20),
                ],
              ),
            ),

            // Main content card
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Proposal Sent badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9500),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Proposal Sent',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Company name
                    const Text(
                      'Calicut Textiles',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Calicut',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Contact name
                    const Text(
                      'John',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Email
                    Text(
                      'john@gmail.com',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),

                    const SizedBox(height: 12),

                    // Phone
                    Text(
                      '+91 8192 838 271',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),

                    const SizedBox(height: 20),

                    // Lead Source section
                    Row(
                      children: [
                        Text(
                          'Lead Source',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Website',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Description
                    Text(
                      'Lorem ipsum dolor sit amet consectetur. Cum ac viverra euismod volutpat scelerisque porttitor. Nibh id dui tortor cras. Eget arcu tellus arcu tempus bibendum. At aliquam scelerisque vitae lectus phasellus mollis. Morbi vitae aliquet urna fames metus ornare.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
