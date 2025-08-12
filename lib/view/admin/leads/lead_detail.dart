import 'package:flutter/material.dart';

class LeadDetailsScreen extends StatelessWidget {
  const LeadDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F1), // Light beige background
      body: SafeArea(
        child: Column(
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, size: 16),
                  ),
                ),
              ),
            ),

            // Card Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Closed",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Title & Location
                      const Text(
                        "Calicut Textiles",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            "Calicut",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Name
                      const Text("John", style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 14),

                      // Email
                      const Text(
                        "john@gmail.com",
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 14),

                      // Phone
                      const Text(
                        "+91 8192 838 271",
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 12),

                      // Lead Source
                      Row(
                        children: [
                          const Text(
                            "Lead Source",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(width: 18),
                          const Text("Website", style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Description
                      const Text(
                        "Lorem ipsum dolor sit amet consectetur. "
                        "Cum ac viverra euismod volutpat scelerisque porttitor. "
                        "Nibh id dui tortor cras. Eget arcu tellus arcu tempus bibendum. "
                        "At aliquam scelerisque vitae lectus phasellus mollis. "
                        "Morbi vitae aliquet urna fames metus ornare.",
                        style: TextStyle(fontSize: 14, height: 1.4),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
