import 'package:flutter/material.dart';
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

class UpdateNomineeInfo extends StatefulWidget {
  const UpdateNomineeInfo({
    super.key,
    required this.nomineeList,
    required this.bse_nse_mfu_flag,
    required this.relationList,
  });

  final List<NomineePojo> nomineeList;
  final List relationList;
  final String bse_nse_mfu_flag;

  @override
  State<UpdateNomineeInfo> createState() => _UpdateNomineeInfoState();
}

class _UpdateNomineeInfoState extends State<UpdateNomineeInfo> {
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  String bse_nse_mfu_flag = "";

  List<NomineePojo> nomineeList = [];

  Future saveNomineeInfo() async {
    Map data = await CommonOnBoardApi.saveNomineeInfo(
      user_id: user_id,
      client_name: client_name,
      bse_nse_mfu_flag: widget.bse_nse_mfu_flag,
      number_of_nominee: nomineeList.length,
      nominee_details: nomineeList,
      no_nominee_flag: emptyNominee ? 1 : 0,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    return 0;
  }

  List relationList = [];

  @override
  void initState() {
    //  implement initState
    super.initState();
    nomineeList = widget.nomineeList;
    relationList = widget.relationList;
    bse_nse_mfu_flag = widget.bse_nse_mfu_flag;
  }

  String getNomineeDesc(String? code) {
    if (code == null) return "null";
    Map tempRelation =
        relationList.firstWhere((element) => element['code'] == code);
    return tempRelation['desc'];
  }

  late double devHeight, devWidth;
  bool emptyNominee = false;

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;
    devHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: 'Nominee Info',
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: nomineeList.length,
              itemBuilder: (context, index) {
                return nomineeCard(nomineeList[index], index);
              },
            ),
          ),
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
          CalculateButton(
              onPress: () async {
                num total = 0;
                nomineeList.forEach((element) {
                  total += element.nomineePercentage ?? 0;
                });
                if (total != 100 && !emptyNominee) {
                  Utils.showError(context,
                      "Sum of ${nomineeList.length} nominee percentage should be 100");
                  return;
                }

                int res = await saveNomineeInfo();
                if (res == 0) Get.back();
              },
              text: "UPDATE")
        ],
      ),
    );
  }

  Widget nomineeCard(NomineePojo nominee, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.white),
      child: InkWell(
        onTap: () {
          print("relationList = $relationList");
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
                  onTap: () async {
                    // nomineeList.removeAt(index);
                    // List<String> nomineeString = [];
                    // nomineeList.forEach((element) {
                    //   Map data = element.toJson();
                    //   nomineeString.add(jsonEncode(data));
                    // });

                    // setState(() {});
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

  addBottomSheet() {
    String name = "";

    String type = "Major (Above 18 yrs)";
    ExpansionTileController typeController = ExpansionTileController();

    Map temp = relationList.first;
    String relation = temp['desc'];
    String relationCode = temp['code'];
    ExpansionTileController relationController = ExpansionTileController();

    NomineeController tempController = Get.put(
        NomineeController(defaultCode: relationCode, defaultDesc: relation));

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
                            maxLength: 50,
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
                              ],
                            ),
                          ),

                          tempController.nomineeRelationTile(
                              relationList: relationList,
                              title: "Nominee Relation",
                              context),

                          SizedBox(height: 16),
                          AmountInputCard(
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
                                  nomineeGuardName: guardianName,
                                  nomineeGuardPan: guardianPan,
                                  nomineeGuardDob: convertDtToStr(guardianDob),
                                  nomineeAddress1: "",
                                  nomineeAddress2: "",
                                  nomineeAddress3: "",
                                  nomineePincode: "",
                                  nomineeCity: "",
                                  nomineeState: "",
                                  nomineeDob: convertDtToStr(dob),
                                  nomineeRelation:
                                      tempController.relationCode.value,
                                  nomineePercentage: percentage);

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

  List typeList = ["Major (Above 18 yrs)", "Minor"];

  editBottomSheet(NomineePojo nominee, int index) {
    String name = "${nominee.nomineeName}";

    String type = "${nominee.nomineeTypeDesc}";
    String typeCode = "${nominee.nomineeType}";

    ExpansionTileController typeController = ExpansionTileController();

    String relationCode = nominee.nomineeRelation ?? "null";
    String relation = getNomineeDesc(relationCode);

    NomineeController tempController = Get.put(
        NomineeController(defaultDesc: relation, defaultCode: relationCode));
    tempController.setDefault(defaultDesc: relation, defaultCode: relation);

    DateTime dob = DateTime.now();

    num percentage = nominee.nomineePercentage ?? 0;
    String guardianName = nominee.nomineeGuardName ?? "",
        guardianPan = nominee.nomineeGuardPan ?? "";
    DateTime guardianDob =
        DateTime.tryParse(nominee.nomineeGuardDob ?? "") ?? DateTime.now();

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
                            maxLength: 50,
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
                                  initialDate: dob,
                                  firstDate: DateTime(1880),
                                  lastDate: DateTime.now());
                              if (temp == null) return;
                              dob = temp;
                              setState(() {});
                            },
                          ),

                          tempController.nomineeRelationTile(context,
                              relationList: relationList,
                              title: "Nominee Relation"),

                          Visibility(
                            visible: type == "Minor",
                            child: Column(
                              children: [
                                SizedBox(height: 16),
                                AmountInputCard(
                                    title: "Guardian Name",
                                    keyboardType: TextInputType.name,
                                    suffixText: "",
                                    initialValue: guardianName,
                                    onChange: (val) {
                                      guardianName = val;
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    hasSuffix: false),
                                SizedBox(height: 16),
                                AmountInputCard(
                                    title: "Guardian PAN",
                                    keyboardType: TextInputType.name,
                                    suffixText: "",
                                    initialValue: guardianPan,
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
                                        initialDate: guardianDob,
                                        firstDate: DateTime(1880),
                                        lastDate: DateTime.now());
                                    if (temp == null) return;
                                    guardianDob = temp;
                                    bottomState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 16),
                          AmountInputCard(
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
                              NomineePojo nominee = NomineePojo(
                                  nomineeId: index + 1,
                                  nomineeType: getTypeCode(type),
                                  nomineeTypeDesc: type,
                                  nomineeName: name,
                                  nomineeGuardName: guardianName,
                                  nomineeGuardPan: guardianPan,
                                  nomineeGuardDob: convertDtToStr(guardianDob),
                                  nomineeAddress1: "",
                                  nomineeAddress2: "",
                                  nomineeAddress3: "",
                                  nomineePincode: "",
                                  nomineeCity: "",
                                  nomineeState: "",
                                  nomineeDob: convertDtToStr(dob),
                                  nomineeRelation:
                                      tempController.relationCode.value,
                                  nomineePercentage: percentage);

                              nomineeList.removeAt(index);
                              nomineeList.insert(index, nominee);

                              Get.back();
                              setState(() {});
                            },
                          ),
                          SizedBox(height: 16),
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

  String getTypeCode(String type) {
    return (type == "Minor") ? "Y" : "N";
  }
}
