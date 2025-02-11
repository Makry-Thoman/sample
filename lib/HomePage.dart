import 'package:flutter/material.dart';
import 'package:zootopia/MedicalHistory.dart';
import 'package:zootopia/Mypets.dart';
import 'package:zootopia/dogs.dart';
import 'package:zootopia/function/DrawerBar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isFABOpen = false;

  void _toggleFAB() {
    setState(() {
      _isFABOpen = !_isFABOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        toolbarHeight: 70,
        title: Image.asset('asset/ZootopiaAppWhite.png', height: 40),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.notifications),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("hi"),
                value: 1,
              )
            ],
          ),
        ],
      ),
      body: Dogs(),
      // Render the selected widget from _widgetOptions list

      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFAB,
        tooltip: 'Open Options',
        backgroundColor: Colors.black, // Stylish color
        child: Icon(
          _isFABOpen ? Icons.close : Icons.add,
          color: Colors.white, // Icon color for contrast
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      persistentFooterButtons: _isFABOpen
          ? [
              // Stylish button for "Add Pets"
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Mypets(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.black, minimumSize: Size(250, 55),
                    // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shadowColor: Colors.black.withOpacity(0.5),
                    elevation: 5,
                  ),
                  child: Text(
                    "Add Pets",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // Stylish button for "Add Records"
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Medicalhistory(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    minimumSize: Size(250, 55),
                    // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shadowColor: Colors.black.withOpacity(0.5),
                    elevation: 5,
                  ),
                  child: Text(
                    "Add Records",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ]
          : [],
    );
  }
}
