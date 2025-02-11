import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zootopia/Login_Page.dart';
import 'package:zootopia/Pets%20Start%20-1.dart';
import 'package:zootopia/bottomnavbar.dart';
class Splass extends StatefulWidget {
  const Splass({super.key});

  @override
  State<Splass> createState() => _SplassState();
}

class _SplassState extends State<Splass> {
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
    });
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
