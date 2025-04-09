import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/Investor/ekyc/ekyc.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/api/onBoarding/CommonOnBoardApi.dart';
import 'package:mymfbox2_0/pojo/UserDataPojo.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpSmallTf.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class CreateClient extends StatefulWidget {
  const CreateClient({super.key});

  @override
  State<CreateClient> createState() => _CreateClientState();
}

class _CreateClientState extends State<CreateClient> {
  int mfd_id = GetStorage().read("mfd_id") ?? 0;
  int type_id = 0;
  String clientName = GetStorage().read("client_name") ?? "null";
  String adminMobile = GetStorage().read("mfd_mobile") ?? "null";
  Map client_code_map = GetStorage().read('client_code_map') ?? {};
  late double devHeight, devWidth;
  ExpansionTileController investorController = ExpansionTileController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  ExpansionTileController customerTypeController = ExpansionTileController();
  ExpansionTileController dobcontroller = ExpansionTileController();
  ExpansionTileController anniversaryController = ExpansionTileController();
  ExpansionTileController countryOfBrithController = ExpansionTileController();
  ExpansionTileController empStatusController = ExpansionTileController();
  ExpansionTileController sourceIncomeController = ExpansionTileController();
  final guardianNameController = TextEditingController();
  TextStyle successStyle = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 12, color: AppColors.textGreen);
  TextStyle errorStyle = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 12, color: AppColors.lossRed);

  DateTime? selectedDob;
  DateTime? selectedAnniversary;

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

  // String investorId = "";
  List investorList = [];
  int pageId = 1;
  String searchKey = "";

  String mobileRelation = "";
  String mobileRelationCode = "";

  String emailRelation = "";
  String emailRelationCode = "";

  String birthCountry = "India";
  String birthCountryCode = "IND";

  String incomeSource = "";
  String incomeSourceCode = "";

  String politicalRelation = "";
  String politicalRelationCode = "";

  String birthPlace = "";

  bool isAnniversary = false;

  String kycMsg = "";
  String successMsg = "The PAN is KYC complaint.";
  bool iconStatus = false;
  String selectedOptionType = "Create Client";
  String investorName = 'Select Investor';
  String getGenderByCode(String? code) {
    if (code == "M") return "Male";
    if (code == "F") return "Female";
    if (code == "O") return "Others";
    return "";
  }

  bool isFirst = true;
  String getFirst13(String text) {
    String s = text.split(":").last;
    if (s.length > 13) s = s.substring(0, 13);
    return s;
  }

  List<String> optionType = [
    "Create Client",
    "Edit Client",
  ];
  String name = "";
  TextEditingController guardNameController = TextEditingController();
  String mobile = "";
  String pan = "";
  TextEditingController panController = TextEditingController();
  TextEditingController guardPanController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController address3Controller = TextEditingController();
  String email = "";
  String addr = "";
  String rmName = "";
  String branch = "";
  String pincode = "",
      city = "",
      state = "",
      stateCode = "",
      address1 = "",
      address2 = "",
      address3 = "",
      country = "India";

  String selectedRmName = "";
  List rmList = [];
  List subBrokerList = [];
  String selectedSubBroker = "";
  String? statusType = "Major";
  String? clientStatus = "Active";
  String? loginStatus = "Enable";
  Timer? searchOnStop;

  Future getAllRM() async {
    rmList = [];
    if (rmList.isNotEmpty) return 0;
    // if (type_id != 5) return 0;
    Map data = await Api.getAllRM(
        mobile: adminMobile, client_name: clientName, branch: "");

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    rmList = List<String>.from(data['list']);
    //rmList.insert(0, "All");
    selectedRmName = rmList[0];
    setState(() {});
    return 0;
  }

  Future createClient() async {
    print("selected id = $selected_id");
    EasyLoading.show();
    Map data = await AdminApi.createClient(
        mfd_id: mfd_id,
        client_name: clientName,
        investor_id: (selected_id == 0) ? "" : "$selected_id",
        name: name,
        pan: pan,
        mobile: mobile,
        alter_mobile: "",
        email: email,
        alter_email: "",
        rm_name: selectedRmName,
        subbroker_name: selectedSubBroker,
        status: clientStatus == "Active" ? 1 : 0,
        address1: address1,
        address2: address2,
        address3: address3,
        city: cityController.text,
        pincode: pincodeController.text,
        state: stateController.text,
        country: "",
        phone_off: mobile,
        phone_res: "",
        dob: selectedDob == null ? "" : convertDtToStr(selectedDob!),
        anniversary_date: selectedAnniversary == null ? "" : convertDtToStr(selectedAnniversary!),
        occupation: "",
        guard_name: guardNameController.text,
        guard_pan: guardPanController.text,
        cust_type: customerType,
        cus_ref: "",
        login_status: loginStatus == "Enable" ? 1 : 0,
        salutation: "",
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    EasyLoading.dismiss();
    bool hasKyc = data['kyc_status'] ?? false;
    if (hasKyc)
      return 1;
    else
      return 2;
  }

  Future getAllSubBroker() async {
    if (subBrokerList.isNotEmpty) return 0;
    if (!(type_id == 5 || type_id == 2)) return 0;
    Map data = await Api.getAllSubbroker(
        mobile: adminMobile,
        client_name: clientName,
        rm_name: selectedRmName == "All" ? "" : selectedRmName);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    subBrokerList = List<String>.from(data['list']);
    // subBrokerList.insert(0, "All");
    if(subBrokerList.isNotEmpty){
      selectedSubBroker = subBrokerList[0];
    }
    return 0;
  }

  Future searchInvestor() async {
    investorList = [];
    EasyLoading.show(status: "Searching for `$searchKey`");
    Map data = await AdminApi.getInvestors(
        page_id: pageId,
        client_name: clientName,
        user_id: mfd_id,
        search: searchKey,
        branch: "",
        rmList: []);
    EasyLoading.dismiss();

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    List list = data['list'];
    investorList = List.from(list);
    setState(() {});
    return 0;
  }

  Future fetchMoreInvestor() async {
    pageId++;
    Map data = await AdminApi.getInvestors(
        page_id: pageId,
        client_name: clientName,
        user_id: mfd_id,
        branch: "",
        rmList: []);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    List list = data['list'];

    investorList.addAll(list);
    investorList = investorList.toSet().toList();

    setState(() {});
    return 0;
  }

  Future getInitialInvestor() async {
    if (!isFirst) return 0;

    Map data = await AdminApi.getInvestors(
        page_id: pageId,
        client_name: clientName,
        user_id: mfd_id,
        branch: "",
        rmList: []);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    investorList = data['list'];
    print("investorList ${investorList.length}");
    isFirst = false;
    return 0;
  }

  Future checkPanKycStatus(String pan) async {
    EasyLoading.show();
    iconStatus = true;
    Map data = await CommonOnBoardApi.checkPanKycStatus(
        user_id: mfd_id, client_name: clientName, pan: pan);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    kycMsg = data['msg'];

    EasyLoading.dismiss();
    setState(() {});
    return 0;
  }

  num selected_id = 0;
  UserDataPojo userDataPojo = UserDataPojo();
  Future getUser(int investor_id) async {
    if (userDataPojo.id != null) return 0;
    EasyLoading.show();
    Map data = await InvestorApi.getUser(
        user_id: investor_id, client_name: clientName);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    Map<String, dynamic> user = data['user'];

    userDataPojo = UserDataPojo.fromJson(user);
    selected_id = userDataPojo.id ?? 0;

    name = userDataPojo.name!;
    nameController.text = name;

    pan = userDataPojo.pan!;
    panController.text = pan;

    /*investor_id = userDataPojo.id!.toInt();
    print("investor id $investor_id");*/

    mobile = userDataPojo.mobile ?? "";
    mobileController.text = mobile;

    email = userDataPojo.email ?? "";
    emailController.text = email;

    guardianNameController.text = userDataPojo.pan!;

    selectedDob = convertStrToDt(userDataPojo.dateOfBirth ?? " ");

    address1 = userDataPojo.street1!;
    address1Controller.text = address1;
    address2 = userDataPojo.street2!;
    address2Controller.text = address2;
    address3 = userDataPojo.street3!;
    address3Controller.text = address3;
    cityController.text = userDataPojo.city!;
    pincode = userDataPojo.pincode!;
    pincodeController.text = pincode;
    stateController.text = userDataPojo.state!;
    selectedRmName = userDataPojo.rmName!;
    selectedSubBroker = userDataPojo.subbrokerName!;
    loginStatus = userDataPojo.loginStatus == true ? "Enable" : "Disable";
    clientStatus = userDataPojo.active == 1 ? "Active" : "Inactive";
    customerType = userDataPojo.passport!;
    String guardName = userDataPojo.guardName ?? "";
    String guardPan = userDataPojo.guardPan ?? "";
    statusType = guardPan.isEmpty ? "Major" : "Minor";
    guardNameController.text = guardName;
    guardPanController.text = guardPan;


    if (userDataPojo.anniversaryDate!.isNotEmpty) {
      selectedAnniversary =
          convertStrToDt(userDataPojo.anniversaryDate ?? " ");
      isAnniversary = true;
    }

    EasyLoading.dismiss();
    return 0;
  }

  searchHandler() {
    const duration = Duration(milliseconds: 1000);
    if (searchOnStop != null) {
      setState(() {
        searchOnStop!.cancel();
      });
    }
    setState(() {
      searchOnStop = Timer(duration, () async {
        await searchInvestor();
      });
    });
  }

  Future getDatas() async {
    if (!isFirst) return 0;
    EasyLoading.show();
    await getInitialInvestor();
    await authorizeUser();
    await getAllRM();
    await getAllSubBroker();
    EasyLoading.dismiss();
    isFirst = false;
    return 0;
  }

  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  Future getCityStateByPincode() async {
    Map data = await CommonOnBoardApi.getCityStateByPincode(
      user_id: mfd_id,
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
  void initState() {
    //  implement initState
    super.initState();
    type_id = GetStorage().read("type_id") ?? 0;
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
                title: "Create/Edit Client",
                bgColor: Config.appTheme.themeColor,
                foregroundColor: Colors.white),
            body: (!snapshot.hasData)
                ? Utils.shimmerWidget(devHeight,
                    margin: EdgeInsets.fromLTRB(16, 16, 16, 16))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showClientDetailsBottomSheet();
                                    },
                                    child: appBarNewColumn(
                                        "Select Client Details",
                                        getFirst13(selectedOptionType),
                                        Icon(Icons.keyboard_arrow_down,
                                            color: Config.appTheme.themeColor)),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                              SizedBox(height: 16),
                              if (selectedOptionType == "Edit Client") ...[
                                investorSearchCard(),
                                SizedBox(height: 16),
                              ],
                              if (selectedOptionType == "Create Client" ||
                                  investorName != "Select Investor") ...[
                                //statusCard(context),
                                AmountInputCard(
                                  title: statusType == "Major"
                                      ? "Name *"
                                      : "Minor Name",
                                  controller: nameController,
                                  suffixText: "",
                                  hasSuffix: false,
                                  readOnly: false,
                                  keyboardType: TextInputType.name,
                                  borderRadius: BorderRadius.circular(20),
                                  onChange: (val) => name = val,
                                ),
                                //nameCard(),
                               /* if (statusType == "Minor") ...[
                                  SizedBox(height: 16),
                                  AmountInputCard(
                                    title: "Guardian Name as on PAN",
                                    controller: guardNameController,
                                    suffixText: "",
                                    hasSuffix: false,
                                    readOnly: false,
                                    keyboardType: TextInputType.name,
                                    borderRadius: BorderRadius.circular(20),
                                    onChange: (val) {},
                                  ),
                                  SizedBox(height: 16),
                                  AmountInputCard(
                                    title: "Guardian PAN",
                                    readOnly: false,
                                    suffixText: "",
                                    hasSuffix: false,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    maxLength: 10,
                                    keyboardType: TextInputType.name,
                                    borderRadius: BorderRadius.circular(20),
                                    subTitle: Text(
                                      kycMsg,
                                      style: (kycMsg == successMsg)
                                          ? successStyle
                                          : errorStyle,
                                    ),
                                    controller: guardPanController,
                                    onChange: (val) async {
                                      if (val.length == 10) {
                                        await checkPanKycStatus(val);
                                      }
                                    },
                                  ),
                                ],*/
                                if (statusType == "Major") ...[
                                  SizedBox(height: 16),
                                  AmountInputCard(
                                    title: "PAN Number",
                                    controller: panController,
                                    readOnly: false,
                                    suffixText: "",
                                    hasSuffix: false,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    maxLength: 10,
                                    keyboardType: TextInputType.name,
                                    borderRadius: BorderRadius.circular(20),
                                    /*subTitle: Text(
                                      kycMsg,
                                      style: (kycMsg == successMsg)
                                          ? successStyle
                                          : errorStyle,
                                    ),*/
                                    onChange: (val) async {
                                      pan = val;
                                      /*if (val.length == 10) {
                                        await checkPanKycStatus(val);
                                      }*/
                                    },
                                  ),
                                ],
                                DottedLine(verticalPadding: 8),
                                AmountInputCard(
                                  title: "Mobile Number *",
                                  controller: mobileController,
                                  suffixText: "",
                                  maxLength: 10,
                                  hasSuffix: false,
                                  keyboardType: TextInputType.phone,
                                  borderRadius: BorderRadius.circular(20),
                                  onChange: (val) => mobile = val,
                                ),
                                SizedBox(height: 16),
                                AmountInputCard(
                                  title: "Email ID *",
                                  controller: emailController,
                                  suffixText: "",
                                  hasSuffix: false,
                                  keyboardType: TextInputType.emailAddress,
                                  borderRadius: BorderRadius.circular(20),
                                  onChange: (val) => email = val,
                                ),
                                DottedLine(verticalPadding: 8),
                                dobExpansionTile(context),
                               /* if (!isAnniversary)
                                  GestureDetector(
                                    onTap: () {
                                      isAnniversary = true;
                                      setState(() {});
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Add Anniversary Date",
                                        style: underlineText,
                                      ),
                                    ),
                                  ),
                                if (isAnniversary) ...[
                                  SizedBox(height: 16),
                                  anniversaryExpansionTile(context),
                                ],*/
                                SizedBox(height: 16),
                                anniversaryExpansionTile(context),
                                DottedLine(verticalPadding: 8),
                                AmountInputCard(
                                  title: 'Pin Code *',
                                  suffixText: '',
                                  controller: pincodeController,
                                  hasSuffix: false,
                                  maxLength: 6,
                                  keyboardType: TextInputType.number,
                                  borderRadius: BorderRadius.circular(20),
                                  onChange: (val) async {
                                    pincode = val;
                                    if (pincode.length != 6) return;
                                    await getCityStateByPincode();
                                    setState(() {
                                      pincode = val;
                                    });
                                    pincodeController.text = val;
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
                                  controller: address1Controller,
                                  hasSuffix: false,
                                  keyboardType: TextInputType.name,
                                  borderRadius: BorderRadius.circular(20),
                                  onChange: (val) => address1 = val,
                                ),
                                SizedBox(height: 16),
                                AmountInputCard(
                                  title: 'Address Line 2 [Optional]',
                                  suffixText: '',
                                  controller: address2Controller,
                                  hasSuffix: false,
                                  keyboardType: TextInputType.name,
                                  borderRadius: BorderRadius.circular(20),
                                  onChange: (val) => address2 = val,
                                ),
                                SizedBox(height: 16),
                                AmountInputCard(
                                  title: 'Address Line 3 [Optional]',
                                  suffixText: '',
                                  controller: address3Controller,
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
                            ],
                          ),
                        ),
                        createBtn(),
                      ],
                    ),
                  ),
          );
        });
  }

  Widget createBtn() {
    return Container(
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
            print("arn = ${Config.appArn}");
            if (name.isEmpty) {
              Utils.showError(context, "Please Enter Name");
              return;
            }
         /*   if (statusType == "Major") {
              if (pan.length != 10) {
                Utils.showError(context, "Invalid PAN");
                return;
              }
            } else {
              if (guardPanController.text.length != 10) {
                Utils.showError(context, "Invalid Guardian PAN");
                return;
              }
            }*/
            if (mobile.isEmpty ) {
              Utils.showError(context, "Please Enter Mobile Number");
              return;
            }
            if (mobile.length != 10 ) {
              Utils.showError(context, "Invalid Mobile Number");
              return;
            }
            if (!email.isEmail) {
              Utils.showError(context, "Please Enter valid Email ID");
              return;
            }
            if (email.isEmpty) {
              Utils.showError(context, "Please Enter Email ID");
              return;
            }

            if (pincodeController.text.isEmpty) {
              Utils.showError(context, "Please Enter Pincode");
              return;
            }

            if (pincodeController.text.length != 6 ) {
              Utils.showError(context, "Please Enter valid Pincode");
              return;
            }
            if (cityController.text.isEmpty) {
              Utils.showError(context, "Please Enter City");
              return;
            }
            if (stateController.text.isEmpty) {
              Utils.showError(context, "Please Enter State");
              return;
            }
            /*  if (address1.isEmpty) {
              Utils.showError(context, "Please Enter Address Line 1");
              return;
            }
           if (containsSpecialCharacter(name)) {
              Utils.showError(context, "Invalid Name");
              return;
            }*/

            if (rmList.isNotEmpty && selectedRmName.isEmpty) {
              Utils.showError(context, "Please Select RM");
              return;
            }
            /*if (selectedSubBroker.isEmpty) {
              Utils.showError(context, "Please select Sub Broker");
              return;
            }*/

            int res = await createClient();
            if (res.isNegative) return;
            bool hasKyc = (res == 1);

            successAlert(context, hasKyc: hasKyc);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Config.appTheme.themeColor,
            foregroundColor: Colors.white,
          ),
          child: Text(
            selectedOptionType == "Create Client"
                ? "CREATE CLIENT"
                : "EDIT CLIENT",
          ),
        ),
      ),
    );
  }

  containsSpecialCharacter(String s) {
    RegExp regExp = RegExp(r'[^a-zA-Z0-9\s.]');
    return regExp.hasMatch(s);
  }

  void successAlert(BuildContext context, {required bool hasKyc}) {
    String createUpdate =
        (selectedOptionType == "Create Client") ? "Created" : "Updated";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Client  $createUpdate Successfully",
              style: AppFonts.f50014Black.copyWith(fontSize: 16),
            ),
            content: Text(
              "$name has been $createUpdate.",
              style: AppFonts.f50012Grey.copyWith(fontSize: 14),
            ),
            /*Register online to start investing in mutual funds.*/
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  child: Text("OK")),
              /*if (!hasKyc)
                TextButton(
                    onPressed: () async {
                      Get.back();
                      await GetStorage().write("user_id", userDataPojo.id);
                      Get.off(Ekyc());
                    },
                    child: Text("Complete eKYC")),*/
            ],
          );
        });
  }

  showClientDetailsBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (_, bottomState) {
            return SizedBox(
              height: devHeight * 0.30,
              child: Column(
                children: [
                  BottomSheetTitle(title: "Select Client Type"),
                  Divider(color: Config.appTheme.lineColor, height: 0),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.all(16),
                        child: ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            itemCount: optionType.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  selectedOptionType = optionType[index];
                                  if (selectedOptionType == "Create Client"){
                                    clearFormValues();
                                  }
                                  setState(() {});
                                  Get.back();
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: selectedOptionType,
                                      value: optionType[index],
                                      onChanged: (val) async {
                                        selectedOptionType = optionType[index];
                                        if (selectedOptionType == "Create Client"){
                                          clearFormValues();
                                        }
                                        setState(() {});
                                        Get.back();
                                      },
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          optionType[index],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })),
                  ),
                ],
              ),
            );
          });
        });
  }

  Widget appBarNewColumn(String title, String value, Widget suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: AppFonts.f50014Black),
        Container(
          width: devWidth * 0.91,
          padding: EdgeInsets.fromLTRB(7, 8, 7, 8),
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: Config.appTheme.overlay85,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Row(
              children: [
                Text(value,
                    style: TextStyle(
                        color: Config.appTheme.themeColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Spacer(),
                suffix
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget investorSearchCard() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: investorController,
          title: Text("Client Name", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(investorName, style: AppFonts.f50012),
              // DottedLine(),
            ],
          ),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 12, 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Config.appTheme.lineColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: RpSmallTf(
                  onChange: (val) {
                    searchKey = val;
                    searchHandler();
                  },
                ),
              ),
            ),
            SizedBox(
              height: 350,
              child: ListView.builder(
                itemCount: investorList.length,
                itemBuilder: (context, index) {
                  String name = investorList[index]['name'];
                  int id = investorList[index]['id'];
                  return InkWell(
                    onTap: () async {
                      investorName = name;
                      investorController.collapse();
                      userDataPojo.id = null;
                      await getUser(id);
                      setState(() {});
                    },
                    child: ListTile(
                      leading: InitialCard(title: (name == "") ? "." : name),
                      title: Text(name),
                    ),
                  );
                },
              ),
            ),
            InkWell(
              onTap: () async {
                // if (searchKey.isNotEmpty) return;

                EasyLoading.show();
                await fetchMoreInvestor();
                EasyLoading.dismiss();
              },
              child: Text(
                "Load More Results",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Config.appTheme.themeColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
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
            statusType == "Major" ? "Name as on PAN" : "Minor Name",
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

  Widget guardianNameCard() {
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
            "Guardian Name as on PAN",
            style: AppFonts.f50014Black,
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: TextField(
              keyboardType: TextInputType.name,
              controller: guardianNameController,
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
              padding: EdgeInsets.only(left: 8.0),
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
                  onChanged: majorMinorToggle,
                ),
                GestureDetector(
                  onTap: () {
                    majorMinorToggle('Major');
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
                  onChanged: majorMinorToggle,
                ),
                GestureDetector(
                  onTap: () {
                    majorMinorToggle('Minor');
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

  majorMinorToggle(String? val) {
    print("toggle called");
    nameController.clear();
    panController.clear();
    guardNameController.clear();
    guardPanController.clear();
    kycMsg = "";
    statusType = val;
    setState(() {});
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
                Text(
                  selectedDob == null
                      ? "Select DOB"
                      : Utils.getFormattedDate(date: selectedDob),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Config.appTheme.themeColor),
                ),
              ],
            ),
            children: [
              SizedBox(
                height: 200,
                child: ScrollDatePicker(
                  selectedDate: selectedDob ?? DateTime.now(), // Default to current date if null
                  onDateTimeChanged: (value) {
                    setState(() {
                      selectedDob = value;
                    });
                  },
                ),
              ),
            ],
          )),
    );
  }


  Widget anniversaryExpansionTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: anniversaryController,
            title: Text("Anniversary", style: AppFonts.f50014Black),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(selectedAnniversary == null
                      ? "Select Anniversary Date"
                : Utils.getFormattedDate(date: selectedAnniversary),
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
                  selectedDate: selectedAnniversary ?? DateTime.now(),
                  onDateTimeChanged: (value) {
                    selectedAnniversary = value;
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
    "1 Star",
    "2 Star",
    "3 Star",
    "4 Star",
    "5 Star",
    "Not Applicable"
  ];
  String customerType = "Not Applicable";

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
              height: 300,
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
                            subBrokerController.collapse();
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
                                  subBrokerController.collapse();
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

  Future authorizeUser() async {
    String name = GetStorage().read("mfd_name");
    if (type_id == 2) {
      selectedRmName = name;
      rmList = [name];
    }
    if (type_id == 4) {
      selectedSubBroker = name;
      subBrokerList = [name];
     //await getUser(mfd_id);
      setState(() {});
      rmList = [selectedRmName];
    }
  }

  ExpansionTileController rmController = ExpansionTileController();
  Widget rmExpansionTile(BuildContext context) {
    if(type_id == 4){
      selectedRmName = userDataPojo.rmName ?? '';
      rmList = [];
      print("selectedRmName $selectedRmName");
    }
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
              height: 300,
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
                          onTap: () async {
                            selectedRmName = title;
                            subBrokerList = [];
                            EasyLoading.show();
                            await getAllSubBroker();
                            EasyLoading.dismiss();
                            rmController.collapse();
                            selectedSubBroker = '';
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: title,
                                groupValue: selectedRmName,
                                onChanged: (temp) async {
                                  selectedRmName = title;
                                  subBrokerList = [];
                                  EasyLoading.show();
                                  await getAllSubBroker();
                                  EasyLoading.dismiss();
                                  rmController.collapse();
                                  selectedSubBroker = '';
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
  void clearFormValues() {
    // Reset variables
    name = '';
    investorName = 'Select Investor';
    pan = '';
    email = '';
    mobile = '';
    selectedDob = null;
    selectedAnniversary = null;
    address1 = '';
    address2 = '';
    address3 = '';
    city = '';
    state = '';
    pincode = '';
    selectedRmName = '';
    selectedSubBroker = '';
    loginStatus = 'Enable';
    selected_id = 0;
    clientStatus = 'Active';
    customerType = 'Not Applicable';


    // Clear the TextEditingControllers
    nameController.text = '';
    panController.text = '';
    emailController.text = '';
    mobileController.text = '';
    guardianNameController.text = '';
    cityController.text = '';
    stateController.text = '';
    pincodeController.text = '';
    address1Controller.text = '';
    address2Controller.text = '';
    address3Controller.text = '';

    selectedDob = null;
  }

}
