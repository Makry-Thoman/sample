import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zootopia/function/AppbarZootioia.dart';

class MedicalRecordsPage extends StatefulWidget {
  final String petID;

  const MedicalRecordsPage({super.key, required this.petID});

  @override
  State<MedicalRecordsPage> createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage> {
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _treatmentController = TextEditingController();
  final TextEditingController _veterinarianController = TextEditingController();
  final TextEditingController _prescriptionController = TextEditingController();

  Future<void> _addMedicalRecord() async {
    String recordID = FirebaseFirestore.instance.collection('Pets details').doc(widget.petID).collection('medicalRecords').doc().id;

    await FirebaseFirestore.instance.collection('Pets details').doc(widget.petID).collection('medicalRecords').doc(recordID).set({
      'date': DateTime.now().toIso8601String(),
      'diagnosis': _diagnosisController.text,
      'treatment': _treatmentController.text,
      'veterinarian': _veterinarianController.text,
      'prescription': _prescriptionController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Medical Record Added!")));

    _diagnosisController.clear();
    _treatmentController.clear();
    _veterinarianController.clear();
    _prescriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: zootopiaAppBar(),
      body: Column(
        children: [
          // Form to Add New Record
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(controller: _diagnosisController, decoration: InputDecoration(labelText: "Diagnosis")),
                TextField(controller: _treatmentController, decoration: InputDecoration(labelText: "Treatment")),
                TextField(controller: _veterinarianController, decoration: InputDecoration(labelText: "Veterinarian")),
                TextField(controller: _prescriptionController, decoration: InputDecoration(labelText: "Prescription")),
                SizedBox(height: 10),
                ElevatedButton(onPressed: _addMedicalRecord, child: Text("Add Record")),
              ],
            ),
          ),

          // Display Existing Records
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Pets details').doc(widget.petID).collection('medicalRecords').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                var records = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    var record = records[index];
                    return ListTile(
                      title: Text(record['diagnosis']),
                      subtitle: Text("Treatment: ${record['treatment']}"),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
