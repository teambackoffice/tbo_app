import 'package:flutter/material.dart';

// Simple Message model
class Message {
  final String id;
  final String content;
  final String senderName;
  final String senderRole; // 'admin' or 'crm'
  final DateTime timestamp;

  Message({
    required this.id,
    required this.content,
    required this.senderName,
    required this.senderRole,
    required this.timestamp,
  });
}

class CRMLeadsDetails extends StatefulWidget {
  const CRMLeadsDetails({super.key});

  @override
  State<CRMLeadsDetails> createState() => _CRMLeadsDetailsState();
}

class _CRMLeadsDetailsState extends State<CRMLeadsDetails> {
  final TextEditingController _messageController = TextEditingController();
  final String currentUserRole = 'crm'; // This is a CRM user screen
  final String currentUserName =
      'Mike (CRM)'; // This would come from your auth system

  final List<Message> _messages = [
    // Sample data - replace with API calls
    Message(
      id: '1',
      content: 'Please follow up with this client about the pricing proposal.',
      senderName: 'Sarah (Admin)',
      senderRole: 'admin',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Message(
      id: '2',
      content:
          'I called the client. They are interested but want to see a demo first.',
      senderName: 'Mike (CRM)',
      senderRole: 'crm',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Message(
      id: '3',
      content:
          'Great! Schedule the demo for next week and send calendar invite.',
      senderName: 'Sarah (Admin)',
      senderRole: 'admin',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  bool _showMessages = false;
  int _unreadCount = 1; // Count of unread admin messages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with back arrow
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(6), // space inside circle
                      decoration: const BoxDecoration(
                        color: Colors.white, // background color of circle
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                  ),
                ],
              ),
            ),

            // Main content card
            Expanded(
              child: SingleChildScrollView(
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

                      const SizedBox(height: 24),

                      // Admin Messages Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.message_outlined,
                                size: 18,
                                color: Colors.green[600],
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                "Admin Messages",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (_unreadCount > 0)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red[500],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '$_unreadCount',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showMessages = !_showMessages;
                                if (_showMessages) {
                                  _unreadCount = 0; // Mark as read when opened
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                _showMessages
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: Colors.green[600],
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Messages List (Expandable)
                      if (_showMessages) ...[
                        const SizedBox(height: 16),

                        // Messages Container
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[200]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              // Messages List
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(12),
                                  itemCount: _messages.length,
                                  itemBuilder: (context, index) {
                                    final message = _messages[index];
                                    return _buildMessageCard(message);
                                  },
                                ),
                              ),

                              // Message Input
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey[300]!,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: _messageController,
                                          decoration: const InputDecoration(
                                            hintText: 'Send update to admin...',
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          maxLines: null,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: _sendMessage,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.green[600],
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.send,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildMessageCard(Message message) {
    final isFromAdmin = message.senderRole == 'admin';
    final isCurrentUser = message.senderName.contains(
      currentUserName.split(' ')[0],
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 16,
            backgroundColor: isFromAdmin ? Colors.blue[600] : Colors.green[600],
            child: Icon(
              isFromAdmin ? Icons.admin_panel_settings : Icons.person,
              size: 14,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 8),

          // Message Bubble
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isFromAdmin ? Colors.blue[50] : Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isFromAdmin ? Colors.blue[200]! : Colors.green[200]!,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        message.senderName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      Row(
                        children: [
                          if (isCurrentUser)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'You',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          if (isCurrentUser) const SizedBox(width: 4),
                          Text(
                            _formatTimestamp(message.timestamp),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Message Content
                  Text(message.content, style: const TextStyle(fontSize: 13)),

                  // Admin Priority Tag
                  if (isFromAdmin)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'From Admin',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.orange[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _messageController.text.trim(),
      senderName: currentUserName,
      senderRole: currentUserRole,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(newMessage); // Add new message at the end
      _messageController.clear();
    });

    // TODO: Send message to API - this will notify admin
    // await ApiService.sendMessageFromCRMToAdmin(leadId, newMessage);

    // TODO: Send push notification to admin
    // await NotificationService.notifyAdmin(leadId, newMessage.content);
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
    _messageController.dispose();
    super.dispose();
  }
}
