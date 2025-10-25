import 'package:flutter/material.dart';
import 'package:tbo_app/modal/get_employee_handover_modal.dart';

class HandoverDetailPage extends StatelessWidget {
  final Datum handoverItem;

  const HandoverDetailPage({super.key, required this.handoverItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Handover Details',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        elevation: 0,
        shadowColor: Colors.grey.withOpacity(0.1),
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Information Card
                  _buildTaskCard(),
                  const SizedBox(height: 16),

                  // Employee Transfer Card
                  _buildEmployeeTransferCard(),
                  const SizedBox(height: 16),

                  // Handover Details Card
                  _buildHandoverDetailsCard(),
                  const SizedBox(height: 16),

                  // Additional Information Card
                  _buildAdditionalInfoCard(),

                  // Notes Card (if available)
                  if (handoverItem.handoverNotes.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildNotesCard(),
                  ],

                  const SizedBox(height: 24),

                  // Action Buttons (if pending)
                  if (handoverItem.status.toLowerCase() == 'pending')
                    _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.assignment,
                  color: Colors.blue[600],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Task Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildDetailRow('Task', handoverItem.task, Icons.task_alt),
          if (handoverItem.taskSubject != null &&
              handoverItem.taskSubject!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildDetailRow(
              'Subject',
              handoverItem.taskSubject!,
              Icons.subject,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmployeeTransferCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.swap_horiz,
                  color: Colors.purple[600],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Employee Transfer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // From Employee
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.2), width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.person_outline, color: Colors.red[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FROM',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.red[700],
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        handoverItem.fromEmployeeName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        handoverItem.fromEmployee,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Arrow
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Icon(
                Icons.arrow_downward,
                color: Colors.grey[400],
                size: 28,
              ),
            ),
          ),

          // To Employee
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.green.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.person, color: Colors.green[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TO',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        handoverItem.toEmployeeName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        handoverItem.toEmployee,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandoverDetailsCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: Colors.orange[600],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Handover Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildDetailRow(
            'Handover Type',
            handoverItem.handoverType,
            Icons.category_outlined,
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            'Reason',
            handoverItem.handoverReason,
            Icons.description_outlined,
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            'Permanency',
            handoverItem.isPermanentHandover == 1
                ? 'Permanent Handover'
                : 'Temporary Handover',
            handoverItem.isPermanentHandover == 1
                ? Icons.lock_outline
                : Icons.access_time,
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.calendar_month,
                  color: Colors.teal[600],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildDetailRow(
            'Request Date',
            _formatDate(handoverItem.requestDate),
            Icons.calendar_today_outlined,
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Reference ID', handoverItem.name, Icons.tag),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    return _buildCard(
      color: Colors.amber[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notes, color: Colors.amber[700], size: 24),
              const SizedBox(width: 12),
              Text(
                'Handover Notes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.amber[900],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.amber.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              handoverItem.handoverNotes,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement accept functionality
              _showActionDialog(context, 'Accept', Colors.green);
            },
            icon: const Icon(Icons.check_circle_outline, size: 20),
            label: const Text('Accept'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement reject functionality
              _showActionDialog(context, 'Reject', Colors.red);
            },
            icon: const Icon(Icons.cancel_outlined, size: 20),
            label: const Text('Reject'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child, Color? color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.access_time;
      case 'completed':
      case 'accepted':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  void _showActionDialog(BuildContext context, String action, Color color) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('$action Handover'),
        content: Text(
          'Are you sure you want to $action this handover request?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement action
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Handover ${action.toLowerCase()}ed successfully',
                  ),
                  backgroundColor: color,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
            ),
            child: Text(action),
          ),
        ],
      ),
    );
  }
}
