import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class InputTest extends StatefulWidget {
  const InputTest({super.key});

  @override
  State<InputTest> createState() => _InputTestState();
}

class _InputTestState extends State<InputTest> {
  late double devHeight, devWidth;
  String bloodGroup = "A +ve";
  List bloodGroupList = [
    "A +ve",
    "A -ve",
    "B +ve",
    "B -ve",
    "O +ve",
    "O -ve",
    "AB +ve",
    "AB -ve"
  ];

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: devWidth * 0.05),
          child: Column(
            children: [
              SizedBox(height: devHeight * 0.06),
              Text("Step 1 of 3",
                  style: AppFonts.f70024
                      .copyWith(color: Config.appTheme.themeColor)),
              Divider(),
              SizedBox(height: devHeight * 0.02),
              ElevatedButton(
                  onPressed: () async {
                    XFile? xFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    int len = await xFile!.length();
                    num mb = len / 1000000;
                    print("xfile length = $len");
                    print("mb = $mb");
                  },
                  child: Text("pick image")),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    // launchUrlString("https://www.iloveimg.com/resize-image",
                    //     mode: LaunchMode.inAppWebView);
                  },
                  child: Text("resize online")),
              //blood group
              rpDropDown(
                  title: "Blood Group",
                  value: bloodGroup,
                  list: bloodGroupList,
                  onChange: (val) {
                    bloodGroup = val as String;
                    setState(() {});
                  }),
              inputColumn(title: "Working Place"),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputColumn(
      {required String title,
      Function(String)? onChange,
      TextInputType? inputType}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppFonts.f50014Black),
          TextFormField(
            onChanged: onChange,
            keyboardType: inputType,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }

  Widget rpDropDown(
      {required String title,
      required List list,
      Object? value,
      Function(Object?)? onChange}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppFonts.f50014Black),
          DropdownButtonFormField(
            value: value,
            decoration: InputDecoration(border: OutlineInputBorder()),
            items: list
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChange,
          ),
        ],
      ),
    );
  }
}
