import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:zootopia/Starting/Session.dart';
import 'package:zootopia/Users/Pets.dart';
import 'package:zootopia/bottomnavbar.dart';
import 'package:zootopia/function/AppbarZootioia.dart';

class petBreed extends StatefulWidget {
  final String petcategory;
  final String petName;
  final String dob;
  final String gender;
  final File? petPhoto;

  const petBreed(
      {Key? key,
        required this.petcategory,
        required this.petName,
        required this.dob,
        required this.gender,
        required this.petPhoto});

  @override
  State<petBreed> createState() => _petBreedState();
}

class _petBreedState extends State<petBreed> {
  final _formKey = GlobalKey<FormState>();
  final _breedController = TextEditingController();
  final _petColorController = TextEditingController();
  bool _isLoading = false;
  late String uidd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future<String?> getData() async {
    Map<String, String?> sessionData =  await Session.getSession();

    print(sessionData['uid']);
    uidd=sessionData['uid']!;
    return uidd;
  }

  String generatePetId(String petCategory) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();

    // Ensure pet category has at least 4 characters, if not, pad with 'X'
    String categoryPart = (petCategory.length >= 4)
        ? petCategory.substring(0, 4).toUpperCase()
        : petCategory.toUpperCase().padRight(4, 'X');

    // Get last 6 digits of timestamp
    String timestampPart = DateTime.now().millisecondsSinceEpoch.toString().substring(7, 13);

    return categoryPart + timestampPart; // Total 10 characters
  }



  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Get values from form fields
      String breed = _breedController.text.trim();
      String petcolor = _petColorController.text.trim();
      String? imageUrl;

      try {
        // Check if petPhoto is available
        if (widget.petPhoto != null) {
          // Create a reference to Firebase Storage
          Reference storageRef = FirebaseStorage.instance
              .ref()
              .child('pet_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

          // Upload file to Firebase Storage
          UploadTask uploadTask = storageRef.putFile(widget.petPhoto!);
          TaskSnapshot snapshot = await uploadTask;

          // Get download URL
          imageUrl = await snapshot.ref.getDownloadURL();
        }

        // Firestore reference
        // CollectionReference pets = FirebaseFirestore.instance.collection('Pets details');
        String petId = generatePetId(widget.petcategory);

        // debugPrint(uidd);
        // Add pet data to Firestore
        await FirebaseFirestore.instance.collection('Pets details').doc(petId).set({
          'petID': petId,
          'ownerID':uidd,
          'petcategory': widget.petcategory,
          'petName': widget.petName,
          'dob': widget.dob,
          'gender': widget.gender,
          'breed': breed,
          'petcolor': petcolor,
          'imageUrl': imageUrl ?? "", // Store the image URL
          'createdAt': FieldValue.serverTimestamp(), // Timestamp for sorting
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pet details added successfully!')),
        );

        // Navigate to the pets page
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (context) => petsPage()),
        //       (route) => false,
        // );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Bottomnavbar(initialIndex: 0), // 0 for PetsPage
          ),
              (route) => false,
        );

        // Clear form fields
        _breedController.clear();
        _petColorController.clear();



      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add pet: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: zootopiaAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    child: Image(image: AssetImage('asset/White_cat.png')),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    // Space between label and TextField
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Pet Breed', // Label text
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _breedController,
                    decoration: InputDecoration(
                        hintText: 'Breed',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a Breed';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    // Space between label and TextField
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Color', // Label text
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _petColorController,
                    decoration: InputDecoration(
                        hintText: 'Breed',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a Breed';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Add"),
                  )

                ],
              ),
            ),
          ),
        ));
  }
}