import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zootopia/Starting/Session.dart';
import 'package:zootopia/Users/Login_Page.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String? _userEmail = "Loading...";
  String? _userName = "User";
  String? _userPhoto;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    Map<String, dynamic>? userDetails = await Session.getUserDetails();

    setState(() {
      _userName = userDetails?['name'] ?? "Unknown User";
      _userEmail = userDetails?['email'] ?? "No Email Found";
      _userPhoto = userDetails?['imageUrl'] ?? "No photo";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_userName!),
            accountEmail: Text(_userEmail!),
            currentAccountPicture: CircleAvatar(
              backgroundImage: _userPhoto != null && _userPhoto!.isNotEmpty
                  ? NetworkImage(_userPhoto!)
                  : AssetImage("asset/kitty-cat-kitten-pet-45201.jpeg") as ImageProvider,
            ),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(30),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text(
              "Logout",
              style: TextStyle(color: Colors.black),
            ),
            onTap: () async {
              Session.clearSession();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
