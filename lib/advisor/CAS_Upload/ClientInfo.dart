import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/api/onBoarding/CommonOnBoardApi.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/Loading.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class ClientInfo extends StatefulWidget {
  const ClientInfo({super.key});

  @override
  State<ClientInfo> createState() => _ClientInfoState();
}

class _ClientInfoState extends State<ClientInfo> {
  int userId = GetStorage().read("mfd_id") ?? 0;
  String clientName = GetStorage().read("client_name") ?? "null";
  String mobile = GetStorage().read("mfd_mobile") ?? "null";
  late double devHeight, devWidth;
  final nameController = TextEditingController();
  final panController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  ExpansionTileController customerTypeController = ExpansionTileController();
  ExpansionTileController dobcontroller = ExpansionTileController();
  ExpansionTileController countryOfBrithController = ExpansionTileController();
  ExpansionTileController empStatusController = ExpansionTileController();
  ExpansionTileController annualSalaryController = ExpansionTileController();
  ExpansionTileController sourceIncomeController = ExpansionTileController();
  DateTime selectedDob = DateTime.now();
  ExpansionTileController politicalRelationshipController =
      ExpansionTileController();
  TextStyle underlineText = TextStyle(
      color: Config.appTheme.themeColor,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w500,
      fontSize: 14);
  DateTime? dob;
  TextEditingController dobController = TextEditingController();

  DateTime selectedFolioDate = DateTime.now();
  ExpansionTileController controller1 = ExpansionTileController();
  ExpansionTileController controller2 = ExpansionTileController();
  bool isToday = true;

  String mobileRelation = "";
  String mobileRelationCode = "";

  String employementStatus = "Agriculturist";
  String employementStatusCode = "4";

  String emailRelation = "";
  String emailRelationCode = "";
  String birthCountry = "India";
  String birthCountryCode = "IND";

  String annualSalary = "Below 1 Lakh";
  String annualSalaryCode = "BL";

  String incomeSource = "";
  String incomeSourceCode = "";

  String politicalRelation = "";
  String politicalRelationCode = "";

  String email = "", birthPlace = "";

  String getGenderByCode(String? code) {
    if (code == "M") return "Male";
    if (code == "F") return "Female";
    if (code == "O") return "Others";
    return "";
  }

  String pincode = "",
      city = "",
      state = "",
      stateCode = "",
      address1 = "",
      address2 = "",
      address3 = "",
      country = "India";

  String selectedRmName = "Select RM";
  List rmList = [];
  List subBrokerList = [];
  String selectedSubBroker = "Select Associate";
  String? statusType = "Major";
  String? clientStatus = "Active";
  String? loginStatus = "Enable";

  Future getAllRM() async {
    if (rmList.isNotEmpty) return 0;
    Map data =
        await Api.getAllRM(mobile: mobile, client_name: clientName, branch: "");

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    rmList = List<String>.from(data['list']);
    rmList.insert(0, "All");
    //  selectedRmName = rmList[0];
    return 0;
  }

  Future getAllSubBroker() async {
    if (subBrokerList.isNotEmpty) return 0;
    Map data = await Api.getAllSubbroker(
        mobile: mobile,
        client_name: clientName,
        rm_name: selectedRmName == "All" ? "" : selectedRmName);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    subBrokerList = List<String>.from(data['list']);
    subBrokerList.insert(0, "All");
    return 0;
  }

