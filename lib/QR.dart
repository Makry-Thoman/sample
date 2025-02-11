import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zootopia/function/DrawerBar.dart';

class QRGenerator extends StatefulWidget {
  const QRGenerator({super.key});

  @override
  _QRGeneratorState createState() => _QRGeneratorState();
}

class _QRGeneratorState extends State<QRGenerator> {
  // Text Editing Controllers for the input fields
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String qrData = ""; // QR code data

  // Function to update the QR data whenever any of the fields change
  void generateQR() {
    setState(() {
      qrData = 'Owner: ${ownerNameController.text}\n'
          'Pet: ${petNameController.text}\n'
          'Phone: ${phoneController.text}\n'
          'Email: ${emailController.text}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        toolbarHeight: 70,
        title: Image.asset('asset/ZootopiaAppWhite.png', height: 40),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Text Fields to input the details
            TextField(
              controller: ownerNameController,
              decoration: InputDecoration(labelText: 'Pet Owner Name'),
            ),
            TextField(
              controller: petNameController,
              decoration: InputDecoration(labelText: 'Pet Name'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: generateQR, // Generate QR code on button press
              child: Text('Generate QR Code'),
            ),
            SizedBox(height: 20),
            // Display the generated QR code

          ],
        ),
      ),
    );
  }
}


