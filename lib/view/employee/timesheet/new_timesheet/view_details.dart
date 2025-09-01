import 'package:flutter/material.dart';

class ViewDetails extends StatelessWidget {
  const ViewDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Back Button
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Employee Info
              const Text(
                "Employee Name",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              const SizedBox(height: 4),
              const Text("TS251440"),

              const SizedBox(height: 4),
              const Text(
                "Date",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "28-08-2025",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),
              const Text(
                "Total Working Hour",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              const Text(
                "6.903",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),
              const Text(
                "Status",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Send to Approval",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Time Sheets :-",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),

              /// Timesheet List
              Expanded(
                child: ListView(
                  children: const [
                    TimesheetCard(
                      title: "Website Design",
                      description: "Onshore Website",
                      fromTime: "10:05 AM",
                      toTime: "12:10 PM",
                      totalHours: "2.05 Hr",
                    ),
                    TimesheetCard(
                      title: "App UI",
                      description: "TBO Task Management",
                      fromTime: "12:10 PM",
                      toTime: "13:10 PM",
                      totalHours: "1.00 Hr",
                    ),
                    TimesheetCard(
                      title: "App UI",
                      description: "TBO Task Management",
                      fromTime: "12:10 PM",
                      toTime: "13:10 PM",
                      totalHours: "1.00 Hr",
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

class TimesheetCard extends StatelessWidget {
  final String title;
  final String description;
  final String fromTime;
  final String toTime;
  final String totalHours;

  const TimesheetCard({
    super.key,
    required this.title,
    required this.description,
    required this.fromTime,
    required this.toTime,
    required this.totalHours,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        /// Collapsed State
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              "Total Working Hour:",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              totalHours,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.keyboard_arrow_down),

        /// Expanded Content
        childrenPadding: const EdgeInsets.all(8),
        children: [
          Align(
            alignment: Alignment.centerLeft, // 👈 forces content to the left
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("From time"),
                Text(
                  fromTime,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                const Text("To time"),
                Text(
                  toTime,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
