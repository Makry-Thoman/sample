import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zootopia/function/AppbarZootioia.dart';

class QRCodeGenerator extends StatefulWidget {
  QRCodeGenerator({super.key, required this.qrData});
  final String qrData;

  @override
  State<QRCodeGenerator> createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  final GlobalKey _qrKey = GlobalKey(); // Key for capturing QR image


  Future<void> _saveQRCode() async {
    try {
      // Request storage permissions
      if (await _requestStoragePermission()) {
        RenderRepaintBoundary boundary =
        _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage();
        ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        // Get the Downloads folder path
        String? downloadsPath = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS);

        if (downloadsPath != null) {
          final file = File('$downloadsPath/qr_code_${DateTime.now().millisecondsSinceEpoch}.png');
          await file.writeAsBytes(pngBytes);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('QR Code saved to ${file.path}')),
          );
        } else {
          throw "Downloads folder path not found.";
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied!')),
        );
      }
    } catch (e) {
      debugPrint("Error saving QR Code: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save QR Code')),
      );
    }
  }
/*
  Future<bool> _requestStoragePermission() async {
    var status = await Permission.storage.request();
    return status.isGranted;
  }*/

  Future<bool> _requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    }

    if (await Permission.manageExternalStorage.request().isGranted) {
      return true;
    }

    return false; // Permission denied
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: zootopiaAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: _qrKey, // Attach key to QR Code
              child: /*QrImageView(
                data: widget.qrData,
                version: QrVersions.auto,
                gapless: false,
                size: 320,
              )*/QrImageView(
                data: widget.qrData,
                version: QrVersions.auto,
                size: 200.0,
                // Set the foreground and background colors
                foregroundColor: Colors.black,
                // QR code color
                backgroundColor: Colors.white, // Background color
              ),
            ),
            const SizedBox(height: 20.0),
            const Text("Scan this QR code"),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _saveQRCode, // Call save function
              child: const Text("Save QR Code"),
            ),
          ],
        ),
      ),
    );
  }
}
