import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageDoctorTimings extends StatefulWidget {
  @override
  _ManageDoctorTimingsState createState() => _ManageDoctorTimingsState();
}

class _ManageDoctorTimingsState extends State<ManageDoctorTimings> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<void> updateDoctorTiming(String doctorId) async {
    List<String> selectedDays = [];
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    // Select working days
    List<String> allDays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];

    bool confirmDays = await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Select Working Days"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: allDays.map((day) {
                  return CheckboxListTile(
                    title: Text(day),
                    value: selectedDays.contains(day),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedDays.add(day);
                        } else {
                          selectedDays.remove(day);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text("Confirm"),
                ),
              ],
            );
          },
        );
      },
    ) ?? false;

    if (!confirmDays || selectedDays.isEmpty) return;

    // Select start time
    startTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 0),
    );
    if (startTime == null) return;

    // Select end time
    endTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 17, minute: 0),
    );
    if (endTime == null) return;

    String formattedStartTime = DateFormat.jm().format(
      DateTime(0, 0, 0, startTime.hour, startTime.minute),
    );
    String formattedEndTime = DateFormat.jm().format(
      DateTime(0, 0, 0, endTime.hour, endTime.minute),
    );

    setState(() {
      isLoading = true;
    });

    String hospitalId = _auth.currentUser!.uid;

    await _firestore
        .collection('Hospital')
        .doc(hospitalId)
        .collection('doctors')
        .doc(doctorId)
        .update({
      'defaultSchedule.workingDays': selectedDays,
      'defaultSchedule.startTime': formattedStartTime,
      'defaultSchedule.endTime': formattedEndTime,
    });

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Doctor schedule updated successfully!')),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Set Doctor Timings')),
      body: Stack(
        children: [
          StreamBuilder(
            stream: _firestore.collection('Hospital')
                .doc(_auth.currentUser!.uid)
                .collection('doctors')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No doctors assigned to this hospital'));
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doctor = snapshot.data!.docs[index];
                  var doctorData = doctor.data() as Map<String, dynamic>;

                  var defaultSchedule = doctorData['defaultSchedule'] ?? {
                    'workingDays': ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
                    'startTime': '09:00 AM',
                    'endTime': '05:00 PM',
                  };

                  List<String> leaves = List<String>.from(doctorData['leaves'] ?? []);

                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctorData['doctorname'] ?? 'Unknown Doctor',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            doctorData['specialization'] ?? 'Specialization Unknown',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Default Schedule:",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${defaultSchedule['workingDays'].join(', ')}",
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                          Text(
                            "Timing: ${defaultSchedule['startTime']} - ${defaultSchedule['endTime']}",
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.schedule),
                              label: Text("Change Timing"),
                              onPressed: () => updateDoctorTiming(doctor.id),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
