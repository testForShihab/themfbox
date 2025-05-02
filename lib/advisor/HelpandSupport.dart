import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mymfbox2_0/advisor/CameraPage.dart';
import 'package:mymfbox2_0/advisor/Gallery.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:path_provider/path_provider.dart';

import '../api/Api.dart';
import '../rp_widgets/RpAppBar.dart';

class HelpandSupport extends StatefulWidget {
  const HelpandSupport({Key? key}) : super(key: key);

  @override
  State<HelpandSupport> createState() => _HelpandSupportState();
}

class _HelpandSupportState extends State<HelpandSupport> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late double devHeight, devWidth;
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();
  final picker = ImagePicker();
  String selectedImagename = " ";
  late Uint8List? selectedImageBytes;
  late Uint8List videoBytes;
  File? attachedFile;
  String? fileNameWithExtension;
  int type_id = GetStorage().read('type_id');
  int user_id = getUserId();
  String client_name = GetStorage().read('client_name');
  late String imagePath;
  String concateFileString = "";
  String imageUrl = "https://example.com/path/to/image.jpg";
  List<Map<String, dynamic>> imageListArray = [];
  Map BottomSheetdata = {
    "Photo Library": ["", Gallery(), "assets/add_photo_alternate.png"],
    "Take Photo or Video": ["", CameraPage(), "assets/add_a_photo.png"],
    "Choose Files": ["", null, "assets/add_notes.png"],
  };
  String uploadMessage = "";

  Future uploadImage(BuildContext context) async {
    EasyLoading.show();
    Map data = await Api.uploadImage(
        client_name: client_name, user_id: user_id, file_path: chqImg!.path);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    String fileName = data['msg'];

    concateFileString += "$fileName,";
    print("concateFileString $concateFileString");
    EasyLoading.dismiss();
    return 0;
  }

  Future saveSupport(String attachmentImagePath) async {
    print("imageListArray ${imageListArray.length}");
    int i = 0;
    for (i = 0; i < imageListArray.length; i++) {
      String name = imageListArray[i]['name'];
      print('Image ID: $name');
    }
    if (concateFileString.endsWith(",")) {
      concateFileString =
          concateFileString.substring(0, concateFileString.length - 1);
    }
    print("concateFileString $concateFileString");
    Map data = await Api.saveSupport(
        client_name: client_name,
        user_id: user_id,
        subject: subjectController.text,
        describtion: descriptionController.text,
        file_name: concateFileString);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    return 0;
  }

  String fileName = "";
  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Help and Support",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: SideBar(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tell us about your issue',
                    style: TextStyle(
                        color: Config.appTheme.themeColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 22)),
                SizedBox(height: 16),
                Container(
                  width: devWidth,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(11, 4, 0, 0),
                        child: Text("Subject*"),
                      ),
                      TextField(
                        maxLength: 100,
                        maxLines: 1,
                        keyboardType: TextInputType.multiline,
                        controller: subjectController,
                        decoration: InputDecoration(
                            hintText: "Enter the subject",
                            hintStyle: TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(style: BorderStyle.none)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent))),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: devWidth,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(11, 4, 0, 0),
                        child: Text("Description*"),
                      ),
                      TextField(
                        maxLength: 200,
                        maxLines: 3,
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            hintText: "Describe your issue",
                            hintStyle: TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(style: BorderStyle.none)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent))),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                DottedBorder(
                  color: Colors.black12,
                  strokeWidth: 1,
                  borderType: BorderType.RRect,
                  radius: Radius.circular(20),
                  dashPattern: [10, 3],
                  child: SizedBox(
                    //  height: devHeight,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (imageListArray.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.transparent,
                                  child: imageListContainer(),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          if (imageListArray.length < 5)
                            SizedBox(
                              width: 240,
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Config.appTheme.themeColor25,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: Config.appTheme.themeColor,
                                      )),
                                  textStyle: AppFonts.f50014Black.copyWith(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  setState(() async {
                                    String? imageName;
                                    if (imageListArray.length > 5) {
                                      Utils.showError(context,
                                          "Maximum Five Files only allowed");
                                      return;
                                    } else {
                                      addAttachment(imageName);
                                    }
                                  });
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Text("ADD ATTACHEMENT",
                                        style: TextStyle(
                                          color: Config.appTheme.themeColor,
                                          fontWeight: FontWeight.w700,
                                        )),
                                    Image.asset("assets/attach_file_add.png",
                                        color: Config.appTheme.themeColor,
                                        height: 32),
                                  ],
                                ),
                              ),
                            ),
                          SizedBox(height: 15),
                          if (imageListArray.length < 5)
                            Text(
                              "(Max 5 files) ",
                              style: TextStyle(color: Colors.grey),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        width: devWidth,
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: SizedBox(
          width: devWidth * 0.76,
          height: 45,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Config.appTheme.buttonColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              textStyle: AppFonts.f50014Black.copyWith(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              if (subjectController.text.isEmpty ||
                  descriptionController.text.isEmpty) {
                Utils.showError(context, "All Fields are mandatory");
                return;
              }
              int res1 = await saveSupport(attachmentImagePath!);
              if (res1 == -1) return;
              Get.back();

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Issue submitted'),
                    content: Text(
                      "Thank you for reaching us out. Well get back to you within 24 hours.",
                      style: AppFonts.f50014Grey,
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            descriptionController.text = "";
                            subjectController.text = "";
                            imageName = "";
                            Get.back();
                          },
                          child: Text("OK")),
                    ],
                  );
                },
              );
            },
            child: Text("SUBMIT"),
          ),
        ),
      ),
    );
  }

  File? chqImg;
  addAttachment(String? imageName) {
    showModalBottomSheet(
      backgroundColor: Config.appTheme.mainBgColor,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    //  padding: EdgeInsets.symmetric(horizontal: devWidth * 0.05),
                    padding: EdgeInsets.only(left: 20, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Add Attachment",
                            style: AppFonts.f50014Black.copyWith(fontSize: 16)),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (imageName != null)
                          Text(
                            imageName,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        listContainer(bottomState),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget listContainer(bottomState) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(12),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: BottomSheetdata.length,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 16,
            child: DottedLine(),
          );
        },
        itemBuilder: (context, index) {
          String title = BottomSheetdata.keys.elementAt(index);
          List stitle = BottomSheetdata.values.elementAt(index);
          imagePath = stitle[2];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: InkWell(
              onTap: () async {
                if (index == 0) {
                  openGallery(bottomState);
                  setState(() {});
                  Get.back();
                } else if (index == 1) {
                  _showOptionsModal(context);
                } else if (index == 2) {
                  _pickFile();
                } else if (stitle[1] != null) {
                  Get.to(stitle[1]);
                }
                // if (stitle[1] != null) Get.to(stitle[1]);
              },
              child: RpListTile(
                title: SizedBox(
                  width: 220,
                  child: Text(
                    title,
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor),
                  ),
                ),
                subTitle: Visibility(
                  visible: stitle[0].isNotEmpty,
                  child: Text(stitle[0], style: AppFonts.f40013),
                ),
                leading: Image.asset(
                  imagePath,
                  color: Config.appTheme.themeColor,
                  width: 24,
                  height: 24,
                ),
                showArrow: false,
              ),
            ),
          );
        },
      ),
    );
  }

  String imageName = "";
  Widget imageListContainer() {
    return /*imageListArray.isEmpty
        ? Padding(
            padding: EdgeInsets.only(
              top: devHeight * 0,
            ),
            child: Text("Attachment is Empty"),
          )
        : */
        SizedBox(
      width: devWidth,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.transparent),
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: imageListArray.length,
          itemBuilder: (context, index) {
            imageName = imageListArray[index]['name'];
            List<int> imageBytes = imageListArray[index]['bytes'];
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: 2,
              ),
              child: InkWell(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.attach_file,
                        size: 20,
                        color: Config.appTheme.themeColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        imageName,
                        style: AppFonts.f50014Black
                            .copyWith(color: Config.appTheme.themeColor),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          imageListArray.removeAt(index);
                          List<String> filenames = concateFileString.split(",");

                          if (index >= 0 && index < filenames.length) {
                            filenames.removeAt(index);
                            concateFileString = filenames.join(",");
                            print(
                                "index Updated concateFileString: $concateFileString");
                          } else {
                            print("Invalid index: $index");
                          }
                        });
                      },
                      icon: Icon(
                        Icons.close,
                        size: 20,
                        color: Config.appTheme.placeHolderInputTitleAndArrow,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String? attachmentImagePath;
  Future<void> openGallery(bottomstate) async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      List<int> selectedImageBytes = await image.readAsBytes();
      imageName = image.name;

      // Get the app's documents directory
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      print("gallery imageName $imageName");
      // Create a new file in the app's assets "attachments" folder
      Directory attachmentsDir = Directory('$appDocPath/attachments');
      print("gallery attachmentsDir $attachmentsDir");
      if (!attachmentsDir.existsSync()) {
        attachmentsDir.createSync(recursive: true);
      }
      attachmentImagePath = '$appDocPath/attachments/$imageName';
      File newImageFile = File(attachmentImagePath!);

      // Write the selected image bytes to the new file
      await newImageFile.writeAsBytes(selectedImageBytes);

      // Add image info to the image list
      addImageInfo(imageName, selectedImageBytes, newImageFile);
      chqImg = File(attachmentImagePath!);
      attachmentImagePath = await uploadImage(context);
      // Update the UI
      setState(() async {});
      Get.back();
    }
  }

  void _showOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('Record Video'),
                onTap: () {
                  Navigator.pop(context);
                  _recordVideo(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openCamera() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      // Process the captured image here
      print("Image captured: ${image.path}");
    } else {
      // User canceled the camera operation
      print("Camera operation canceled");
    }
  }

  Future<void> _takePhoto(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      // Generate a random alphanumeric string for the file name
      String randomString =
          DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';

      // Convert the image file to bytes
      File imageFile = File(image.path);
      Uint8List bytes = await imageFile.readAsBytes();

      addImageInfo(randomString, bytes, null);
      setState(() {});
      Get.back();
    } else {
      // Handle if the image is not picked
      print('No image selected');
    }
  }

  Future<void> _recordVideo(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      final bytes = await video.readAsBytes();
      setState(() {
        videoBytes = bytes;
      });

      // Generate a random string
      String randomString = DateTime.now().millisecondsSinceEpoch.toString();

      // Get the video file extension
      String extension = video.path.split('.').last;

      // Combine the random string, timestamp, and extension to form the file name
      String fileName = '$randomString.$extension';

      addImageInfo(fileName, videoBytes, null);
      setState(() {});
      Get.back();
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'pdf', 'doc', 'docx'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      String? filePath = file.path;

      if (filePath != null) {
        File pickedFile = File(filePath);
        String fileNameWithExtension = file.name;

        addImageInfo(fileNameWithExtension, [], pickedFile);
      } else {
        print('Error: File path is null');
      }
    } else {
      print('File picking canceled');
    }

    setState(() {});
    Get.back();
  }

  void addImageInfo(String imageName, List<int> imageBytes, File? file) {
    imageListArray.add({
      'name': imageName,
      'bytes': imageBytes,
      'attached': file,
    });
    setState(() {});
  }
}

class UploadImageresponse {
  int? status;
  String? statusMsg;
  String? msg;

  UploadImageresponse({this.status, this.statusMsg, this.msg});

  UploadImageresponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_msg'] = this.statusMsg;
    data['msg'] = this.msg;
    return data;
  }
}
