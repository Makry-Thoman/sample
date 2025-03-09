import 'package:flutter/material.dart';
import 'package:zootopia/Doctor/Function_Doctor/doc_Appbar.dart';
import 'package:zootopia/Doctor/LoginDoctor.dart';
import 'package:zootopia/Doctor/session_Doctor.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DocAppBar(),
      body: ElevatedButton(style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
          onPressed: () {
            SessionDoctor.clearSession();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginDoctor()),
            );
          },
          child: Text("Log Out")),
    );
  }
}
