import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zootopia/function/AppbarZootioia.dart';

class EditPetScreen extends StatefulWidget {
  final String petID;

  const EditPetScreen({super.key, required this.petID});

  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _petNameController = TextEditingController();
  TextEditingController _petBreedController = TextEditingController();
  TextEditingController _petCategoryController = TextEditingController();
  String? _petGender;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPetDetails();
  }

  void fetchPetDetails() async {
    DocumentSnapshot petSnapshot = await FirebaseFirestore.instance
        .collection('Pets details')
        .doc(widget.petID)
        .get();

    if (petSnapshot.exists) {
      Map<String, dynamic> petData = petSnapshot.data() as Map<String, dynamic>;

      setState(() {
        _petNameController.text = petData['petName'] ?? '';
        _petBreedController.text = petData['breed'] ?? '';
        _petCategoryController.text = petData['petcategory'] ?? '';
        _petGender = petData['gender'];
        isLoading = false;
      });
    }
  }

  void savePetDetails() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('Pets details')
          .doc(widget.petID)
          .update({
        'petName': _petNameController.text.trim(),
        'breed': _petBreedController.text.trim(),
        'petcategory': _petCategoryController.text.trim(),
        'gender': _petGender,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pet details updated successfully!')),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: zootopiaAppBar(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _petNameController,
                  decoration: InputDecoration(labelText: "Pet Name",border: OutlineInputBorder()),
                  validator: (value) =>
                  value!.isEmpty ? "Please enter pet name" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _petBreedController,
                  decoration: InputDecoration(labelText: "Breed", border: OutlineInputBorder()),
                  validator: (value) =>
                  value!.isEmpty ? "Please enter breed" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _petCategoryController,
                  decoration: InputDecoration(labelText: "Category",border: OutlineInputBorder()),
                  validator: (value) =>
                  value!.isEmpty ? "Please enter category" : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: (_petGender == 'Male' || _petGender == 'Female') ? _petGender : null,
                  items: ['Male', 'Female']
                      .map((gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _petGender = value;
                    });
                  },
                  decoration: InputDecoration(labelText: "Gender",border: OutlineInputBorder()),
                  validator: (value) => value == null ? "Please select a gender" : null,
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: savePetDetails,
                  child: Text("Save Changes"),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
