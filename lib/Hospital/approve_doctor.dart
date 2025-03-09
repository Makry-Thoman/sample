import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ApproveDoctorsPage extends StatefulWidget {
  @override
  _ApproveDoctorsPageState createState() => _ApproveDoctorsPageState();
}

class _ApproveDoctorsPageState extends State<ApproveDoctorsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<QueryDocumentSnapshot>> getDoctorRequests() async {
    String hospitalId = _auth.currentUser!.uid; // Assuming hospital admin is logged in
    var snapshot = await _firestore
        .collection('DoctorRequests')
        .where('hospitalId', isEqualTo: hospitalId)
        .where('status', isEqualTo: 'pending')
        .get();
    return snapshot.docs;
  }

  void approveDoctor(String requestId, String doctorId, String hospitalId) async {
    await _firestore.collection('Doctors').doc(doctorId).update({
      'hospitalIds': FieldValue.arrayUnion([hospitalId]),
    });

    await _firestore.collection('Hospital').doc(hospitalId).update({
      'doctorIds': FieldValue.arrayUnion([doctorId]),
    });

    await _firestore.collection('DoctorRequests').doc(requestId).update({
      'status': 'approved',
    });
  }

  void rejectDoctor(String requestId) async {
    await _firestore.collection('DoctorRequests').doc(requestId).update({
      'status': 'rejected',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Approve Doctors')),
      body: FutureBuilder(
        future: getDoctorRequests(),
        builder: (context, AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return Center(child: Text('No pending requests'));
          }

          return ListView(
            children: snapshot.data!.map((request) {
              return ListTile(
                title: Text('Doctor ID: ${request['doctorId']}'),
                subtitle: Text('Status: ${request['status']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => approveDoctor(request.id, request['doctorId'], request['hospitalId']),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => rejectDoctor(request.id),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
