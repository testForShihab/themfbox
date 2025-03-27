import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Registration/NomineeInfo/NomineeController.dart';

import 'package:mymfbox2_0/api/onBoarding/CommonOnBoardApi.dart';
import 'package:mymfbox2_0/pojo/NomineePojo.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/CalculateButton.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:intl/intl.dart';

class NomineeInfo extends StatefulWidget {
  const NomineeInfo({super.key});

  @override
  State<NomineeInfo> createState() => _NomineeInfoState();
}

class _NomineeInfoState extends State<NomineeInfo> {
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  String bse_nse_mfu_flag = Get.arguments ?? " ";

  bool emptyNominee = false;
  List typeList = ["Major (Above 18 yrs)", "Minor"];

  NomineeController guardianRelationController = NomineeController();

  List guardianRelationList = [];

  Future getGurdianRelationShip() async {
    if (guardianRelationList.isNotEmpty) return 0;
    Map data = {};

    if (bse_nse_mfu_flag == "MFU") {
      data = await CommonOnBoardApi.getNomineeGuardRelationship(
          user_id: user_id, client_name: client_name);
      print("getNomineeGuardRelationship came true");
    } else {
      data = await CommonOnBoardApi.getRelation(
          user_id: user_id,
          client_name: client_name,
          bse_nse_mfu_flag: bse_nse_mfu_flag);
      print("getGuardianRelationship came false");
    }

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    guardianRelationList = data['list'];
    Map temp = guardianRelationList.first;
    String defaultDesc = temp['desc'];
    String defaultCode = temp['code'];

    guardianRelationController.setDefault(
        defaultDesc: defaultDesc, defaultCode: defaultCode);
    return 0;
  }

  List relationList = [];

  Future getRelationship() async {
    if (relationList.isNotEmpty) return 0;
    Map data = await CommonOnBoardApi.getRelationship(
        client_name: client_name, bse_nse_mfu_flag: bse_nse_mfu_flag);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    relationList = data['list'];

    Map temp = relationList.first;
    String defaultDesc = temp['desc'];
    String defaultCode = temp['code'];
    nomineeController.setDefault(
        defaultDesc: defaultDesc, defaultCode: defaultCode);
    return 0;
  }

  List<NomineePojo> nomineeList = [];

  late double devHeight, devWidth;

  List<NomineePojo> existingNomineeList = [];
  bool isFirst = true;

