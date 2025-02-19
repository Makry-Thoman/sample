import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:zootopia/function/AppbarZootioia.dart';

class QRCodeGenerator extends StatelessWidget {
  QRCodeGenerator({super.key, required this.website});
  final String website;
  final ScreenshotController screenshotController = ScreenshotController();


  Future<void> saveQR() async{

    final Uint8List? uint8list = await screenshotController.capture();
    if(uint8list != null){
      final PermissionStatus status = await Permission.storage.request();
      if(status.isGranted)
        {
          // final result =await ImageGallerySaver.saveImage(uint8list);
          // if(result['isSuccess'])
          // {
            print('Image saved to gallery');
          // // }
          // else
          //   {
          //     print('Failed to save image: ${result['error']}');
          //   }
        }
      else
        {
          print('Permission to access storage denied');
        }
    }
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
            Screenshot(
              controller: screenshotController,
              child: QrImageView(
                data: website,
                version: QrVersions.auto,
                gapless: false,
                size: 320,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text("Scan this QR code"),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () async{
              await  saveQR();
              },
              child: Text("Save QR Code"),
            )
          ],
        ),
      ),
    );
  }
}
