import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/leads_details_controller.dart';

// Simple Note model
class Note {
  final String id;
  final String message;
  final String authorName;
  final String authorRole; // 'admin' or 'crm'
  final DateTime timestamp;

  Note({
    required this.id,
    required this.message,
    required this.authorName,
    required this.authorRole,
    required this.timestamp,
  });
}

class LeadDetailsScreen extends StatefulWidget {
  final String? leadId; // Pass lead ID to fetch details
  const LeadDetailsScreen({super.key, this.leadId});

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<AllLeadsDetailsController>(
        context,
        listen: false,
      ).fetchLeadDetails(leadId: widget.leadId!);
    });
  }

  final TextEditingController _noteController = TextEditingController();
  final String currentUserRole =
      'admin'; // This would come from your auth system
  final String currentUserName =
      'Sarah (Admin)'; // This would come from your auth system

  final List<Note> _notes = [
    // Sample data - replace with API calls
    Note(
      id: '1',
      message:
          'Client seems interested in our premium package. Please follow up with pricing details.',
      authorName: 'Sarah (Admin)',
      authorRole: 'admin',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Note(
      id: '2',
      message: 'Received and understood. Will call them tomorrow morning.',
      authorName: 'Mike (CRM)',
      authorRole: 'crm',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Note(
      id: '3',
      message: 'Update: Client wants to schedule a demo for next week.',
      authorName: 'Mike (CRM)',
      authorRole: 'crm',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
  ];

  bool _showNotes = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F1),
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
              child: Consumer<AllLeadsDetailsController>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (provider.error != null) {
                    return Center(child: Text('Error: ${provider.error}'));
                  } else if (provider.leadDetails == null) {
                    return const Center(child: Text('Lead details not found'));
                  }
                  final lead = provider.leadDetails!.data;
                  return SingleChildScrollView(
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
                            child: Text(
                              lead.status,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Title & Location
                          Text(
                            lead.companyName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 4),
                              Text(
                                lead.territory,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Name
                          Text(lead.leadOwner, style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 14),

                          // Email
                          Text(lead.emailId, style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 14),

                          // Phone
                          Text(lead.phone, style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 12),

                          // Lead Source
                          Row(
                            children: [
                              const Text(
                                "Lead Source",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 18),
                              Text(lead.source, style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Description
                          const Text(
                            "Lorem ipsum dolor sit amet consectetur. "
                            "Cum ac viverra euismod volutpat scelerisque porttitor. "
                            "Nibh id dui tortor cras. Eget arcu tellus arcu tempus bibendum. "
                            "At aliquam scelerisque vitae lectus phasellus mollis. "
                            "Morbi vitae aliquet urna fames ornare.",
                            style: TextStyle(fontSize: 14, height: 1.4),
                          ),
                          const SizedBox(height: 20),

                          // Notes Section Toggle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.message_outlined,
                                    size: 18,
                                    color: Colors.blue[600],
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    "Team Communication",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (_notes.isNotEmpty)
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[100],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '${_notes.length}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue[800],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showNotes = !_showNotes;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    _showNotes
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: Colors.blue[600],
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Notes List (Expandable)
                          if (_showNotes) ...[
                            const SizedBox(height: 12),

                            // Admin can send notes to CRM
                            if (currentUserRole == 'admin') ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blue[200]!),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.admin_panel_settings,
                                          size: 16,
                                          color: Colors.blue[600],
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Send instruction to CRM team',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: _noteController,
                                      maxLines: 3,
                                      minLines: 1,
                                      decoration: const InputDecoration(
                                        hintText:
                                            'Type your message to CRM team...',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton.icon(
                                          onPressed: _addNote,
                                          icon: const Icon(
                                            Icons.send,
                                            size: 16,
                                          ),
                                          label: const Text('Send Message'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],

                            // CRM users see read-only view with info message
                            if (currentUserRole == 'crm') ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Messages from admin will appear here',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],

                            // Notes List (All notes visible to admin, only admin notes to CRM)
                            ...(_getVisibleNotes()).map(
                              (note) => _buildNoteCard(note),
                            ),
                          ],

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    final isFromAdmin = note.authorRole == 'admin';
    final isCurrentUser = note.authorName.contains(
      currentUserName.split(' ')[0],
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isFromAdmin ? Colors.blue[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isFromAdmin ? Colors.blue[200]! : Colors.green[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: isFromAdmin
                    ? Colors.blue[600]
                    : Colors.green[600],
                child: Icon(
                  isFromAdmin ? Icons.admin_panel_settings : Icons.person,
                  size: 12,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  note.authorName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              if (isCurrentUser)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'You',
                    style: TextStyle(fontSize: 9, color: Colors.black54),
                  ),
                ),
              const SizedBox(width: 8),
              Text(
                _formatTimestamp(note.timestamp),
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(note.message, style: const TextStyle(fontSize: 13)),
          if (isFromAdmin && currentUserRole == 'crm')
            Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Action Required',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.orange[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Filter notes based on user role
  List<Note> _getVisibleNotes() {
    if (currentUserRole == 'admin') {
      // Admin can see all notes
      return _notes;
    } else {
      // CRM can only see notes from admin
      return _notes.where((note) => note.authorRole == 'admin').toList();
    }
  }

  void _addNote() {
    if (_noteController.text.trim().isEmpty) return;

    // Only admin can send notes
    if (currentUserRole != 'admin') return;

    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: _noteController.text.trim(),
      authorName: currentUserName,
      authorRole: currentUserRole,
      timestamp: DateTime.now(),
    );

    setState(() {
      _notes.insert(0, newNote); // Add new note at the top
      _noteController.clear();
    });

    // TODO: Send note to API - this will notify CRM users
    // await ApiService.sendNoteFromAdminToCRM(leadId, newNote);

    // TODO: Send push notification to CRM users
    // await NotificationService.notifyCRMTeam(leadId, newNote.message);
  }

  // Filter notes based on user role

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
