import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Model class for notifications
class NotificationModel {
  final String id; // Add ID for Firebase document reference
  final String title;
  final String body;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.isRead = false,
  });
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // To manage the future for fetching notifications
  late Future<List<NotificationModel>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _fetchNotifications(); // Initialize the notifications future
  }

  // Fetch notifications from Firestore
  Future<List<NotificationModel>> _fetchNotifications() async {
    List<NotificationModel> notifications = [];

    try {
      // Query notifications ordered by timestamp
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .get();

      print('Fetched ${snapshot.docs.length} notifications'); // Log the number of notifications

      for (var doc in snapshot.docs) {
        notifications.add(NotificationModel(
          id: doc.id, // Document ID for future reference
          title: doc['title'],
          body: doc['body'],
          isRead: doc['isRead'] ?? false, // Default to false if not set
        ));
      }
    } catch (e) {
      print('Error fetching notifications: $e'); // Log errors
    }

    return notifications;
  }

  // Mark a notification as read
  Future<void> _markAsRead(String notificationId) async {
    try {
      // Mark as read
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _notificationsFuture, // Use the future that updates on change
        builder: (BuildContext context, AsyncSnapshot<List<NotificationModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show loading indicator
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching notifications', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No notifications', style: TextStyle(color: Colors.white)));
          }

          final notifications = snapshot.data!;
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                leading: Icon(
                  notification.isRead ? Icons.mark_email_read : Icons.mark_email_unread,
                  color: notification.isRead ? Colors.green : Colors.red,
                ),
                title: Text(notification.title, style: const TextStyle(color: Colors.white)),
                subtitle: Text(notification.body, style: const TextStyle(color: Colors.white)),
                tileColor: Colors.grey[850],
                onTap: () async {
                  if (!notification.isRead) {
                    await _markAsRead(notification.id); // Mark as read but do not delete
                    setState(() {
                      // Trigger a rebuild to reflect the change
                      notifications[index] = NotificationModel(
                        id: notification.id,
                        title: notification.title,
                        body: notification.body,
                        isRead: true, // Update the read state
                      );
                    });
                  }
                },
              );
            },
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
