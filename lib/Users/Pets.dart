import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zootopia/Pets%20Start%20-1.dart';
import 'package:zootopia/Users/PetCard.dart';
import 'package:zootopia/Users/PetProfile.dart';
import 'package:zootopia/function/AppbarZootioia.dart';

class petsPage extends StatefulWidget {
  const petsPage({super.key});

  @override
  State<petsPage> createState() => _petsPageState();
}


class _petsPageState extends State<petsPage> {
 // List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Pets details')
          .orderBy('timestamp', descending: true)
          .get();

      List<Map<String, dynamic>> fetchedProducts =
      querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
         /* 'name': doc['name'] ?? '',
          'price': doc['price'] ?? 0.0,
          'description': doc['description'] ?? '',*/
        };
      }).toList();

      setState(() {
      //  products = fetchedProducts;
        // isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        // isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: zootopiaAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PetName(),
              ));
        },
        backgroundColor: Colors.grey,
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 40,
        ),
      ),
      body: StreamBuilder(

        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!userSnapshot.hasData || userSnapshot.data == null) {
            return Center(child: Text("User not logged in"));
          }

          String userId = userSnapshot.data!.uid; // Get the current user's UID
  print(userId);
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Pets details')
                .where('ownerID', isEqualTo: userId) // Filter by current user
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No pet data available."));
              }

              var petDocs = snapshot.data!.docs;

              return ListView.builder(
                itemCount: petDocs.length,
                itemBuilder: (context, index) {
                  var pet = petDocs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetProfile(PetID: pet.id),
                        ),
                      );
                    },
                    child: PetCard(
                      petName: pet['petName'],
                      description: "Adorable and friendly!",
                      imageUrl: pet['imageUrl'],
                      price: 75,
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