  Future getNomineeInfo() async {
    if (!isFirst) return 0;

    Map data = await CommonOnBoardApi.getNomineeInfo(
      user_id: user_id,
      client_name: client_name,
      bse_nse_mfu_flag: bse_nse_mfu_flag,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    List list = data['list'];
    convertListToObj(list);

    isFirst = false;
    return 0;
  }

  convertListToObj(List list) {
    list.forEach((element) {
      //existingNomineeList.add(NomineePojo.fromJson(element));
      nomineeList.add(NomineePojo.fromJson(element));
      print("Nominee Size ${nomineeList.length}");
    });
  }

  NomineeController nomineeController = NomineeController();

  Future getDatas() async {
    EasyLoading.show();
    await getRelationship();
    await getNomineeInfo();
    await getGurdianRelationShip();
    EasyLoading.dismiss();
    return 0;
  }

  @override
  void dispose() {
    //  implement dispose
    print("dispose called");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;
    devHeight = MediaQuery.sizeOf(context).height;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return SizedBox();
          // if (existingNomineeList.isNotEmpty) {
          //   return UpdateNomineeInfo(
          //     nomineeList: existingNomineeList,
          //     bse_nse_mfu_flag: bse_nse_mfu_flag,
          //     relationList: relationList,
          //   );
          // }
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: rpAppBar(
              title: "Nominee Info",
              bgColor: Config.appTheme.themeColor,
              foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Visibility(
                          visible: !emptyNominee,
                          child: ListView.builder(
                            itemCount: nomineeList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              NomineePojo nominee = nomineeList[index];
                              return nomineeCard(nominee, index);
                            },
                          ),
                        ),
                        n1Card(),
                        SizedBox(height: 16),
                        Visibility(
                          visible: nomineeList.length < 3 && !emptyNominee,
                          child: PlainButton(
                            onPressed: () {
                              String birthDateStr = "";
                              birthDateStr = convertDtToStr(n1Dob);
                              DateFormat dateFormat = DateFormat("dd-MM-yyyy");
                              // Parse the birthdate string to a DateTime object
                              DateTime birthDate =
                                  DateFormat('dd-MM-yyyy').parse(birthDateStr);

                              // Get the current date
                              DateTime currentDate = DateTime.now();

                              // Calculate the age
                              int age = currentDate.year - birthDate.year;
                              print("age $age");
                              if (nomineeList.isEmpty) {
                                if (n1Name.isEmpty) {
                                  Utils.showError(
                                      context, "Please Enter Nominee Name");
                                  return;
                                }
                                if (n1Type == "Minor") {
                                  if (age > 18 || age == 0) {
                                    Utils.showError(context,
                                        "Please Enter Nominee Age Below 18");
                                    return;
                                  }
                                  if (n1GuardianName.isEmpty) {
                                    Utils.showError(context,
                                        "Please Enter The Guardian Name");
                                    return;
                                  }
                                  if (n1GuardianPan.isEmpty) {
                                    Utils.showError(context,
                                        "Please Enter The Guardian PAN");
                                    return;
                                  }
                                } else {
                                  if (age < 18 || age == 0) {
                                    Utils.showError(context,
                                        "Please Enter Nominee Age 18 or above");
                                    return;
                                  }
                                }

                                if (n1Addr1.isEmpty) {
                                  Utils.showError(
                                      context, "Please Enter The Address 1");
                                  return;
                                }
                                if (n1Pincode.isEmpty) {
                                  Utils.showError(
                                      context, "Please Enter The Pincode");
                                  return;
                                }
                                if (n1City.isEmpty) {
                                  Utils.showError(
                                      context, "Please Enter The City");
                                  return;
                                }
                                if (n1State.isEmpty) {
                                  Utils.showError(
                                      context, "Please Enter The State");
                                  return;
                                }
                                if (n1Percentage == 0 || n1Percentage < 100) {
                                  Utils.showError(context,
                                      "Please Enter valid Nominee Percentage");
                                  return;
                                }
                                if (nomineeList.isEmpty && n1Name.isEmpty) {
                                  Utils.showError(context, "Name Required");
                                  return;
                                }
                                addFirstNominee();
                                print("Add 1st  button Clicked");
                              } else {
                                addBottomSheet();
                                print("bottomsheet button Clicked");
                              }
                            },
                            text:
                                "Add ${nomineeList.isEmpty ? "" : "More "}Nominee",
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (nomineeList.isNotEmpty || emptyNominee) continueBtn()
                ],
              ),
            ),
          );
        });
  }

  Widget continueBtn() {
    return CalculateButton(
      onPress: () async {
        List<String> nomineeString = [];

        if (emptyNominee) {
          int res = await saveNomineeInfo(context, []);
          if (res == 0) {
            Get.back(result: "ss");
          }
          return;
        }
        num total = 0;
        nomineeList.forEach((element) {
          total += element.nomineePercentage ?? 0;
        });
        if (total != 100) {
          Utils.showError(context,
              "Sum of ${nomineeList.length} nominee percentage should be 100");
          return;
        }

        nomineeList.forEach((element) {
          Map data = element.toJson();
          nomineeString.add(jsonEncode(data));
        });
        for (int i = 0; i < nomineeString.length; i++)
          print("nominee[$i] = ${nomineeString[i]}");

        int res = await saveNomineeInfo(context, nomineeString);
        if (res == 0) Get.back();
      },
      text: "Continue",
    );
  }

  Future saveNomineeInfo(BuildContext context, List nomineeString) async {
    Map data = await CommonOnBoardApi.saveNomineeInfo(
      user_id: user_id,
      client_name: client_name,
      number_of_nominee: nomineeString.length,
      nominee_details: nomineeString,
      bse_nse_mfu_flag: bse_nse_mfu_flag,
      no_nominee_flag: emptyNominee ? 1 : 0,
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    return 0;
  }

  addBottomSheet() {
    print("Came here To print bottom sheet");
    String name = "";

    String type = "Major (Above 18 yrs)";
    ExpansionTileController typeController = ExpansionTileController();

    Map temp = relationList.first;
    String relation = temp['desc'];
    String relationCode = temp['code'];
    ExpansionTileController relationController = ExpansionTileController();

    NomineeController tempController =
        NomineeController(defaultCode: relationCode, defaultDesc: relation);

    Map tempRelation = guardianRelationList.first;
    String defDesc = tempRelation['desc'];
    String defCode = tempRelation['code'];
    NomineeController tempGuardianRelationController =
        NomineeController(defaultCode: defCode, defaultDesc: defDesc);
    DateTime dob = DateTime.now();

    num percentage = 0;
    String guardianName = "", guardianPan = "";
    DateTime guardianDob = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SizedBox(
              height: devHeight * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BottomSheetTitle(title: "Add/Edit Nominee"),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          AmountInputCard(
                            title: "Nominee Name",
                            hasSuffix: false,
                            keyboardType: TextInputType.name,
                            onChange: (val) {
                              name = val;
                            },
                            suffixText: '',
                            borderRadius: BorderRadius.circular(20),
                          ),

                          SizedBox(height: 16),
                          // #region nominee type
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                controller: typeController,
                                title: Text("Nominee Type",
                                    style: AppFonts.f50014Black),
                                subtitle: Text(type, style: AppFonts.f50012),
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: typeList.length,
                                    itemBuilder: (context, index) {
                                      String title = typeList[index];

                                      return InkWell(
                                        onTap: () {
                                          type = title;
                                          typeController.collapse();
                                          bottomState(() {});
                                        },
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: title,
                                              groupValue: type,
                                              onChanged: (value) {
                                                type = title;
                                                typeController.collapse();
                                                bottomState(() {});
                                              },
                                            ),
                                            Text(title,
                                                style: AppFonts.f50014Grey),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          // #endregion

                          SizedBox(height: 16),
                          dateCard(
                            title: "DOB",
                            dob: dob,
                            onTap: () async {
                              DateTime? temp = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1880),
                                  initialDate: dob,
                                  lastDate: DateTime.now());
                              if (temp == null) return;
                              dob = temp;
                              bottomState(() {});
                            },
                          ),

                          Visibility(
                            visible: type == "Minor",
                            child: Column(
                              children: [
                                SizedBox(height: 16),
                                AmountInputCard(
                                    title: "Guardian Name",
                                    keyboardType: TextInputType.name,
                                    suffixText: "",
                                    onChange: (val) {
                                      guardianName = val;
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    hasSuffix: false),
                                SizedBox(height: 16),
                                AmountInputCard(
                                    title: "Guardian PAN",
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    keyboardType: TextInputType.name,
                                    suffixText: "",
                                    onChange: (val) {
                                      guardianPan = val;
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    hasSuffix: false),
                                SizedBox(height: 16),
                                dateCard(
                                  title: "Guardian DOB",
                                  dob: guardianDob,
                                  onTap: () async {
                                    DateTime? temp = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime(2002, 06, 18),
                                        firstDate: DateTime(1880),
                                        lastDate: DateTime.now());
                                    if (temp == null) return;
                                    guardianDob = temp;
                                    bottomState(() {});
                                  },
                                ),
                                SizedBox(height: 16),
                                tempGuardianRelationController
                                    .nomineeRelationTile(context,
                                        title: "Guardian Relation",
                                        relationList: guardianRelationList),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          tempController.nomineeRelationTile(
                              relationList: relationList,
                              title: "Nominee Relation",
                              context),

                          SizedBox(height: 16),

                          AmountInputCard(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              MaxValueCorrectionFormatter(100),
                            ],
                            title: "Nominee Percentage",
                            suffixText: "%",
                            keyboardType: TextInputType.number,
                            onChange: (val) {
                              percentage = num.tryParse(val) ?? 0;
                            },
                          ),
                          SizedBox(height: 16),

                          PlainButton(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            text: "Add",
                            onPressed: () async {
                              String bottombirthDateStr = "";
                              bottombirthDateStr = convertDtToStr(dob);
                              print("bottombirthDateStr $bottombirthDateStr");
                              DateFormat dateFormat = DateFormat("dd-MM-yyyy");
                              // Parse the birthdate string to a DateTime object
                              DateTime birthDate = DateFormat('dd-MM-yyyy')
                                  .parse(bottombirthDateStr);

                              // Get the current date
                              DateTime currentDate = DateTime.now();

                              // Calculate the age
                              int age = currentDate.year - birthDate.year;
                              print("bottomage $age");

                              if (name.isEmpty) {
                                Utils.showError(
                                    context, "Please Enter Nominee Name");
                                return;
                              }
                              if (type == "Minor") {
                                if (age > 18 || age == 0) {
                                  Utils.showError(context,
                                      "Please Enter Nominee Age Below 18");
                                  return;
                                }
                                print("n1GuardianName $n1GuardianName");
                                if (guardianName.isEmpty) {
                                  Utils.showError(context,
                                      "Please Enter The Guardian Name");
                                  return;
                                }
                                if (guardianPan.isEmpty) {
                                  Utils.showError(
                                      context, "Please Enter The Guardian PAN");
                                  return;
                                }
                              } else {
                                if (age < 18) {
                                  Utils.showError(context,
                                      "Please Enter Nominee Age 18 or above");
                                  return;
                                }
                              }
                              if (percentage == 0) {
                                Utils.showError(
                                    context, "Please Enter Nominee Percentage");
                                return;
                              }
                              if (name.isEmpty || percentage == 0) {
                                EasyLoading.showError(
                                    "All Fields are Mandatory");
                                return;
                              }

                              NomineePojo nominee = NomineePojo(
                                  nomineeId: nomineeList.length + 1,
                                  nomineeType: getTypeCode(type),
                                  nomineeTypeDesc: type,
                                  nomineeName: name,
                                  nomineeGuardName: getTypeCode(type) == "Y"
                                      ? guardianName
                                      : "",
                                  nomineeGuardPan: getTypeCode(type) == "Y"
                                      ? guardianPan
                                      : "",
                                  nomineeGuardDob: getTypeCode(type) == "Y"
                                      ? convertDtToStr(guardianDob)
                                      : "",
                                  nomineeAddress1: "",
                                  nomineeAddress2: "",
                                  nomineeAddress3: "",
                                  nomineePincode: "",
                                  nomineeCity: "",
                                  nomineeState: "",
                                  nomineeDob: convertDtToStr(dob),
                                  nomineeRelation:
                                      tempController.relationCode.value,
                                  nomineePercentage: percentage,
                                  guardRelation: getTypeCode(type) == "Y"
                                      ? tempGuardianRelationController
                                          .relationCode.value
                                      : "");
                              print(
                                  "guard relation  ----> ${tempGuardianRelationController.relationCode.value}");

                              nomineeList.add(nominee);
                              Get.back();
                              setState(() {});
                            },
                          ),
                          SizedBox(height: devHeight * 0.3),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String getTypeCode(String type) {
    return (type == "Minor") ? "Y" : "N";
  }

  editBottomSheet(NomineePojo nominee, int index) {
    String name = "${nominee.nomineeName}";

    String type = "${nominee.nomineeTypeDesc}";
    //type = getTypeCode(type);

    print("Type Nominee ${type}");

    String typeCode = "${nominee.nomineeType}";
    ExpansionTileController typeController = ExpansionTileController();

    String relationCode = nominee.nomineeRelation ?? "";
    String relation = getNomineeDesc(relationCode);
    NomineeController tempController =
        NomineeController(defaultCode: relationCode, defaultDesc: relation);

    String guardRelationCode = nominee.guardRelation ?? "";
    String guardRelation = getGuardianDesc(guardRelationCode);

    print("guardRelationCode $guardRelationCode");
    print("guardRelation $guardRelation");

    NomineeController guardianController = Get.put(NomineeController(
        defaultDesc: guardRelation, defaultCode: guardRelationCode));

    DateTime dob = convertStrToDt(nominee.nomineeDob!);

    num percentage = nominee.nomineePercentage ?? 0;
    String guardianName = nominee.nomineeGuardName ?? "";
    TextEditingController guardianPanController = TextEditingController();
    guardianPanController.text = nominee.nomineeGuardPan ?? '';

    print("guardianName $guardianName");
    print("guardianPan ${guardianPanController.text}");
    DateTime guardianDob =
        DateTime.tryParse(nominee.nomineeGuardDob ?? "") ?? DateTime.now();

    Future<bool> checkPanKycStatus() async {
      EasyLoading.show();

      Map data = await CommonOnBoardApi.checkPanKycStatus(
          user_id: user_id,
          client_name: client_name,
          pan: guardianPanController.text);

      if (data['status'] != 200) {
        return false;
      }

      EasyLoading.dismiss();

      return true;
    }

    Future<bool> validateMinor() async {
      NomineeType type = getTypeCode(nominee.nomineeTypeDesc ?? 'Major') == 'Y'
          ? NomineeType.minor
          : NomineeType.major;
      if (type == NomineeType.minor) {
        if (guardianName.isEmpty) {
          Utils.showError(context, 'Please Provide Guardian Name');
          return false;
        }
        if (guardianPanController.text.isEmpty || !await checkPanKycStatus()) {
          Utils.showError(context, 'Please Provide a valid Guardian Pan');
          return false;
        }
      }
      return true;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SizedBox(
              height: devHeight * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BottomSheetTitle(title: "Add/Edit Nominee"),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          AmountInputCard(
                            title: "Nominee Name",
                            hasSuffix: false,
                            initialValue: name,
                            keyboardType: TextInputType.name,
                            onChange: (val) {
                              name = val;
                            },
                            suffixText: '',
                            borderRadius: BorderRadius.circular(20),
                          ),

                          SizedBox(height: 16),
                          // #region nominee type
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                controller: typeController,
                                title: Text("Nominee Type",
                                    style: AppFonts.f50014Black),
                                subtitle: Text(type, style: AppFonts.f50012),
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: typeList.length,
                                    itemBuilder: (context, index) {
                                      String title = typeList[index];

                                      return InkWell(
                                        onTap: () {
                                          type = title;
                                          typeCode = getTypeCode(type);

                                          typeController.collapse();
                                          bottomState(() {});
                                        },
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: title,
                                              groupValue: type,
                                              onChanged: (value) {
                                                type = title;
                                                typeCode = getTypeCode(type);
                                                typeController.collapse();
                                                bottomState(() {});
                                              },
                                            ),
                                            Text(title,
                                                style: AppFonts.f50014Grey),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          // #endregion

                          SizedBox(height: 16),
                          dateCard(
                            title: "DOB",
                            dob: dob,
                            onTap: () async {
                              DateTime? temp = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1880),
                                  initialDate:
                                      convertStrToDt(nominee.nomineeDob ?? ""),
                                  lastDate: DateTime.now());
                              if (temp == null) return;
                              dob = temp;
                              setState(() {});
                            },
                          ),

                          Visibility(
                            visible: typeCode == "Y",
                            child: Column(
                              children: [
                                SizedBox(height: 16),
                                AmountInputCard(
                                    title: "Guardian Name",
                                    keyboardType: TextInputType.name,
                                    initialValue: guardianName,
                                    suffixText: "",
                                    onChange: (val) {
                                      guardianName = val;
                                      print("guardianName -- > $guardianName");
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    hasSuffix: false),
                                SizedBox(height: 16),
                                AmountInputCard(
                                    title: "Guardian PAN",
                                    keyboardType: TextInputType.name,
                                    suffixText: "",
                                    controller: guardianPanController,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    onChange: (val) {},
                                    borderRadius: BorderRadius.circular(20),
                                    hasSuffix: false),
                                SizedBox(height: 16),
                                dateCard(
                                  title: "Guardian DOB",
                                  dob: guardianDob,
                                  onTap: () async {
                                    DateTime? temp = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime(2002, 06, 18),
                                        firstDate: DateTime(1880),
                                        lastDate: DateTime.now());
                                    if (temp == null) return;
                                    guardianDob = temp;
                                    bottomState(() {});
                                  },
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                guardianController.nomineeRelationTile(
                                  title: "Guardian Relation",
                                  relationList: guardianRelationList,
                                  context,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 16,
                          ),

                          tempController.nomineeRelationTile(
                            context,
                            relationList: relationList,
                            title: "Nominee Relation",
                          ),
                          SizedBox(height: 16),
                          AmountInputCard(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              TextInputFormatter.withFunction(
                                  (oldValue, newValue) {
                                if (newValue.text.isEmpty) return newValue;

                                final value = double.tryParse(newValue.text);
                                if (value != null && value <= 100) {
                                  return newValue;
                                }
                                return oldValue;
                              }),
                              // LengthLimitingTextInputFormatter(3),
                            ],
                            title: "Nominee Percentage",
                            suffixText: "%",
                            initialValue: "$percentage",
                            keyboardType: TextInputType.number,
                            onChange: (val) {
                              percentage = num.tryParse(val) ?? 0;
                            },
                          ),
                          SizedBox(height: 16),
                          PlainButton(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            text: "Update",
                            onPressed: () async {
                              if (!await validateMinor()) return;
                              NomineePojo newNominee = NomineePojo(
                                  nomineeId: index + 1,
                                  nomineeType: getTypeCode(type),
                                  nomineeTypeDesc: nominee.nomineeTypeDesc,
                                  nomineeName: name,
                                  nomineeGuardName: getTypeCode(type) == "Y"
                                      ? guardianName
                                      : "",
                                  nomineeGuardPan: getTypeCode(type) == "Y"
                                      ? guardianPanController.text
                                      : "",
                                  nomineeGuardDob: getTypeCode(type) == "Y"
                                      ? convertDtToStr(guardianDob)
                                      : "",
                                  nomineeAddress1: nominee.nomineeAddress1,
                                  nomineeAddress2: nominee.nomineeAddress2,
                                  nomineeAddress3: nominee.nomineeAddress3,
                                  nomineePincode: nominee.nomineePincode,
                                  nomineeCity: nominee.nomineeCity,
                                  nomineeState: nominee.nomineeState,
                                  nomineeDob: convertDtToStr(dob),
                                  nomineeRelation:
                                      tempController.relationCode.value,
                                  nomineePercentage: percentage,
                                  guardRelation: getTypeCode(type) == "Y"
                                      ? guardianRelationController
                                          .relationCode.value
                                      : "");

                              nomineeList.removeAt(index);
                              nomineeList.insert(index, newNominee);
                              print(
                                  "guard relation ${tempController.relationCode.value}");
                              print(
                                  "nominee relation ${nomineeController.relationCode.value}");
                              Get.back();
                              setState(() {});
                            },
                          ),
                          SizedBox(height: devHeight * 0.3),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void addFirstNominee() {
    NomineePojo nominee = NomineePojo(
      nomineeId: 1,
      nomineeType: getTypeCode(n1Type),
      nomineeTypeDesc: n1Type,
      nomineeName: n1Name,
      nomineeDob: convertDtToStr(n1Dob),
      nomineeGuardName: getTypeCode(n1Type) == "Y" ? n1GuardianName : "",
      nomineeGuardPan: getTypeCode(n1Type) == "Y" ? n1GuardianPan : "",
      nomineeGuardDob:
          getTypeCode(n1Type) == "Y" ? convertDtToStr(n1GuardianDob) : "",
      nomineeAddress1: n1Addr1,
      nomineeAddress2: n1Addr2,
      nomineeAddress3: n1Addr3,
      nomineePincode: n1Pincode,
      nomineeCity: n1City,
      nomineeState: n1State,
      nomineeRelation: nomineeController.relationCode.value,
      nomineePercentage: n1Percentage,
      guardRelation: getTypeCode(n1Type) == "Y"
          ? guardianRelationController.relationCode.value
          : "",
    );

    nomineeList.add(nominee);
    setState(() {});
  }

  String getNomineeDesc(String? code) {
    if (code == null || code.isEmpty) return "";
    try {
      Map tempRelation = relationList.firstWhere(
        (element) => element['code'] == code,
        orElse: () => {'desc': 'Unknown'}, // Provide default value if not found
      );
      return tempRelation['desc'];
    } catch (e) {
      print("Error getting nominee description for code $code: $e");
      return "Unknown"; // Fallback value if anything goes wrong
    }
  }

  String getGuardianDesc(String? code) {
    print("code $code");
    if (code == null || code.isEmpty) {
      final tempMap = guardianRelationList[0];
      return tempMap['desc'];
    }
    try {
      print("guardianRelationList ${guardianRelationList.length}");
      Map tempGuardianRelation = guardianRelationList.firstWhere(
        (element) => element['code'] == code,
        orElse: () => {'desc': 'Unknown'}, // Provide default value if not found
      );
      print("tempGuardianRelation  ${tempGuardianRelation['desc']}");
      return tempGuardianRelation['desc'];
    } catch (e) {
      print("Error getting guardian description for code $code: $e");
      return "Unknown"; // Fallback value if anything goes wrong
    }
  }

  Widget nomineeCard(NomineePojo nominee, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.white),
      child: InkWell(
        onTap: () {
          editBottomSheet(nominee, index);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Nominee - ${index + 1} ", style: AppFonts.f50014Black),
                Text(
                  " (${nominee.nomineePercentage} %)",
                  style: AppFonts.f50014Theme,
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    removeAlert(index);
                  },
                  child: Text("Remove",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Config.appTheme.themeColor)),
                )
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: ColumnText(
                        title: "Name", value: "${nominee.nomineeName}")),
                Expanded(
                    child: ColumnText(
                        title: "Relation",
                        value: getNomineeDesc(nominee.nomineeRelation))),
              ],
            )
          ],
        ),
      ),
    );
  }

  removeAlert(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Remove"),
          content: Text("Are you sure to remove ?"),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('Cancel')),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Config.appTheme.themeColor,
                    foregroundColor: Colors.white),
                onPressed: () {
                  // n1Dob = DateTime.now();
                  // n1Name = "";
                  // n1Percentage = 100;
                  // n1GuardianName = "";
                  // n1GuardianPan = "";
                  // n1GuardianDob = DateTime.now();
                  // n1Addr1 = "";
                  // n1Addr2 = "";
                  // n1Addr3 = "";
                  // n1City = "";
                  // n1State = "";
                  // n1Pincode = "";

                  nomineeList.removeAt(index);
                  Get.back();
                  setState(() {});
                },
                child: Text('Remove'))
          ],
        );
      },
    );
  }

  DateTime n1Dob = DateTime.now();
  String n1Name = "";
  num n1Percentage = 100;
  String n1GuardianName = "";
  String n1GuardianPan = "";
  DateTime n1GuardianDob = DateTime.now();
  String n1Addr1 = "", n1Addr2 = "", n1Addr3 = "";
  String n1City = "", n1State = "", n1Pincode = "";

  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  Widget n1Card() {
    return Visibility(
      visible: nomineeList.isEmpty && !emptyNominee,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset("assets/registration/n1.png", height: 32),
              SizedBox(width: 5),
              Text("1st Nominee Details", style: AppFonts.f50014Grey),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                  value: emptyNominee,
                  onChanged: (val) {
                    emptyNominee = !emptyNominee;
                    setState(() {});
                  }),
              Expanded(
                  child:
                      Text("I don't want to specify a nominee at this time")),
            ],
          ),
          SizedBox(height: 16),
          n1TypeTile(),
          SizedBox(height: 16),
          AmountInputCard(
              title: "1st Nominee Name",
              keyboardType: TextInputType.name,
              suffixText: "",
              onChange: (val) {
                n1Name = val;
              },
              borderRadius: BorderRadius.circular(20),
              hasSuffix: false),
          SizedBox(height: 16),
          dateCard(
            title: "1st Nominee DOB",
            dob: n1Dob,
            onTap: () async {
              DateTime? temp = await showDatePicker(
                  context: context,
                  initialDate: n1Dob,
                  firstDate: DateTime(1880),
                  lastDate: DateTime.now());
              if (temp == null) return;
              n1Dob = temp;
              setState(() {});
            },
          ),
          Visibility(
            visible: n1Type == "Minor",
            child: Column(
              children: [
                SizedBox(height: 16),
                AmountInputCard(
                    title: "Guardian Name",
                    keyboardType: TextInputType.name,
                    suffixText: "",
                    onChange: (val) {
                      n1GuardianName = val;
                    },
                    borderRadius: BorderRadius.circular(20),
                    hasSuffix: false),
                SizedBox(height: 16),
                AmountInputCard(
                    title: "Guardian PAN",
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.characters,
                    suffixText: "",
                    onChange: (val) {
                      n1GuardianPan = val;
                    },
                    borderRadius: BorderRadius.circular(20),
                    hasSuffix: false),
                SizedBox(height: 16),
                dateCard(
                  title: "Guardian DOB",
                  dob: n1GuardianDob,
                  onTap: () async {
                    DateTime? temp = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2002, 06, 18),
                        firstDate: DateTime(1880),
                        lastDate: DateTime.now());
                    if (temp == null) return;
                    n1GuardianDob = temp;
                    setState(() {});
                  },
                ),
                guardianRelationController.nomineeRelationTile(context,
                    title: "Guardian Relation",
                    relationList: guardianRelationList),
                SizedBox(height: 16),
              ],
            ),
          ),
          AmountInputCard(
              title: "Address 1",
              keyboardType: TextInputType.name,
              suffixText: "",
              onChange: (val) {
                n1Addr1 = val;
              },
              borderRadius: BorderRadius.circular(20),
              hasSuffix: false),
          SizedBox(height: 16),
          AmountInputCard(
              title: "Address 2 (Optional)",
              keyboardType: TextInputType.name,
              suffixText: "",
              onChange: (val) {
                n1Addr2 = val;
              },
              borderRadius: BorderRadius.circular(20),
              hasSuffix: false),
          SizedBox(height: 16),
          AmountInputCard(
              title: "Address 3 (Optional)",
              keyboardType: TextInputType.name,
              suffixText: "",
              onChange: (val) {
                n1Addr3 = val;
              },
              borderRadius: BorderRadius.circular(20),
              hasSuffix: false),
          SizedBox(height: 16),
          AmountInputCard(
              title: "Pincode",
              suffixText: "",
              onChange: (val) async {
                n1Pincode = val;
                if (n1Pincode.length != 6) return;
                Map data = await CommonOnBoardApi.getCityStateByPincode(
                    user_id: user_id, client_name: client_name, pincode: val);
                if (data['status'] != 200) {
                  Utils.showError(context, data['msg']);
                  return;
                }
                Map result = data['result'];
                setState(() {
                  cityController.text = "${result['city']}";
                  stateController.text = "${result['state']}";
                  n1City = "${result['city']}";
                  n1State = "${result['state']}";
                });
              },
              borderRadius: BorderRadius.circular(20),
              hasSuffix: false),
          SizedBox(height: 16),
          AmountInputCard(
              title: "City",
              keyboardType: TextInputType.name,
              controller: cityController,
              suffixText: "",
              onChange: (val) {
                n1City = val;
              },
              borderRadius: BorderRadius.circular(20),
              hasSuffix: false),
          SizedBox(height: 16),
          AmountInputCard(
              title: "State",
              keyboardType: TextInputType.name,
              controller: stateController,
              suffixText: "",
              onChange: (val) {
                n1State = val;
              },
              borderRadius: BorderRadius.circular(20),
              hasSuffix: false),
          SizedBox(height: 16),
          // n1RelationTile(),
          nomineeController.nomineeRelationTile(context,
              relationList: relationList, title: "1st Nominee Relation"),

          SizedBox(height: 16),
          AmountInputCard(
            title: "1st Nominee Percentage",
            suffixText: "%",
            initialValue: "100",
            keyboardType: TextInputType.number,
            onChange: (val) {
              n1Percentage = num.tryParse(val) ?? 0;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget dateCard({
    required String title,
    required DateTime dob,
    Function()? onTap,
  }) {
    String subTitle = dob.toString().split(" ").first;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: devWidth,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppFonts.f50014Black),
            SizedBox(height: 4),
            Text(subTitle, style: AppFonts.f50012),
          ],
        ),
      ),
    );
  }

  String n1Type = "Major (Above 18 yrs)";
  ExpansionTileController n1TypeController = ExpansionTileController();

  Widget n1TypeTile() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: n1TypeController,
          title: Text("1st Nominee Type", style: AppFonts.f50014Black),
          subtitle: Text(n1Type, style: AppFonts.f50012),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: typeList.length,
              itemBuilder: (context, index) {
                String title = typeList[index];

                return InkWell(
                  onTap: () {
                    n1Type = title;
                    n1TypeController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: title,
                        groupValue: n1Type,
                        onChanged: (value) {
                          n1Type = title;
                          n1TypeController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(title, style: AppFonts.f50014Grey),
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
}

enum NomineeType {
  major,
  minor,
}

class MaxValueCorrectionFormatter extends TextInputFormatter {
  final int maxValue;

  MaxValueCorrectionFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final value = int.tryParse(newValue.text);

    if (value == null) return oldValue;
    if (value > maxValue) {
      return TextEditingValue(
        text: maxValue.toString(),
        selection: TextSelection.collapsed(offset: maxValue.toString().length),
      );
    }
    return newValue;
  }
}
