import 'package:flutter/material.dart';
import 'package:zootopia/dogs.dart';
class Dogandcats extends StatefulWidget {
  const Dogandcats({super.key});

  @override
  State<Dogandcats> createState() => _DogandcatsState();
}

class _DogandcatsState extends State<Dogandcats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Dogs()
        ],
      ),
    );
  }
}
