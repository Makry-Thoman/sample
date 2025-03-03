// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:external_path/external_path.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'dart:io';
//
// class QRCodeGenerator extends StatefulWidget {
//   const QRCodeGenerator({Key? key}) : super(key: key);
//
//   @override
//   State<QRCodeGenerator> createState() => _QRCodeGeneratorState();
// }
//
// class _QRCodeGeneratorState extends State<QRCodeGenerator> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   String _qrData = '';
//   final GlobalKey _qrKey = GlobalKey();
//
//   Future<void> _captureAndSaveQrCode() async {
//     try {
//       // Request storage permission
//       if (await Permission.storage.request().isGranted) {
//         final boundary =
//         _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
//         if (boundary != null) {
//           final ui.Image image = await boundary.toImage();
//           final ByteData? byteData =
//           await image.toByteData(format: ui.ImageByteFormat.png);
//           if (byteData != null) {
//             final Uint8List pngBytes = byteData.buffer.asUint8List();
//
//             // Get the Downloads directory using ext_storage
//             String? downloadsPath =
//             await ExternalPath.getExternalStoragePublicDirectory(
//                 ExternalPath.DIRECTORY_DOWNLOADS);
//             if (downloadsPath != null) {
//               final file = File(
//                   '$downloadsPath/qr_code_${DateTime.now().millisecondsSinceEpoch}.png');
//               await file.writeAsBytes(pngBytes);
//
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('QR Code saved to ${file.path}')),
//               );
//             }
//           }
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Storage permission denied')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error saving QR Code: $e')),
//       );
//     }
//   }
//
//   // Request storage permission
//   Future<void> _requestStoragePermission() async {
//     if (await Permission.storage.request().isGranted) {
//       // Permission granted, proceed with saving the QR code
//       await _captureAndSaveQrCode();
//     } else if (await Permission.storage.isPermanentlyDenied) {
//       // Open app settings if the permission is permanently denied
//       await openAppSettings();
//     } else {
//       // Permission denied
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Storage permission denied')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('QR Code Generator'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _addressController,
//               decoration: const InputDecoration(
//                 labelText: 'Address',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _phoneController,
//               decoration: const InputDecoration(
//                 labelText: 'Phone Number',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _qrData = 'Name: ${_nameController.text}, \n'
//                       'Address:${_addressController.text}, \n'
//                       'Phone: ${_phoneController.text}';
//                 });
//               },
//               child: const Text('Generate QR Code'),
//             ),
//             const SizedBox(height: 20),
//             if (_qrData.isNotEmpty)
//               RepaintBoundary(
//                 key: _qrKey,
//                 child: Center(
//                   child: QrImageView(
//                     data: _qrData,
//                     version: QrVersions.auto,
//                     size: 200.0,
//                     // Set the foreground and background colors
//                     foregroundColor: Colors.black,
//                     // QR code color
//                     backgroundColor: Colors.white, // Background color
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 20),
//             if (_qrData.isNotEmpty)
//               ElevatedButton(
//                 onPressed: _requestStoragePermission,
//                 child: const Text('Download QR Code'),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
