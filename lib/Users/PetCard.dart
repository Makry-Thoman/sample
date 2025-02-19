// import 'package:flutter/material.dart';
//
// class PetCard extends StatelessWidget {
//   final String petName;
//   final String breed;
//   final String color;
//   final String dob;
//   final String gender;
//   final String petCategory;
//   final String imageUrl; // Image URL for pet photo
//
//   const PetCard({
//     Key? key,
//     required this.petName,
//     required this.breed,
//     required this.color,
//     required this.dob,
//     required this.gender,
//     required this.petCategory,
//     required this.imageUrl, // Added image
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       elevation: 5,
//       margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [     IconButton(
//               icon: Icon(Icons.edit, color: Colors.blue),
//               onPressed: () {
//                 // Add edit functionality here
//               },
//             ),
//               IconButton(
//                 icon: Icon(Icons.delete, color: Colors.red),
//                 onPressed: () {
//                   // Add delete functionality here
//                 },
//               ),],
//           ),
//           // Pet Image
//           ClipRRect(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
//             child:  CircleAvatar(
//               radius: 100,
//               backgroundImage: imageUrl.isNotEmpty
//                   ? NetworkImage(imageUrl)
//                   : null,
//               child: imageUrl.isEmpty
//                   ? Icon(Icons.person, size: 80, color: Colors.white)
//                   : null,
//             ),
//           ),
//
//           // Pet Info
//           Padding(
//             padding: const EdgeInsets.all(15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//
//                 Text(
//                   petName,
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 5),
//                 Text("🐕 Breed: $breed", style: TextStyle(fontSize: 16)),
//                 Text("🎨 Color: $color", style: TextStyle(fontSize: 16)),
//                 Text("📅 DOB: $dob", style: TextStyle(fontSize: 16)),
//                 Text("🚻 Gender: $gender", style: TextStyle(fontSize: 16)),
//                 Text("📌 Category: $petCategory", style: TextStyle(fontSize: 16)),
//                 SizedBox(height: 10),
//
//
//
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// model2
import 'package:flutter/material.dart';

class PetCard extends StatelessWidget {
  final String petName;
  final String breed;
  final String color;
  final String dob;
  final String gender;
  final String petCategory;
  final String imageUrl;

  const PetCard({
    Key? key,
    required this.petName,
    required this.breed,
    required this.color,
    required this.dob,
    required this.gender,
    required this.petCategory,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.cyan.shade100, Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Column(
              children: [
                // Pet Image
                ClipRRect(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/default_pet.png',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Pet Details
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        petName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text("🐕 Breed: $breed",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Text("🎨 Color: $color",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Text("📅 DOB: $dob",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Text("🚻 Gender: $gender",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Text("📌 Category: $petCategory",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),

            // Floating Action Buttons (Edit/Delete)
            Positioned(
              top: 10,
              right: 10,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      // Edit pet action
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      // Delete pet action
                    },
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
