import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorMarkLeave extends StatefulWidget {
  final String hospitalId; // Get hospital ID from previous page

  DoctorMarkLeave({required this.hospitalId});

  @override
  _DoctorMarkLeaveState createState() => _DoctorMarkLeaveState();
}

class _DoctorMarkLeaveState extends State<DoctorMarkLeave> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<void> markLeave() async {
    String doctorId = _auth.currentUser!.uid;
    List<String> selectedLeaveDates = [];
    bool addMoreLeaves = true;

    while (addMoreLeaves) {
      DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)),
      );

      if (selectedDate == null) break;

      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      selectedLeaveDates.add(formattedDate);

      addMoreLeaves = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Add more leave dates?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("No"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("Yes"),
            ),
          ],
        ),
      ) ??
          false;
    }

    if (selectedLeaveDates.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('Hospital')
        .doc(widget.hospitalId) // Use the passed hospitalId
        .collection('doctors')
        .doc(doctorId)
        .update({
      'leaves': FieldValue.arrayUnion(selectedLeaveDates),
    });

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Leave marked successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mark Leave')),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: markLeave,
          child: Text('Select Leave Dates'),
        ),
      ),
    );
  }
}
