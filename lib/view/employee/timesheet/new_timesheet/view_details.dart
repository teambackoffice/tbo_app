import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tbo_app/modal/timesheet_modal.dart';

class ViewDetails extends StatelessWidget {
  final Datum? timesheetData;

  const ViewDetails({super.key, this.timesheetData});

  String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  String _formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'draft':
      case 'pending':
        return 'Send to Approval';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    // If no data is passed, show error state
    if (timesheetData == null) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          ),
          title: Text(
            'Timesheet Details',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              SizedBox(height: 16),
              Text(
                'No timesheet data available',
                style: TextStyle(
                  color: Colors.red[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final timesheet = timesheetData!;

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
              Text(
                timesheet.employeeName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 4),
              Text(timesheet.employee), // Employee ID

              const SizedBox(height: 4),
              const Text(
                "Date",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(timesheet.startDate),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),
              const Text(
                "Total Working Hours",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              Text(
                timesheet.totalHours.toStringAsFixed(3),
                style: const TextStyle(
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
              Text(
                _getStatusText(timesheet.status),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Time Logs :-",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),

              /// Timesheet List
              Expanded(
                child: timesheet.timeLogs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No time logs available',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: timesheet.timeLogs.length,
                        itemBuilder: (context, index) {
                          final timeLog = timesheet.timeLogs[index];
                          return TimesheetCard(
                            title: timeLog.task.isNotEmpty
                                ? timeLog.task
                                : timeLog.project,
                            description: timeLog.project,
                            fromTime: _formatTime(timeLog.fromTime),
                            toTime: _formatTime(timeLog.toTime),
                            totalHours:
                                "${timeLog.hours.toStringAsFixed(2)} Hr",
                            activityType: timeLog.activityType,
                            fullDescription: timeLog.description,
                          );
                        },
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
  final String activityType;
  final String fullDescription;

  const TimesheetCard({
    super.key,
    required this.title,
    required this.description,
    required this.fromTime,
    required this.toTime,
    required this.totalHours,
    required this.activityType,
    required this.fullDescription,
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
            if (activityType.isNotEmpty) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  activityType,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 6),
            const Text(
              "Total Working Hour:",
              style: TextStyle(
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
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "From time",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(fromTime, style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 12),
                const Text(
                  "To time",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(toTime, style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 12),
                const Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  fullDescription.isNotEmpty
                      ? fullDescription
                      : "No description provided",
                  style: const TextStyle(color: Colors.black54),
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
