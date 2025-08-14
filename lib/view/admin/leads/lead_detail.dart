import 'package:flutter/material.dart';

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
  const LeadDetailsScreen({super.key});

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {
  final TextEditingController _noteController = TextEditingController();
  final List<Note> _notes = [
    // Sample data - replace with API calls
    Note(
      id: '1',
      message: 'Client seems interested in our premium package',
      authorName: 'Sarah (Admin)',
      authorRole: 'admin',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Note(
      id: '2',
      message: 'Scheduled follow-up call for tomorrow',
      authorName: 'Mike (CRM)',
      authorRole: 'crm',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
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
                              const Text(
                                "Team Notes",
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
                            child: Icon(
                              _showNotes
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                      // Notes List (Expandable)
                      if (_showNotes) ...[
                        const SizedBox(height: 12),

                        // Add Note Input
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            children: [
                              TextField(
                                controller: _noteController,
                                maxLines: 3,
                                minLines: 1,
                                decoration: const InputDecoration(
                                  hintText: 'Add a note...',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: _addNote,
                                    child: const Text('Add Note'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Notes List
                        ..._notes.map((note) => _buildNoteCard(note)),
                      ],

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

  Widget _buildNoteCard(Note note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: note.authorRole == 'admin'
            ? Color(0xFF3B5998).withOpacity(0.1)
            : Color(0xFFF39C12).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: note.authorRole == 'admin'
              ? Color(0xFF3B5998)
              : Color(0xFFF39C12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: note.authorRole == 'admin'
                    ? Colors.blue[600]
                    : Colors.green[600],
                child: Text(
                  note.authorName[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
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
              Text(
                _formatTimestamp(note.timestamp),
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(note.message, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  void _addNote() {
    if (_noteController.text.trim().isEmpty) return;

    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: _noteController.text.trim(),
      authorName: 'You (Admin)', // Replace with actual user info
      authorRole: 'admin', // Replace with actual user role
      timestamp: DateTime.now(),
    );

    setState(() {
      _notes.insert(0, newNote); // Add new note at the top
      _noteController.clear();
    });

    // TODO: Send note to API
    // await ApiService.addNote(leadId, newNote);
  }

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
