import 'package:flutter/material.dart';
import 'package:zootopia/Starting/Session.dart';
import 'package:zootopia/Users/Login_Page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _userName;
  String? _userEmail;
  String? _userPhoto;
  bool _isLoading = true; // Added loading state

  @override
  void initState() {
    super.initState();
    _loadUserSession();
  }

  Future<void> _loadUserSession() async {
    Map<String, dynamic>? userDetails = await Session.getUserDetails();

    setState(() {
      _userName = userDetails?['name'] ?? "Unknown User";
      _userEmail = userDetails?['email'] ?? "No Email Found";
      _userPhoto =userDetails?['imageUrl']?? "No photo";
      _isLoading = false; // Set loading to false after fetching data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        toolbarHeight: 70,
        title: Image.asset('asset/ZootopiaAppWhite.png', height: 40),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : ListView(
        children: [
          Center(
            child: Column(
              children: [
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 100,
                  backgroundImage: _userPhoto != null && _userPhoto!.isNotEmpty
                      ? NetworkImage(_userPhoto!)
                      : null,
                  child: _userPhoto == null || _userPhoto!.isEmpty
                      ? Icon(Icons.person, size: 80, color: Colors.white)
                      : null,
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(_userName!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(_userEmail!, style: TextStyle(fontSize: 20)),
                      SizedBox(height: 200),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.black),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                        ),
                        onPressed: () {
                          Session.clearSession();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: Text("Log Out"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
