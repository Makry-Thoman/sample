import 'package:flutter/material.dart';
import 'package:zootopia/Hospital/LoginHospital.dart';
import 'package:zootopia/Login_Page.dart';
import 'package:zootopia/Starting/Session.dart';
import 'package:zootopia/function/AppbarZootioia.dart';
class HospitalHome extends StatefulWidget {
  const HospitalHome({super.key});

  @override
  State<HospitalHome> createState() => _HospitalHomeState();
}

class _HospitalHomeState extends State<HospitalHome> {
  String _userEmail="No Email Found";
  String _hospitalname="No name";
  String _hospitalphoto="";
  @override
  void initState() {
    super.initState();
    _loadUserSession();
  }


  Future<void> _loadUserSession() async {
    Map<String, dynamic>? HospitalDetails = await Session.getHospitalDetails();

    setState(() {
      _userEmail = HospitalDetails?['email']  ;
      _hospitalname= HospitalDetails?['Hospitalname'];
      _hospitalphoto=HospitalDetails?['imageUrl'];
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: zootopiaAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _hospitalphoto.isNotEmpty
                  ? NetworkImage(_hospitalphoto)
                  : null, // If no photo, show the icon
              backgroundColor: Colors.grey[300],
              child: _hospitalphoto.isEmpty
                  ? Icon(Icons.medical_services, size: 40, color: Colors.blue)
                  : null, // Only show icon if no image
            ),
            Text(_userEmail),
            Text(_hospitalname),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    foregroundColor: MaterialStateProperty.all(Colors.white)
                ),
                onPressed: () {
                  Session.clearSession();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginHospital()));
                },
                child: Text("Log Out")
            ),
          ],
        ),
      ),
    );
  }
}
