import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 18,
              ),
              onPressed: () => Navigator.of(context).pop(),
              padding: const EdgeInsets.only(
                left: 4,
              ), // Adjust for visual centering
            ),
          ),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Today Section
          Center(
            child: const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Today',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          // Today's notifications
          _buildNotificationCard(
            name: 'Sabisha',
            message: 'assigned a new Task',
            avatarUrl:
                'https://images.unsplash.com/photo-1494790108755-2616b612b77c?w=150&h=150&fit=crop&crop=face',
            isToday: true,
          ),

          _buildNotificationCard(
            name: 'Saranya',
            message: 'approved your time request',
            avatarUrl:
                'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
            isToday: true,
          ),

          const SizedBox(height: 24),

          // Yesterday Section
          Center(
            child: const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Yesterday',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          // Yesterday's notifications
          _buildNotificationCard(
            name: 'Sabisha',
            message: 'assigned a new Task',
            avatarUrl:
                'https://images.unsplash.com/photo-1494790108755-2616b612b77c?w=150&h=150&fit=crop&crop=face',
            isToday: false,
          ),

          _buildNotificationCard(
            name: 'Saranya',
            message: 'approved your time request',
            avatarUrl:
                'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=150&h=150&fit=crop&crop=face',
            isToday: false,
          ),

          _buildNotificationCard(
            name: 'Saranya',
            message: 'approved your time request',
            avatarUrl:
                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
            isToday: false,
          ),

          _buildNotificationCard(
            name: 'Saranya',
            message: 'approved your time request',
            avatarUrl:
                'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
            isToday: false,
          ),

          _buildNotificationCard(
            name: 'Saranya',
            message: 'approved your time request',
            avatarUrl:
                'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
            isToday: false,
          ),

          _buildNotificationCard(
            name: 'Saranya',
            message: 'approved your time request',
            avatarUrl:
                'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
            isToday: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String name,
    required String message,
    required String avatarUrl,
    required bool isToday,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(avatarUrl),
            backgroundColor: Colors.grey[300],
            onBackgroundImageError: (_, __) {
              // Fallback if image fails to load
            },
            child: null,
          ),

          const SizedBox(width: 12),

          // Notification content
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: ' $message',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
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
}
