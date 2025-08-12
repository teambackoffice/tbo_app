import 'package:flutter/material.dart';

class CompletedDetails extends StatelessWidget {
  const CompletedDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5), // light cream background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  iconSize: 20,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Priority Chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C7690),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "High",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Title
                    const Text(
                      "Champion Car Wash App",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Time
                    Row(
                      children: const [
                        Icon(
                          Icons.access_time,
                          size: 18,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "Time",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text("18 Hours", style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 12),

                    // Due Date
                    Row(
                      children: const [
                        Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "Due Date",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text("15-07-25", style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 16),

                    // Description
                    const Text(
                      "The Champion Car Wash App is designed to streamline your vehicle cleaning experience.\n With just a few taps, you can book a wash, track service time, and receive timely updates.\n Our professional team ensures high-quality cleaning while you focus on your day. The app also helps you manage appointments, track past services, and enjoy exclusive offers.",
                      style: TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
