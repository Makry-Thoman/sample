import 'package:flutter/material.dart';
import 'package:zootopia/Login_Page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  // Set your desired width (it should be equal to height for a perfect circle)
                  child: CircleAvatar(
                    radius: 140,
                    backgroundImage: AssetImage("asset/me.jpeg"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text("AKHIL ANTO",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text("akhilcanto@gmail.com",
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      Text("9539560783",
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 200),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.black),
                                foregroundColor: MaterialStateProperty.all(Colors.white)
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                            child: Text("Log Out")),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
