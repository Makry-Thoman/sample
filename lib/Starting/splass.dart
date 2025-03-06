import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zootopia/Hospital/Hospital_home.dart';
import 'package:zootopia/Hospital/session_hospital.dart';
import 'package:zootopia/Starting/userSelection.dart';
import 'package:zootopia/Users/Session.dart';
import 'package:zootopia/Users/bottomnavbar.dart';
class Splass extends StatefulWidget {
  const Splass({super.key});

  @override
  State<Splass> createState() => _SplassState();
}

class _SplassState extends State<Splass> {
  void initState() {
    super.initState();
    // Add a post-frame callback to delay the navigation to the next screen
    /* WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginForm()),
        );
      });
    });*/
    _checkSession();
  }


  // Check session and navigate accordingly
  // Check session and navigate accordingly
  Future<void> _checkSession() async {
    final userSession = await SessionUser.getSession();
    final hospitalSession = await SessionHospital.getSession();

    final bool isUserLoggedIn = userSession['uid'] != null;
    final bool isHospitalLoggedIn = hospitalSession['uid'] != null;

    // Delay for splash animation
    await Future.delayed(const Duration(seconds: 3));

    if (isUserLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Bottomnavbar()),
      );
    } else if (isHospitalLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HospitalHome()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Userselection()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
        body: Center(
      child: Lottie.asset("asset/Animation - 1737646946039.json")
    ));
  }
}
