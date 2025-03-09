import 'package:flutter/material.dart';
import 'package:zootopia/Hospital/FunctionsHospital/care_appbar.dart';
import 'package:zootopia/Hospital/LoginHospital.dart';
import 'package:zootopia/Hospital/approve_doctor.dart';
import 'package:zootopia/Hospital/session_hospital.dart';

class HospitalHome extends StatefulWidget {
  @override
  State<HospitalHome> createState() => _HospitalHomeState();
}

class _HospitalHomeState extends State<HospitalHome> {
  String _userEmail = "No Email Found";
  String _hospitalname = "No name";
  String _hospitalphoto = "";

  @override
  void initState() {
    super.initState();
    _loadUserSession();
  }

  Future<void> _loadUserSession() async {
    Map<String, dynamic>? hospitalDetails = await SessionHospital.getHospitalDetails();

    setState(() {
      _userEmail = hospitalDetails?['email'] ?? "No Email Found";
      _hospitalname = hospitalDetails?['hospitalname'] ?? "No Name";
      _hospitalphoto = hospitalDetails?['imageUrl'] ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: careAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),

            // Display Hospital Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[300],
              backgroundImage: _hospitalphoto.isNotEmpty ? NetworkImage(_hospitalphoto) : null,
              child: _hospitalphoto.isEmpty
                  ? Icon(Icons.medical_services, size: 50, color: Colors.blue)
                  : null,
            ),

            // SizedBox(height: 10),

            // Display Hospital Name
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  _hospitalname,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: [
                _buildFeatureTile(context, Icons.calendar_today, 'Manage Doctors', ApproveDoctorsPage()),
                // _buildFeatureTile(context, Icons.pets, 'View Registered Pets', '/viewPets'),
                // _buildFeatureTile(context, Icons.medical_services, 'Add Products', '/addProducts'),
                // _buildFeatureTile(context, Icons.person, 'Doctor Profiles', '/doctorProfiles'),
                // _buildFeatureTile(context, Icons.history, 'Patient History', '/patientHistory'),
                // _buildFeatureTile(context, Icons.notifications, 'Notifications', '/notifications'),
                // _buildFeatureTile(context, Icons.analytics, 'Reports & Analytics', '/reports'),
                // _buildFeatureTile(context, Icons.settings, 'Hospital Settings', '/settings'),
              ],
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () {
                SessionHospital.clearSession();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginHospital()),
                );
              },
              child: Text("Log Out"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile(BuildContext context, IconData icon, String title, Widget route) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => route,)),
      child: Card(
        margin: EdgeInsets.all(10),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.black),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
