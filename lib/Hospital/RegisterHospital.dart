import 'package:flutter/material.dart';
import 'package:zootopia/Hospital/Controller/Hospital_Controller.dart';
import 'package:zootopia/Hospital/FunctionsHospital/care_appbar.dart';
import 'package:zootopia/Hospital/LoginHospital.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Registerhospital extends StatefulWidget {
  const Registerhospital({super.key});

  @override
  State<Registerhospital> createState() => _RegisterhospitalState();
}

class _RegisterhospitalState extends State<Registerhospital> {
  final _formKey = GlobalKey<FormState>();
  final _HnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _districtController = TextEditingController();
  final _descriptionController = TextEditingController();
  final hospitalController _hospitalController = hospitalController();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? selectedState;
  bool _isLoading = false;

  final List<String> states = [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
    'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand',
    'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur',
    'Meghalaya', 'Mizoram', 'Nagaland', 'Odisha', 'Punjab',
    'Rajasthan', 'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura',
    'Uttar Pradesh', 'Uttarakhand', 'West Bengal',
    'Andaman and Nicobar Islands', 'Chandigarh', 'Dadra and Nagar Haveli and Daman and Diu',
    'Lakshadweep', 'Delhi', 'Puducherry', 'Jammu and Kashmir', 'Ladakh'
  ];

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child("hospital_profiles/${DateTime.now().millisecondsSinceEpoch}.jpg");
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image upload failed: $e"), backgroundColor: Colors.red),
      );
      return null;
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && selectedState != null) {
      setState(() => _isLoading = true);
      String? imageUrl;
      if (_image != null) {
        imageUrl = await _uploadImage(_image!);
      }
      String? result = await _hospitalController.registerHospital(
        _HnameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        imageUrl,
        selectedState!,  // Pass selected state
        _districtController.text.trim(),
          _descriptionController.text.trim(),// Pass district
      );
      setState(() => _isLoading = false);

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hospital Registration Successful!')),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginHospital()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result), backgroundColor: Colors.red),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields correctly."), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: careAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null ? Icon(Icons.camera_alt, size: 40) : null,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _HnameController,
                  decoration: InputDecoration(
                      labelText: 'Hospital Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      prefixIcon: Icon(Icons.local_hospital)),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter Hospital name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: 'Hospital Email',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      prefixIcon: Icon(Icons.email)),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter Hospital email';
                    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    return emailRegex.hasMatch(value) ? null : 'Please enter a valid email';
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      prefixIcon: Icon(Icons.lock)),
                  validator: (value) => (value == null || value.length < 6) ? 'Password must be at least 6 characters' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      labelText: 'Description about your hospital',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      prefixIcon: Icon(Icons.description)),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedState,
                  hint: Text("Select State"),
                  isExpanded: true,
                  items: states.map((state) => DropdownMenuItem(value: state, child: Text(state))).toList(),
                  onChanged: (value) => setState(() => selectedState = value),
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      prefixIcon: Icon(Icons.location_city_outlined)),
                  validator: (value) => value == null ? 'Please select a state' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _districtController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Enter District',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                    prefixIcon: Icon(Icons.location_city_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a district';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

