import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/EkycApi.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class EkycPersonalInfo extends StatefulWidget {
  const EkycPersonalInfo({super.key});

  @override
  State<EkycPersonalInfo> createState() => _EkycPersonalInfoState();
}

class _EkycPersonalInfoState extends State<EkycPersonalInfo> {
  String mothersName = "", mobile = "",aadhar = "";
  String email = "";

  int user_id = GetStorage().read('user_id');
  String client_name = GetStorage().read('client_name');
  String ekyc_id = GetStorage().read('ekyc_id');
  String pan = GetStorage().read("user_pan");

  late double devWidth, devHeight;
  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;
    devHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
        title: "Personal Information",
        bgColor: Config.appTheme.themeColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Please enter your personal details",
                      style: AppFonts.f50014Grey),
                  SizedBox(height: 16),
                  genderExpansionTile(),
                  SizedBox(height: 16),
                  mStatusExpansionTile(),
                  SizedBox(height: 16),
                  nameTypeCard(),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Last 4 digit of Aadhar Number",
                    suffixText: "",
                    hasSuffix: false,
                    borderRadius: BorderRadius.circular(20),
                    maxLength: 4,
                    onChange: (val) => aadhar = val,
                  ),
                  SizedBox(height: 16,),
                  motherNameCard(),
                  SizedBox(height: 16),
                  residentialStatusExpansionTile(),
                  SizedBox(height: 16),
                  employementStatusTile(context),
                  SizedBox(
                    height: 16,
                  ),
                  AmountInputCard(
                    title: "Mobile Number",
                    suffixText: "",
                    hasSuffix: false,
                    borderRadius: BorderRadius.circular(20),
                    maxLength: 10,
                    onChange: (val) => mobile = val,
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Email ID",
                    suffixText: "",
                    hasSuffix: false,
                    borderRadius: BorderRadius.circular(20),
                    onChange: (val) => email = val,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),
                  communicationAddressTile(context),
                  SizedBox(height: 16),
                  permanentAddressTile(context),
                  SizedBox(height: 16),
                ],
              ),
            ),
            CalculateButton(
              onPress: () async {
                // print("gender = $gender");
                // print("mStatus = $mStatus");
                // print("name = $name");
                // print("nameType = $nameType");
                // print("salutationType = $salutationType");
                // print("motherSalution = $motherSalution");
                // print("residentialType = $residentialType");
                // print("employementStatus = $employementStatus");
                // print("employementStatusCode = $employementStatusCode");
                // print("mobile = $mobile");
                // print("email = $email");
                // print("communicationAddress = $cAddress");
                // print("communicationAddressCode = $cAddressCode");
                // print("permenantAddress = $pAddress");
                // print("permenantAddressCode = $pAddressCode");

                Map errors = {
                  name: "Name Required",
                  motherName: "Mother Name Required",
                  residentialType: "Residential Type Required",
                  mobile: "Mobile Number Required",
                  aadhar: "Last 4 digit aadhar number required",
                  cAddress: "Communication Address Required",
                  pAddress: "Permenant Address Required"
                };

                try {
                  errors.forEach((key, value) {
                    if (key == null || key.isEmpty) throw value;
                  });
                } catch (e) {
                  Utils.showError(context, "$e");
                  return;
                }

                int res = await updatePersonalInfo();
                if (res == 0) Get.back();
              },
              text: "CONTINUE",
            ),
          ],
        ),
      ),
    );
  }

  Future updatePersonalInfo() async {
    EasyLoading.show();

    Map data = await EkycApi.updatePersonalInfo(
        user_id: user_id,
        client_name: client_name,
        gender: gender[0],
        marital: mStatus,
        fatherSaln: "$salutationType.",
        fatherName: name,
        relation: nameType,
        pan: pan,
        motherSaln: "$motherSalution.",
        motherName: motherName,
        resStatus: residentialType,
        occupationCode: employementStatusCode,
        occupation: employementStatus,
        mobile: mobile,
        aadhar:aadhar,
        email: email,
        commAddressCode: cAddressCode,
        commAddress: cAddress,
        permAddressCode: pAddressCode,
        permAddress: pAddress,
        ekyc_id: ekyc_id);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    EasyLoading.dismiss();

    return 0;
  }

  ExpansionTileController genderController = ExpansionTileController();
  List genderList = ["Male", "Female"];
  String gender = "Male";
  Widget genderExpansionTile() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: genderController,
          title: Text("Gender", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(gender, style: AppFonts.f50012),
            ],
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: genderList.length,
              itemBuilder: (context, index) {
                String temp = genderList[index];

                return InkWell(
                  onTap: () {
                    gender = temp;
                    genderController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: gender,
                        onChanged: (value) {
                          gender = temp;
                          genderController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(temp),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ExpansionTileController mStatusController = ExpansionTileController();
  List mStatusList = ["MARRIED", "UNMARRIED", "OTHERS"];
  String mStatus = "MARRIED";
  Widget mStatusExpansionTile() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: mStatusController,
          title: Text("Marital Status", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mStatus, style: AppFonts.f50012),
            ],
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: mStatusList.length,
              itemBuilder: (context, index) {
                String temp = mStatusList[index];

                return InkWell(
                  onTap: () {
                    mStatus = temp;
                    mStatusController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: mStatus,
                        onChanged: (value) {
                          mStatus = temp;
                          mStatusController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(temp),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List nameTypeList = ["FATHER", "SPOUSE"];
  String nameType = "FATHER";
  String name = "";
  List salutionTypeList = ['Mr', 'Mrs'];
  String salutationType = "Mr";
  Widget nameTypeCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            child: ListView.builder(
              itemCount: nameTypeList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                String title = nameTypeList[index];
                bool isSelected = (title == nameType);

                return Row(
                  children: [
                    Radio(
                        value: title,
                        groupValue: nameType,
                        onChanged: (val) {
                          nameType = title;
                          if (nameType == "FATHER")
                            salutationType = "Mr";
                          else
                            salutationType =
                                "Mrs"; // default to Mr when switching to Spouse Name

                          setState(() {});
                        }),
                    Text(
                      "$title NAME",
                      style: (isSelected)
                          ? AppFonts.f50014Theme
                          : AppFonts.f50014Grey,
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 70,
                height: 48,
                padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Config.appTheme.mainBgColor,
                  border: Border(
                    left:
                        BorderSide(width: 1, color: Config.appTheme.lineColor),
                    top: BorderSide(width: 1, color: Config.appTheme.lineColor),
                    bottom:
                        BorderSide(width: 1, color: Config.appTheme.lineColor),
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                child: DropdownButtonFormField(
                  value: salutationType,
                  decoration: InputDecoration(border: InputBorder.none),
                  items: salutionTypeList
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    salutationType = val as String;
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: TextFormField(
                  onChanged: (val) => name = val,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Config.appTheme.lineColor, width: 1),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Config.appTheme.lineColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      hintText: "ENTER $nameType NAME"),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  /*Widget nameTypeCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (String title in nameTypeList) ...[
                Row(
                  children: [
                    Radio<String>(
                      value: title,
                      groupValue: nameType,
                      onChanged: (val) {
                        setState(() {
                          nameType = val!;
                          if (nameType == "Father's Name") {
                            salutationType = "Mr";
                          } else {
                            salutationType = "Mr"; // default to Mr when switching to Spouse Name
                          }
                        });
                      },
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: title == nameType ? FontWeight.bold : FontWeight.normal,
                        color: title == nameType ? Colors.black : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              if (nameType == "Spouse Name") ...[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      salutationType = "Mr";
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: salutationType == "Mr" ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Mr',
                      style: TextStyle(
                        color: salutationType == "Mr" ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      salutationType = "Mrs";
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: salutationType == "Mrs" ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Mrs',
                      style: TextStyle(
                        color: salutationType == "Mrs" ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
              ] else ...[
                Text(
                  'Mr',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 16),
              ],
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    hintText: "Enter $nameType",
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }*/

  ExpansionTileController empStatusController = ExpansionTileController();
  String employementStatus = "Private Sector";
  String employementStatusCode = "01";
  Map empStatusMap = {
    "Private Sector": "01",
    "Public Sector": "02",
    "Business": "03",
    "Professional": "04",
    "Retired": "06",
    "Housewife": "07",
    "Student": "08",
    "Government Sector": "10"
  };
  Widget employementStatusTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: empStatusController,
          title: Text("Employment Status", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(employementStatus, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: empStatusMap.length,
              itemBuilder: (context, index) {
                String desc = empStatusMap.keys.elementAt(index);
                String code = empStatusMap.values.elementAt(index);

                return InkWell(
                  onTap: () {
                    employementStatus = desc;
                    employementStatusCode = code;
                    empStatusController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: code,
                        groupValue: employementStatusCode,
                        onChanged: (value) {
                          employementStatus = desc;
                          employementStatusCode = code;
                          empStatusController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(desc, style: AppFonts.f50014Grey),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Map cAddressMap = {
    "Residential/Business": "01",
    "Residential": "02",
    "Business": "03",
    "Registered office": "04",
    "Unspecified": "05"
  };
  String cAddress = "";
  String cAddressCode = "";
  ExpansionTileController cAddressController = ExpansionTileController();
  Widget communicationAddressTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: cAddressController,
            title:
                Text("Communication Address Type", style: AppFonts.f50014Black),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cAddress, style: AppFonts.f50012),
              ],
            ),
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: cAddressMap.length,
                  itemBuilder: (context, index) {
                    String desc = cAddressMap.keys.elementAt(index);
                    String code = cAddressMap.values.elementAt(index);

                    return InkWell(
                      onTap: () {
                        cAddress = desc;
                        cAddressCode = code;
                        cAddressController.collapse();
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Radio(
                            value: code,
                            groupValue: cAddressCode,
                            onChanged: (value) {
                              cAddress = desc;
                              cAddressCode = code;
                              cAddressController.collapse();
                              setState(() {});
                            },
                          ),
                          Text(desc, style: AppFonts.f50014Grey),
                        ],
                      ),
                    );
                  })
            ],
          )),
    );
  }

  Map pAddressMap = {
    "Residential/Business": "01",
    "Residential": "02",
    "Business": "03",
    "Registered office": "04",
    "Unspecified": "05"
  };
  String pAddress = "";
  String pAddressCode = "";
  ExpansionTileController pAddressController = ExpansionTileController();
  Widget permanentAddressTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: pAddressController,
            title: Text("Permanent Address Type", style: AppFonts.f50014Black),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pAddress, style: AppFonts.f50012),
              ],
            ),
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: pAddressMap.length,
                  itemBuilder: (context, index) {
                    String desc = pAddressMap.keys.elementAt(index);
                    String code = pAddressMap.values.elementAt(index);

                    return InkWell(
                      onTap: () {
                        pAddress = desc;
                        pAddressCode = code;
                        pAddressController.collapse();
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Radio(
                            value: code,
                            groupValue: pAddressCode,
                            onChanged: (value) {
                              pAddress = desc;
                              pAddressCode = code;
                              pAddressController.collapse();
                              setState(() {});
                            },
                          ),
                          Text(desc, style: AppFonts.f50014Grey),
                        ],
                      ),
                    );
                  })
            ],
          )),
    );
  }

  List residentialTypeList = [
    "Resident Individual",
    "Non Resident Indian",
    "Foreign National",
    "Person of Indian Origin",
  ];
  String residentialType = "";
  ExpansionTileController residentialController = ExpansionTileController();

  Widget residentialStatusExpansionTile() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: residentialController,
          title: Text("Residential Status", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(residentialType, style: AppFonts.f50012),
            ],
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: residentialTypeList.length,
              itemBuilder: (context, index) {
                String title = residentialTypeList[index];

                return InkWell(
                  onTap: () {
                    residentialType = title;
                    residentialController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: title,
                        groupValue: residentialType,
                        onChanged: (value) {
                          residentialType = title;
                          residentialController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(title),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String motherSalution = 'Mrs';
  String motherName = "";
  Widget motherNameCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mother\'s Name', style: AppFonts.f50014Black),
          SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 70,
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: Config.appTheme.mainBgColor,
                  border: Border(
                    left:
                        BorderSide(width: 1, color: Config.appTheme.lineColor),
                    top: BorderSide(width: 1, color: Config.appTheme.lineColor),
                    bottom:
                        BorderSide(width: 1, color: Config.appTheme.lineColor),
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      topLeft: Radius.circular(25)),
                ),
                child: Center(
                  child: Text(
                    motherSalution,
                    style: AppFonts.f50014Black,
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  initialValue: mothersName,
                  onChanged: (val) => motherName = val,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Config.appTheme.lineColor, width: 1),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Config.appTheme.lineColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      hintText: 'ENTER MOTHER NAME'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


}
