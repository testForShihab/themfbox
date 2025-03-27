import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

class UserSignatureArea extends StatefulWidget {
  const UserSignatureArea({super.key});

  @override
  State<UserSignatureArea> createState() => _UserSignatureAreaState();
}

class _UserSignatureAreaState extends State<UserSignatureArea> {
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");

  @override
  void initState() {
    //  implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
  }

  late double devHeight, devWidth;

  @override
  void dispose() {
    //  implement dispose
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  GlobalKey<SfSignaturePadState> signaturePadKey =
      GlobalKey<SfSignaturePadState>();

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            InkWell(onTap: () => Get.back(), child: Icon(Icons.close)),
            SizedBox(width: 10),
            Text("Sign Digitally within the box",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
            Spacer(),
            ElevatedButton(
                onPressed: () {
                  signaturePadKey.currentState!.clear();
                },
                child: Row(
                  children: [Text("CLEAR"), Icon(Icons.undo)],
                )),
            SizedBox(width: 10),
            ElevatedButton(
                onPressed: () async {
                  File userSign = await saveIntoFile();
                  Get.back(result: userSign);
                },
                child: Row(
                  children: [Text("DONE"), Icon(Icons.check_circle_outline)],
                )),
          ],
        ),
        backgroundColor: Config.appTheme.themeColor,
        foregroundColor: Colors.white,
        leading: SizedBox(),
        leadingWidth: 0,
      ),
      body: Center(
        child: Container(
          width: devWidth * 0.5,
          decoration: BoxDecoration(border: Border.all()),
          child: SfSignaturePad(
            key: signaturePadKey,
          ),
        ),
      ),
    );
  }

  Future saveIntoFile() async {
    ui.Image image = await signaturePadKey.currentState!.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List imageBytes = byteData!.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    img.Image? originalImage = img.decodeImage(imageBytes);

    print('>>> original width: ${originalImage!.width}');

    String path = (await getApplicationSupportDirectory()).path;
    var timeStamp = DateTime.now().millisecondsSinceEpoch;
    final String fileName = '$path/signature_$timeStamp.png';
    final File file = File(fileName);
    File userSign = await file.writeAsBytes(img.encodePng(originalImage));

    return userSign;
  }
}
