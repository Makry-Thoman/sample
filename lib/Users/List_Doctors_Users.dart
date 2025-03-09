import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zootopia/Users/function/AppbarZootioia.dart';

class DoctorListScreen extends StatefulWidget {
  final String hospitalId;

  DoctorListScreen({required this.hospitalId});

  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  bool isLoading = false;
  List<Map<String, String>> doctors = [];

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    setState(() => isLoading = true);

    try {
      print("Fetching doctors for hospitalId: ${widget.hospitalId}");

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Hospital") // Go to Hospital collection
          .doc(widget.hospitalId) // Get specific hospital
          .collection("doctors") // Access nested doctors collection
          .get();

      List<Map<String, String>> doctorList = querySnapshot.docs.map((doc) {
        // Get data safely
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Extract timing details safely
        Map<String, dynamic>? timingData = data.containsKey("timing")
            ? data["timing"] as Map<String, dynamic>?
            : null;

        return {
          "doctorId": doc.id,
          "doctorname": data["doctorname"]?.toString() ?? "Unknown",
          "specialization": data["specialization"]?.toString() ?? "Not specified",
          "startTime": timingData?["start"]?.toString() ?? "Not Set",
          "endTime": timingData?["end"]?.toString() ?? "Not Set",
          "imageUrl": data.containsKey("imageUrl") ? data["imageUrl"].toString() : "", // Check if imageUrl exists
        };
      }).toList();

      setState(() {
        doctors = doctorList;
      });

      print("Doctors fetched successfully: ${doctors.length}");
    } catch (e) {
      print("Error fetching doctors: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: zootopiaAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Text(
            //   "Doctors at ${widget.hospitalName}",
            //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),
            SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : doctors.isEmpty
                  ? Center(child: Text("No doctors found."))
                  : ListView.builder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  var doctor = doctors[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: doctor["imageUrl"]!.isNotEmpty
                                ? FadeInImage.assetNetwork(
                              placeholder: "asset/Doctor/LoginDoc_white_bg.png",
                              image: doctor["imageUrl"]!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.broken_image, size: 50, color: Colors.grey),
                            )
                                : Image.asset(
                              "asset/Doctor/LoginDoc_white_bg.png", // Make sure path is correct
                              width: 100,
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
                                  doctor['doctorname']!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  doctor['specialization']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 5),
                                // Text(
                                //   "Experience: ${doctor['experience']} years",
                                //   style: TextStyle(
                                //     fontSize: 14,
                                //     color: Colors.grey[700],
                                //   ),
                                // ),
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: Icon(Icons.info_outline,
                                        color: Colors.blue),
                                    onPressed: () {
                                      // Navigate to doctor details page
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
