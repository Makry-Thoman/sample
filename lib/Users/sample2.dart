// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// class Notifications extends StatefulWidget {
//   const Notifications({super.key});
//   @override
//   State<Notifications> createState() => _NotificationsState();
// }
// class _NotificationsState extends State<Notifications> {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   List<PendingNotificationRequest> _scheduledNotifications = [];
//   @override
//   void initState() {
//     super.initState();
//
//     _loadScheduledNotifications();
//   }
//   Future<void> _loadScheduledNotifications() async {
//     List<PendingNotificationRequest> pendingNotifications =
//     await flutterLocalNotificationsPlugin.pendingNotificationRequests();
//     setState(() {
//       _scheduledNotifications = pendingNotifications;
//     });
//     print(pendingNotifications);
//   }
//   Future<void> _deleteNotification(int notificationId, String vaccineName) async {
//     try {
// // Delete from local notifications
//       await flutterLocalNotificationsPlugin.cancel(notificationId);
// // Delete from Firebase Firestore
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('vaccination_reminders')
//           .where('vaccine_name', isEqualTo: vaccineName)
//           .get();
//       for (var doc in querySnapshot.docs) {
//         await doc.reference.delete();
//       }
//       print("Notification deleted: ID $notificationId, Vaccine: $vaccineName");
//       _loadScheduledNotifications(); // Refresh the list after deletion
//     } catch (e) {
//       print("Error deleting notification: $e");
//     }
//   }
//   Future<void> _deleteAllNotifications() async {
//     try {
// // Delete all scheduled notifications from local
//       await flutterLocalNotificationsPlugin.cancelAll();
// // Delete all vaccination reminders from Firebase
//       await FirebaseFirestore.instance.collection('vaccination_reminders').get().then((snapshot) {
//         for (DocumentSnapshot doc in snapshot.docs) {
//           doc.reference.delete();
//         }
//       });
//       print("All notifications deleted.");
//       _loadScheduledNotifications(); // Refresh the list
//     } catch (e) {
//
//       print("Error deleting all notifications: $e");
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Scheduled Notifications"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.delete_forever),
//             onPressed: _scheduledNotifications.isEmpty
//                 ? null
//                 : () => _deleteAllNotifications(), // Delete all notifications
//           ),
//         ],
//       ),
//       body: _scheduledNotifications.isEmpty
//           ? Center(child: Text("No scheduled notifications"))
//           : ListView.builder(
//         itemCount: _scheduledNotifications.length,
//         itemBuilder: (context, index) {
//           final notification = _scheduledNotifications[index];
//           return ListTile(
//             title: Text(notification.title ?? "No Title"),
//             subtitle: Text(notification.body ?? "No Body"),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text("ID: ${notification.id}"),
//                 IconButton(
//                   icon: Icon(Icons.delete, color: Colors.red),
//                   onPressed: () => _deleteNotification(notification.id, notification.title ?? ""),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ChatScreen extends StatefulWidget {
  final String userId;
  final String userName;
  ChatScreen(this.userId, this.userName, {super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String currentUserId;
  @override
  void initState() {
    super.initState();
    currentUserId = _auth.currentUser?.uid ?? "";
  }
  String _getChatRoomId(String user1, String user2) {
    List<String> users = [user1, user2]..sort(); // Ensure same ID for both users
    return users.join("_");
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    String chatRoomId = _getChatRoomId(currentUserId, widget.userId);
    await _firestore.collection("chat_rooms").doc(chatRoomId).collection("messages").add({
      "senderId": currentUserId,
      "message": _messageController.text.trim(),
      "timestamp": FieldValue.serverTimestamp(),
    });
    _messageController.clear();
  }
  Stream<QuerySnapshot> _getMessages() {
    String chatRoomId = _getChatRoomId(currentUserId, widget.userId);
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat with ${widget.userName}")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                var messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isMe = message["senderId"] == currentUserId;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),

                        ),
                        child: Text(
                          message["message"],
                          style: TextStyle(color: isMe ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}