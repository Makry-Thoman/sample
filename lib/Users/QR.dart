import 'package:flutter/material.dart';
import 'package:zootopia/Users/qr_code_generator.dart';
import 'package:zootopia/function/AppbarZootioia.dart';
import 'package:zootopia/function/DrawerBar.dart';

class QRCode extends StatefulWidget {
  const QRCode({super.key});

  @override
  State<QRCode> createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  final _websiteController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: zootopiaAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            TextFormField(
              controller: _websiteController,
              decoration: const InputDecoration(hintText: 'Website'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => QRCodeGenerator(website: _websiteController.text ),));
              },
              child: const Text('Generate QR code'),
            )
          ],
        ),
      ),
    );
  }
}
