import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  final ImagePicker picker = ImagePicker();
  late String imagePath;

  @override
  void initState() {
    super.initState();
    openCamera();
  }

  Future<void> openCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    print("image = $image");
    if (image != null && image.toString().isNotEmpty) {
      setState(() {
        imagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
