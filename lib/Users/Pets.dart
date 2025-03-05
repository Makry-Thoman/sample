import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zootopia/Pets%20Start%20-1.dart';
import 'package:zootopia/Users/PetCard.dart';
import 'package:zootopia/Users/PetProfile.dart';
import 'package:zootopia/function/AppbarZootioia.dart';

class PetsPage extends StatefulWidget {
  const PetsPage({super.key});

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: zootopiaAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PetName()),
          );
        },
        backgroundColor: Colors.grey,
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 40,
        ),
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!userSnapshot.hasData || userSnapshot.data == null) {
            return const Center(child: Text("User not logged in"));
          }

          String userId = userSnapshot.data!.uid; // Current user's UID

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Pets details')
                .where('ownerID', isEqualTo: userId) // Filter by user ID
                // .orderBy('createdAt', descending: true) // Ensure correct ordering
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No pet data available."));
              }

              var petDocs = snapshot.data!.docs;

              return ListView.builder(
                itemCount: petDocs.length,
                itemBuilder: (context, index) {
                  var pet = petDocs[index].data() as Map<String, dynamic>?;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetProfile(PetID: petDocs[index].id),
                        ),
                      );
                    },
                    child: PetCard(
                      petName: pet?['petName'] ?? 'Unknown Pet',
                      description: "Adorable and friendly!",
                      imageUrl: pet?['imageUrl'] ?? '',
                      price: 75, // Hardcoded, consider removing if unused
                      rating: 3.5,
                      isFavorite: true,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