  Future getDatas() async {
    EasyLoading.show();
    await getAllRM();
    await getAllSubBroker();
    EasyLoading.dismiss();
    return 0;
  }

  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  Future getCityStateByPincode() async {
    Map data = await CommonOnBoardApi.getCityStateByPincode(
      user_id: userId,
      client_name: clientName,
      pincode: pincode,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    city = data['result']['city'];
    state = data['result']['state'];
    stateCode = data['result']['state_code'];

    cityController.text = city;
    stateController.text = state;

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: rpAppBar(
                title: "Create Client",
                bgColor: Config.appTheme.themeColor,
                foregroundColor: Colors.white),
            body: (!snapshot.hasData)
                ? Loading()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              statusCard(context),
                              SizedBox(height: 16),
                              nameCard(),
                              SizedBox(height: 16),
                              panCard(),
                              DottedLine(verticalPadding: 8),
                              mobileCard(),
                              SizedBox(height: 16),
                              emailCard(),
                              DottedLine(verticalPadding: 8),
                              dobExpansionTile(context),
                              SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {},
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Add Anniversary Date",
                                    style: underlineText,
                                  ),
                                ),
                              ),
                              DottedLine(verticalPadding: 8),
                              AmountInputCard(
                                title: 'Pin Code',
                                suffixText: '',
                                initialValue: pincode,
                                hasSuffix: false,
                                keyboardType: TextInputType.number,
                                borderRadius: BorderRadius.circular(20),
                                onChange: (val) async {
                                  pincode = val;
                                  if (pincode.length != 6) return;
                                  await getCityStateByPincode();
                                  setState(() {});
                                },
                              ),
                              SizedBox(height: 16),
                              AmountInputCard(
                                title: 'City',
                                controller: cityController,
                                suffixText: '',
                                hasSuffix: false,
                                keyboardType: TextInputType.name,
                                borderRadius: BorderRadius.circular(20),
                                onChange: (val) {
                                  setState(() {
                                    city = val;
                                  });
                                  cityController.text = val;
                                },
                              ),
                              SizedBox(height: 16),
                              AmountInputCard(
                                title: 'State',
                                controller: stateController,
                                suffixText: '',
                                hasSuffix: false,
                                keyboardType: TextInputType.name,
                                borderRadius: BorderRadius.circular(20),
                                onChange: (val) {
                                  setState(() {
                                    state = val;
                                  });
                                  stateController.text = val;
                                },
                              ),
                              SizedBox(height: 16),
                              AmountInputCard(
                                title: 'Address Line 1',
                                suffixText: '',
                                initialValue: address1,
                                hasSuffix: false,
                                keyboardType: TextInputType.name,
                                borderRadius: BorderRadius.circular(20),
                                onChange: (val) => address1 = val,
                              ),
                              SizedBox(height: 16),
                              AmountInputCard(
                                title: 'Address Line 2 [Optional]',
                                suffixText: '',
                                initialValue: address2,
                                hasSuffix: false,
                                keyboardType: TextInputType.name,
                                borderRadius: BorderRadius.circular(20),
                                onChange: (val) => address2 = val,
                              ),
                              SizedBox(height: 16),
                              AmountInputCard(
                                title: 'Address Line 3 [Optional]',
                                suffixText: '',
                                initialValue: '',
                                hasSuffix: false,
                                keyboardType: TextInputType.name,
                                borderRadius: BorderRadius.circular(20),
                                onChange: (val) => address3 = val,
                              ),
                              SizedBox(height: 16),
                              rmExpansionTile(context),
                              SizedBox(height: 16),
                              subBrokerExpansionTile(context),
                              SizedBox(height: 16),
                              customerTypeTile(context),
                              SizedBox(height: 16),
                              clientStatusCard(context),
                              SizedBox(height: 16),
                              loginStatusCard(context),
                              SizedBox(height: 32),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () async {
                                print("clientStatus ${nameController.text}");
                                print("clientStatus ${panController.text}");
                                print("clientStatus ${mobileController.text}");
                                print("clientStatus ${emailController.text}");
                                print("clientStatus $selectedDob");
                                print("clientStatus $pincode");
                                print("clientStatus $city");
                                print("clientStatus $state");
                                print("clientStatus $address1");
                                print("clientStatus $address2");
                                print("clientStatus $address3");
                                print("clientStatus $clientStatus");
                                print("loginStatus $loginStatus");
                                print("statusType $statusType");
                                // int isValid = validator();
                                // if (isValid != 0) {
                                //   Utils.showError(
                                //       context, "All Fields are Mandatory");
                                //   return;
                                // }
                                if (mobile.length != 10) {
                                  Utils.showError(
                                      context, "Invalid Mobile Number");
                                  return;
                                }
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: Config.appTheme.themeColor,
                                foregroundColor: Colors.white,
                              ),
                              child: Text("CREATE CLIENT"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        });
  }

  Widget nameCard() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Text(
            "Name as on PAN",
            style: AppFonts.f50014Black,
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: TextField(
              keyboardType: TextInputType.name,
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Name",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(
                      color: Config.appTheme.placeHolderInputTitleAndArrow,
                      width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide:
                      BorderSide(color: Config.appTheme.themeColor, width: 2.0),
                ),
              ),
              style: AppFonts.f50014Black,
            ),
          )
        ],
      ),
    );
  }

  Widget panCard() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Text(
            "PAN Number",
            style: AppFonts.f50014Black,
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: TextField(
              keyboardType: TextInputType.name,
              controller: panController,
              decoration: InputDecoration(
                hintText: "PAN",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(
                      color: Config.appTheme.placeHolderInputTitleAndArrow,
                      width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide:
                      BorderSide(color: Config.appTheme.themeColor, width: 2.0),
                ),
              ),
              style: AppFonts.f50014Black,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Image.asset("assets/check_circle.png", height: 22),
              SizedBox(width: 4),
              Text(
                'Congratulations! You are Mutual Fund KYC complaint.',
                style: AppFonts.f50012.copyWith(
                    fontSize: 10, color: Config.appTheme.defaultProfit),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget mobileCard() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Text(
            "Mobile Number",
            style: AppFonts.f50014Black,
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: TextField(
              keyboardType: TextInputType.phone,
              controller: mobileController,
              decoration: InputDecoration(
                hintText: "Mobile",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(
                      color: Config.appTheme.placeHolderInputTitleAndArrow,
                      width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide:
                      BorderSide(color: Config.appTheme.themeColor, width: 2.0),
                ),
              ),
              style: AppFonts.f50014Black,
            ),
          ),
        ],
      ),
    );
  }

  Widget emailCard() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Text(
            "Email Id",
            style: AppFonts.f50014Black,
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(
                      color: Config.appTheme.placeHolderInputTitleAndArrow,
                      width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide:
                      BorderSide(color: Config.appTheme.themeColor, width: 2.0),
                ),
              ),
              style: AppFonts.f50014Black,
            ),
          ),
        ],
      ),
    );
  }

  Widget statusCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                "Is client Major or Minor?",
                style: AppFonts.f50014Black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(
                  value: 'Major',
                  groupValue: statusType,
                  onChanged: (value) {
                    setState(() {
                      statusType = value;
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      statusType = 'Major';
                    });
                  },
                  child: Text(
                    'Major',
                    style: AppFonts.f50014Black.copyWith(
                      color: statusType == "Major"
                          ? Config.appTheme.themeColor
                          : Config.appTheme.readableGreyTitle,
                    ),
                  ),
                ),
                Radio(
                  value: 'Minor',
                  groupValue: statusType,
                  onChanged: (value) {
                    setState(() {
                      statusType = value;
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      statusType = 'Minor';
                    });
                  },
                  child: Text(
                    'Minor',
                    style: AppFonts.f50014Black.copyWith(
                      color: statusType == "Minor"
                          ? Config.appTheme.themeColor
                          : Config.appTheme.readableGreyTitle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget clientStatusCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
              child: Text(
                "Client Status",
                style: AppFonts.f50014Black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(
                  value: 'Active',
                  groupValue: clientStatus,
                  onChanged: (value) {
                    setState(() {
                      clientStatus = value;
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      clientStatus = 'Active';
                    });
                  },
                  child: Text(
                    'Active',
                    style: AppFonts.f50014Black.copyWith(
                      color: clientStatus == "Active"
                          ? Config.appTheme.themeColor
                          : Config.appTheme.readableGreyTitle,
                    ),
                  ),
                ),
                Radio(
                  value: 'Inactive',
                  groupValue: clientStatus,
                  onChanged: (value) {
                    setState(() {
                      clientStatus = value;
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      clientStatus = 'Inactive';
                    });
                  },
                  child: Text(
                    'Inactive',
                    style: AppFonts.f50014Black.copyWith(
                      color: clientStatus == "Inactive"
                          ? Config.appTheme.themeColor
                          : Config.appTheme.readableGreyTitle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget loginStatusCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
              child: Text(
                "Login Status",
                style: AppFonts.f50014Black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(
                  value: 'Enable',
                  groupValue: loginStatus,
                  onChanged: (value) {
                    setState(() {
                      loginStatus = value;
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      loginStatus = 'Enable';
                    });
                  },
                  child: Text(
                    'Enable',
                    style: AppFonts.f50014Black.copyWith(
                      color: loginStatus == "Enable"
                          ? Config.appTheme.themeColor
                          : Config.appTheme.readableGreyTitle,
                    ),
                  ),
                ),
                Radio(
                  value: 'Disable',
                  groupValue: loginStatus,
                  onChanged: (value) {
                    setState(() {
                      loginStatus = value;
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      loginStatus = 'Disable';
                    });
                  },
                  child: Text(
                    'Disable',
                    style: AppFonts.f50014Black.copyWith(
                      color: loginStatus == "Disable"
                          ? Config.appTheme.themeColor
                          : Config.appTheme.readableGreyTitle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int validator() {
    List list = [
      customerType,
      addressType,
      email,
      emailRelation,
      birthCountry,
    ];
    if (list.contains(""))
      return -1;
    else
      return 0;
  }

  List addressTypeList = [];
  String addressType = "";
  String addressTypeCode = "";
  ExpansionTileController addressController = ExpansionTileController();
  Widget addressTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: addressController,
            title: Text("Address Type", style: AppFonts.f50014Black),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(addressType, style: AppFonts.f50012),
              ],
            ),
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: addressTypeList.length,
                  itemBuilder: (context, index) {
                    Map map = addressTypeList[index];

                    String desc = map['desc'];
                    String code = map['code'];

                    return InkWell(
                      onTap: () {
                        addressType = desc;
                        addressTypeCode = code;
                        addressController.collapse();
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Radio(
                            value: code,
                            groupValue: addressTypeCode,
                            onChanged: (value) {
                              addressType = desc;
                              addressTypeCode = code;
                              addressController.collapse();
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

  Widget dobExpansionTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: dobcontroller,
            title: Text("DOB", style: AppFonts.f50014Black),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Utils.getFormattedDate(date: selectedDob),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Config.appTheme.themeColor)),
              ],
            ),
            children: [
              SizedBox(
                height: 200,
                child: ScrollDatePicker(
                  selectedDate: selectedDob,
                  onDateTimeChanged: (value) {
                    selectedDob = value;
                    setState(() {});
                  },
                ),
              ),
            ],
          )),
    );
  }

  Widget dateInput(
      {required String title,
      Function()? onTap,
      String? initialValue,
      TextEditingController? controller}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppFonts.f50014Black),
          SizedBox(height: 5),
          TextFormField(
            readOnly: true,
            onTap: onTap,
            controller: controller,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                focusedBorder: borderStyle,
                enabledBorder: borderStyle),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder borderStyle = OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.lineColor),
      borderRadius: BorderRadius.circular(20));

  List customerTypeList = [
    "A",
    "B",
    "C",
  ];
  String customerType = "A";
  Widget customerTypeTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: customerTypeController,
          title: Text("Customer Type", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(customerType, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: customerTypeList.length,
              itemBuilder: (context, index) {
                String temp = customerTypeList[index];

                return InkWell(
                  onTap: () {
                    customerType = temp;
                    customerTypeController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: customerType,
                        onChanged: (value) {
                          customerType = temp;
                          customerTypeController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(temp, style: AppFonts.f50014Grey),
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

  ExpansionTileController subBrokerController = ExpansionTileController();
  Widget subBrokerExpansionTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: subBrokerController,
          title: Text("Associate Name", style: AppFonts.f50014Black),
          tilePadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedSubBroker,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Config.appTheme.themeColor,
                ),
              ),
              DottedLine(),
            ],
          ),
          children: [
            SizedBox(
              height: 100,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: subBrokerList.length,
                      itemBuilder: (context, index) {
                        String title = subBrokerList[index];

                        return InkWell(
                          onTap: () {
                            selectedSubBroker = title;
                            print("selectedSubBroker $selectedSubBroker");
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: title,
                                groupValue: selectedSubBroker,
                                onChanged: (temp) {
                                  selectedSubBroker = title;
                                  print("selectedSubBroker $selectedSubBroker");
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
            ),
          ],
        ),
      ),
    );
  }

  ExpansionTileController rmController = ExpansionTileController();
  Widget rmExpansionTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: rmController,
          title: Text("RM Name", style: AppFonts.f50014Black),
          tilePadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedRmName,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Config.appTheme.themeColor,
                ),
              ),
              DottedLine(),
            ],
          ),
          children: [
            SizedBox(
              height: 100,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: rmList.length,
                      itemBuilder: (context, index) {
                        String title = rmList[index];

                        return InkWell(
                          onTap: () {
                            selectedRmName = title;
                            print("selectedRmName $selectedRmName");
                            subBrokerList = [];
                            getAllSubBroker();
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: title,
                                groupValue: selectedRmName,
                                onChanged: (temp) {
                                  selectedRmName = title;
                                  print("selectedRmName $selectedRmName");
                                  subBrokerList = [];
                                  getAllSubBroker();
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
            ),
          ],
        ),
      ),
    );
  }
}
