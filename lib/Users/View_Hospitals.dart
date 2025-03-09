import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zootopia/Users/List_Doctors_Users.dart';
import 'package:zootopia/Users/function/AppbarZootioia.dart';

class HospitalListScreen extends StatefulWidget {
  @override
  _HospitalListScreenState createState() => _HospitalListScreenState();
}

class _HospitalListScreenState extends State<HospitalListScreen> {
  String? selectedLocation;
  List<String> locations = [];
  List<Map<String, String>> hospitals = [];
  bool isLoading = false;
  bool isLoadingStates = true;

  @override
  void initState() {
    super.initState();
    fetchStates();
  }

  Future<void> fetchStates() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection("Hospital").get();

      Set<String> stateSet =
      querySnapshot.docs.map((doc) => doc["state"].toString()).toSet();

      setState(() {
        locations = stateSet.toList();
        isLoadingStates = false;
      });
    } catch (e) {
      print("Error fetching states: $e");
    }
  }

  Future<void> fetchHospitals(String location) async {
    setState(() {
      isLoading = true;
      hospitals.clear();
    });

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Hospital")
        .where("state", isEqualTo: location)
        .get();

    List<Map<String, String>> hospitalList = querySnapshot.docs.map((doc) {
      return {
        "id": doc.id,
        "name": doc["hospitalname"]?.toString() ?? "Unknown",
        "district": doc["district"]?.toString() ?? "Unknown",
        "description": doc["description"]?.toString() ?? "No description available",
        "imageUrl": doc["imageUrl"]?.toString() ?? "",
      };
    }).toList();

    setState(() {
      hospitals = hospitalList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: zootopiaAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            isLoadingStates
                ? Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Choose Location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
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
                  hospitals.clear();
                  fetchHospitals(value!);
                });
              },
            ),
            SizedBox(height: 20),

            Expanded(
              child: Stack(
                children: [
                  selectedLocation == null
                      ? Center(
                      child: Text('Select a location to see hospitals',
                          style: TextStyle(fontSize: 16)))
                      : ListView.builder(
                    itemCount: hospitals.length,
                    itemBuilder: (context, index) {
                      var hospital = hospitals[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DoctorListScreen(
                                    hospitalId: hospitals[index]['id']!,
                                  )));
                        },
                        child: Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    child: hospital["imageUrl"]!.isNotEmpty
                                        ? FadeInImage.assetNetwork(
                                      placeholder:
                                      "asset/Hospital/Loading_photo.png",
                                      image: hospital["imageUrl"]!,
                                      width: 120,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      imageErrorBuilder: (context,
                                          error, stackTrace) =>
                                          Icon(Icons.broken_image,
                                              size: 50,
                                              color: Colors.grey),
                                    )
                                        : Image.asset(
                                      "asset/Hospital/no_image.png",
                                      width: 120,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          hospital['name']!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          hospital['district']!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          hospital['description']!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Align(
                                          alignment:
                                          Alignment.centerRight,
                                          child: IconButton(
                                            icon: Icon(Icons.info_outline,
                                                color: Colors.blue),
                                            onPressed: () {
                                              // Navigate to details page
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      );
                    },
                  ),
                  if (isLoading)
                    Center(
                      child: Container(
                        color: Colors.white.withOpacity(0.8),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}