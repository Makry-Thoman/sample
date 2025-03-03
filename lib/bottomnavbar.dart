import 'package:flutter/material.dart';
import 'package:zootopia/Pets%20Start%20-1.dart';
import 'package:zootopia/ShopingPage.dart';
import 'package:zootopia/Users/Pets.dart';
import 'package:zootopia/Users/QR.dart';
import 'package:zootopia/Users/QR_CODE.dart';
import 'package:zootopia/Users/qr_code_generator.dart';
import 'package:zootopia/profile_page.dart';class Bottomnavbar extends StatefulWidget {
  final int initialIndex;
  const Bottomnavbar({super.key, this.initialIndex = 0});

  @override
  State<Bottomnavbar> createState() => _BottomnavBarState();
}

class _BottomnavBarState extends State<Bottomnavbar> {
  late int _selectedindex;

  @override
  void initState() {
    super.initState();
    _selectedindex = widget.initialIndex; // Set the initial index
  }

  final List<Widget> _pages = [
    petsPage(),
    Product(),
    QRCode(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedindex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white60,
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Shopping'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
