// import 'package:acadami/notification.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// class Home extends StatefulWidget {
//   const Home({super.key});
//   @override
//   State<Home> createState() => _HomeState();
// }
// class _HomeState extends State<Home> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   @override
//   void initState() {
//     super.initState();
//     _requestPermissions();
//     _initializeNotifications();
//   }
//   void _initializeNotifications() async {
//     tz.initializeTimeZones();
//     const AndroidInitializationSettings androidInitSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//     final InitializationSettings initSettings = InitializationSettings(
//       android: androidInitSettings,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initSettings);
//   }
//   Future<bool> scheduleNotification(String vaccineName, DateTime date) async {
//     print('vaccineName: %%%%%%%%%%%%%$vaccineName');
//     print('Date: *****$date');
//     final notificationDetails = NotificationDetails(
//       android: AndroidNotificationDetails(
//         'vaccine_channel',
//
//         'Vaccination Reminders',
//         importance: Importance.high,
//         priority: Priority.high,
//       ),
//     );
//     int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//     try {
//       if (date.isBefore(DateTime.now())) {
//         print("Error: Selected date is in the past!");
//         return false;
//       }
//       final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
//         date.subtract(Duration(days: 1)),
//         tz.local,
//       );
//       print('Scheduled date: ****$scheduledDate');
//       if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
//         print("Error: Scheduled date is in the past!");
//         return false;
//       }
//       await flutterLocalNotificationsPlugin.zonedSchedule(
//         notificationId,
//         vaccineName,
//         'Your $vaccineName vaccination is scheduled for ${date.toLocal().toString().split(' ')[0]}!',
//         scheduledDate,
//         notificationDetails,
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime,
//       );
//       await FirebaseFirestore.instance.collection('vaccination_reminders').add({
//         'vaccine_name': vaccineName,
//         'date': date.toIso8601String(),
//         'scheduled_at': Timestamp.now(),
//       });
//       print("Vaccination reminder saved to Firebase!****");
//       return true;
//     } catch (e) {
//       print("Error scheduling notification: $e");
//       return false;
//     }
//   }
//   Future<void> _requestPermissions() async {
//
//     final androidPlugin =
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin
//     >();
//     if (androidPlugin != null) {
//       final bool? notificationGranted =
//       await androidPlugin.requestNotificationsPermission();
//       if (notificationGranted == false) {
//         print("Notification permission denied.");
//       }
//       final bool? exactAlarmGranted =
//       await androidPlugin.requestExactAlarmsPermission();
//       if (exactAlarmGranted == false) {
//         print("Exact alarms permission denied.");
//       }
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: nameController,
//                 decoration: InputDecoration(labelText: "Vaccine Name"),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter the vaccine name";
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: dateController,
//                 decoration: InputDecoration(
//                   labelText: "Vaccination Date",
//                   suffixIcon: Icon(Icons.calendar_today),
//
//                 ),
//                 readOnly: true,
//                 onTap: () async {
//                   DateTime now = DateTime.now();
//                   DateTime firstAllowedDate = now.add(Duration(days: 1));
//                   DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: firstAllowedDate,
//                     firstDate: firstAllowedDate,
//                     lastDate: DateTime(2101),
//                   );
//                   if (pickedDate != null) {
//                     setState(() {
//                       dateController.text =
//                       pickedDate.toLocal().toString().split(' ')[0];
//                     });
//                   }
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please select a date";
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: locationController,
//                 decoration: InputDecoration(labelText: "Location"),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter the location";
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     if (_formKey.currentState!.validate()) {
//                       String vaccineName = nameController.text;
//                       String vaccinationDate = dateController.text;
//                       DateTime selectedDate;
//                       try {
//                         selectedDate = DateTime.parse(vaccinationDate);
//                       } catch (e) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text("Invalid date format")),
//
//                         );
//                         return;
//                       }
//                       bool isSaved = await scheduleNotification(
//                         vaccineName,
//                         selectedDate,
//                       );
//                       if (isSaved) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                               "Vaccination details saved & notification set!",
//                             ),
//                           ),
//                         );
//                       }
//                       nameController.clear();
//                       dateController.clear();
//                       locationController.clear();
//                     }
//                   },
//                   child: Text("Save & Set Reminder"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zootopia/Users/sample2.dart';
// import 'chatScreen.dart';
class ChatList extends StatefulWidget {
  const ChatList({super.key});
  @override
  State<ChatList> createState() => _ChatListState();
}
class _ChatListState extends State<ChatList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String currentUserId;
  @override
  void initState() {
    super.initState();
    currentUserId = _auth.currentUser?.uid ?? "";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Users for Chat")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection("users")
            .where("uid", isNotEqualTo: currentUserId) // Exclude current user
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No users available"));
          }
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return ListTile(
                leading: CircleAvatar(child: Text(user["name"][0])), // Show first letter

                title: Text(user["name"]),
                subtitle: Text(user["email"]),
                onTap: () {
// Navigate to chat screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(user["uid"], user["name"]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}