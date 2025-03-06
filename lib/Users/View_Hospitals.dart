import 'package:flutter/material.dart';
import 'package:zootopia/function/AppbarZootioia.dart';

void main() {
  runApp(MaterialApp(
    home: HospitalListScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class HospitalListScreen extends StatefulWidget {
  @override
  _HospitalListScreenState createState() => _HospitalListScreenState();
}

class _HospitalListScreenState extends State<HospitalListScreen> {
  String? selectedLocation;
  List<String> locations = ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Miami'];

  Map<String, List<Map<String, String>>> hospitalsByLocation = {
    'New York': [
      {'name': 'NY Pet Care', 'address': '123 Manhattan St.', 'description': '24/7 emergency pet care.'},
      {'name': 'Big Apple Vet Clinic', 'address': '456 Brooklyn Ave.', 'description': 'Specialists in exotic animals.'},
    ],
    'Los Angeles': [
      {'name': 'LA Pet Wellness', 'address': '789 Sunset Blvd.', 'description': 'Comprehensive pet care services.'},
      {'name': 'Hollywood Vet Center', 'address': '321 Vine St.', 'description': 'Affordable and reliable pet treatments.'},
    ],
    'Chicago': [
      {'name': 'Windy City Vet', 'address': '654 Lakeshore Dr.', 'description': 'Caring for pets with love and expertise.'},
    ],
    'Houston': [
      {'name': 'Texas Pet Med', 'address': '987 Lone Star Rd.', 'description': 'Advanced treatments for all pets.'},
    ],
    'Miami': [
      {'name': 'Sunny Paws Clinic', 'address': '741 Ocean Dr.', 'description': 'Beachside veterinary services.'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: zootopiaAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Choose Location',
                border: OutlineInputBorder(),
              ),
              value: selectedLocation,
              items: locations.map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedLocation = value;
                });
              },
            ),
            SizedBox(height: 20),
            selectedLocation == null
                ? Text('Select a location to see hospitals')
                : Expanded(
              child: ListView.builder(
                itemCount: hospitalsByLocation[selectedLocation]?.length ?? 0,
                itemBuilder: (context, index) {
                  var hospital = hospitalsByLocation[selectedLocation]![index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(hospital['name']!, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${hospital['address']}\n${hospital['description']}'),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
