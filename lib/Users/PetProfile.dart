import 'package:flutter/material.dart';
import 'package:zootopia/Users/MedicalRecordsScreen.dart';
import 'package:zootopia/Users/User_Controller/Pet_Contoller.dart';
import 'package:zootopia/Users/VaccinationScreen.dart';
import 'package:zootopia/function/AppbarZootioia.dart';

class PetProfile extends StatefulWidget {
  const PetProfile({super.key, required this.PetID});

  final String PetID;

  @override
  State<PetProfile> createState() => _PetProfileState();
}

class _PetProfileState extends State<PetProfile> {
  String? _petName;
  String? _petPhoto;

  @override
  void initState() {
    super.initState();
    fetchPetInfo();
  }

  void fetchPetInfo() async {
    Map<String, dynamic>? petData = await getPetDetails(widget.PetID);

    setState(() {
      _petName = petData?['petName'] ?? "Unknown Pet";
      _petPhoto = petData?['imageUrl'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: zootopiaAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _petPhoto != null && _petPhoto!.isNotEmpty
                    ? NetworkImage(_petPhoto!)
                    : AssetImage("asset/a.png") as ImageProvider,
              ),
              GestureDetector(
                onTap: () {
                  // Add logic to update pet photo
                },
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.camera_alt, size: 18, color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _petName ?? "Loading...",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _actionButton("Add", Icons.add, () {
                // Navigate to Add Pet screen
              }),
              _actionButton("Edit", Icons.edit, () {
                // Navigate to Edit Pet screen
              }),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _gridItem("Vaccination", Icons.medical_services, VaccinationScreen()),
                _gridItem("Medical Records", Icons.book, MedicalRecordsScreen()),
                // _gridItem("Reminders", Icons.notifications, RemindersScreen()),
                // _gridItem("Weight", Icons.monitor_weight, WeightScreen()),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: "Pets"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendar"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Records"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  Widget _actionButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            CircleAvatar(
              radius: 20,
              child: Icon(icon, size: 20),
            ),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _gridItem(String label, IconData icon, Widget destinationScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
