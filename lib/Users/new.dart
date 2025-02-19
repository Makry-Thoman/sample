import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zootopia/Users/Pets.dart';
import 'package:zootopia/function/AppbarZootioia.dart';

class petBreed extends StatefulWidget {
  final String petcategory;
  final String petName;
  final String dob;
  final String gender;

  const petBreed(
      {Key? key,
      required this.petcategory,
      required this.petName,
      required this.dob,
      required this.gender});

  @override
  State<petBreed> createState() => _petBreedState();
}

class _petBreedState extends State<petBreed> {
  final _formKey = GlobalKey<FormState>();
  final _breedController = TextEditingController();
  final _petColorController = TextEditingController();
  bool _isLoading = false;


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Get values from form fields
      String breed = _breedController.text.trim();
      String petcolor = _petColorController.text.trim();

      try {
        // Firestore reference
        CollectionReference pets = FirebaseFirestore.instance.collection('Pets details');

        // Add pet data
        await pets.add({
          'petcategory': widget.petcategory,
          'petName': widget.petName,
          'dob': widget.dob,
          'gender': widget.gender,
          'breed': breed,
          'petcolor': petcolor,
          'createdAt': FieldValue.serverTimestamp(), // Timestamp for sorting
        });

        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(content: Text('Pet details added successfully!')
          ),

        );
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => petsPage(),), (route) => false);

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
