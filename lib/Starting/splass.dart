import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zootopia/Hospital/Hospital_home.dart';
import 'package:zootopia/Login_Page.dart';
import 'package:zootopia/Pets%20Start%20-1.dart';
import 'package:zootopia/Starting/Session.dart';
import 'package:zootopia/Starting/userSelection.dart';
import 'package:zootopia/bottomnavbar.dart';
import 'package:zootopia/profile_page.dart';
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
  Future<void> _checkSession() async {
    final sessionData = await Session.getSession();
    final bool isLoggedIn = sessionData['uid'] != null;
    final String? Mode = sessionData['mode'];

    // Delay for splash animation
    await Future.delayed(const Duration(seconds: 3));

    // Navigate to Home if logged in, else Login
    if (isLoggedIn) {
      if(Mode == 'User') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Bottomnavbar()));
      }
      else if(Mode == 'Hospital')
      {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HospitalHome()));
      }

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
