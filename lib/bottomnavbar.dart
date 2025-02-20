import 'package:flutter/material.dart';
import 'package:zootopia/Pets%20Start%20-1.dart';
import 'package:zootopia/ShopingPage.dart';
import 'package:zootopia/Users/Pets.dart';
import 'package:zootopia/Users/QR.dart';
import 'package:zootopia/Users/QR_CODE.dart';
import 'package:zootopia/Users/qr_code_generator.dart';
import 'package:zootopia/profile_page.dart';
class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavBarState();
}

class _BottomnavBarState extends State<Bottomnavbar> {
  int _selectedindex=0;

  final List<Widget> _pages = [
    petsPage(),
    Product(),
    QRCode(),
    const ProfilePage(),

  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedindex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedindex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey, Colors.black], // Adjust the gradient colors
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedindex,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.white60,
            backgroundColor: Colors.transparent, // Make the background transparent
            type: BottomNavigationBarType.fixed,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Shopping'),
              BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        )
    );
  }
}
