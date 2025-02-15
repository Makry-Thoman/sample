import 'package:flutter/material.dart';
import 'package:zootopia/Controller/Hospital_Controller.dart';
import 'package:zootopia/Controller/User_Controller.dart';
import 'package:zootopia/Hospital/LoginHospital.dart';
import 'package:zootopia/bottomnavbar.dart';
import 'dart:io';
import 'package:flutter/material.dart';
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
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repasswordController = TextEditingController();
  final hospitalController _hospitalController = hospitalController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to upload the image and get the URL
  Future<String?> _uploadImage(File image) async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child("hospital_profiles/${DateTime.now().millisecondsSinceEpoch}.jpg");

      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Image upload error: $e");
      return null;
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String? imageUrl;

      if (_image != null) {
        imageUrl = await _uploadImage(_image!);
      }

      String? result = await _hospitalController.registerHospital(
        _HnameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        imageUrl,
      );

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hospital Registration Successful!')),
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginHospital()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset('asset/ZootopiaAppWhite.png', height: 40),
        centerTitle: true,
      ),
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
                      prefixIcon: Icon(Icons.person)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Hospital name';
                    }
                    return null;
                  },
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
                    if (value == null || value.isEmpty) {
                      return 'Please enter Hospital email';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    final passwordRegex = RegExp(
                        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$');
                    if (!passwordRegex.hasMatch(value)) {
                      return 'Password must have at least 6 characters, include an uppercase letter, a lowercase letter, a number, and a special character';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
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