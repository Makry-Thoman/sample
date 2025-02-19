import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zootopia/Pets%20Start%20-1.dart';
import 'package:zootopia/Users/PetCard.dart';
import 'package:zootopia/function/AppbarZootioia.dart';

class petsPage extends StatefulWidget {
  const petsPage({super.key});

  @override
  State<petsPage> createState() => _petsPageState();
}

class _petsPageState extends State<petsPage> {
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
        stream: FirebaseFirestore.instance.collection('Pets details').snapshots(),
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
              return PetCard(
                petName: pet['petName'],
                breed: pet['breed'],
                color: pet['petcolor'],
                dob: pet['dob'],
                gender: pet['gender'],
                petCategory: pet['petcategory'],
                  imageUrl: pet['imageUrl']
              );
            },
          );
        },
      ),
    );
  }
}
