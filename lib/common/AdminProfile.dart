import 'package:flutter/material.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({Key? key}) : super(key: key);

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  bool investorcredential = false;
  TextEditingController? namecontroller = TextEditingController();
  TextEditingController? phonecontroller = TextEditingController();
  TextEditingController? emailcontroller = TextEditingController();
  TextEditingController? address1controller = TextEditingController();
  TextEditingController? address2controller = TextEditingController();
  TextEditingController? sendernamecontroller = TextEditingController();
  TextEditingController? senderemailcontroller = TextEditingController();

  List fundlist = [
    "Regular Growth Plan",
    "Regular Growth & Dividend Plan",
    "Regular Plan & Direct Plan"
  ];
  String? selectedfundlist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Profile",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  AmountInputCard(
                    title: "Company Name",
                    suffixText: "",
                    hintTitle: "Name",
                    hasSuffix: false,
                    controller: namecontroller,
                    keyboardType: TextInputType.name,
                    borderRadius: BorderRadius.circular(20),
                    onChange: (val) {},
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Company Phone",
                    suffixText: "",
                    maxLength: 10,
                    hasSuffix: false,
                    hintTitle: "Enter Company Phone Number",
                    controller: phonecontroller,
                    keyboardType: TextInputType.phone,
                    borderRadius: BorderRadius.circular(20),
                    onChange: (val) {},
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Company Email ",
                    suffixText: "",
                    hintTitle: "Email",
                    hasSuffix: false,
                    // controller: emailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    borderRadius: BorderRadius.circular(20),
                    onChange: (val) {},
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Company Address 1",
                    suffixText: "",
                    hintTitle: "Enter Address Line 1",
                    hasSuffix: false,
                    controller: address1controller,
                    keyboardType: TextInputType.streetAddress,
                    borderRadius: BorderRadius.circular(20),
                    onChange: (val) {},
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Company Address 2",
                    suffixText: "",
                    hintTitle: "Enter Address Line 2",
                    hasSuffix: false,
                    controller: address2controller,
                    keyboardType: TextInputType.streetAddress,
                    borderRadius: BorderRadius.circular(20),
                    onChange: (val) {},
                  ),
                  SizedBox(height: 16),
                  DottedLine(),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Mail Sender Name",
                    suffixText: "",
                    hintTitle: 'Name',
                    controller: sendernamecontroller,
                    hasSuffix: false,
                    keyboardType: TextInputType.name,
                    borderRadius: BorderRadius.circular(20),
                    onChange: (val) {},
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Mail Sender Email",
                    suffixText: "",
                    hintTitle: 'Email',
                    controller: senderemailcontroller,
                    hasSuffix: false,
                    keyboardType: TextInputType.emailAddress,
                    borderRadius: BorderRadius.circular(20),
                    onChange: (val) {},
                  ),
                  SizedBox(height: 16),
                  ExpansionTile(
                    collapsedBackgroundColor: Colors.white,
                    collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.white,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Fund Type", style: AppFonts.f50014Black),
                        Text("Select Fund Type",
                            style: AppFonts.f50012
                                .copyWith(color: Config.appTheme.themeColor)),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, top: 5, right: 16, bottom: 5),
                        child: DottedLine(),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: fundlist.length,
                        itemBuilder: (context, index) {
                          String selectedOption = fundlist[index];
                          return Row(
                            children: [
                              Radio(
                                  activeColor: Config.appTheme.themeColor,
                                  value: selectedOption,
                                  groupValue: selectedfundlist,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedfundlist = value as String?;
                                    });
                                  }),
                              Text(selectedOption)
                            ],
                          );
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                          activeColor: Config.appTheme.themeColor,
                          value: investorcredential,
                          onChanged: (val) {
                            setState(() {
                              investorcredential = val!;
                            });
                          }),
                      SizedBox(width: 10),
                      Text("Investor Credentials",
                          style: AppFonts.f50012.copyWith(color: Colors.black))
                    ],
                  ),
                  Text("hfgdghdvbh"),
                  Text("hfgdghdvbh"),
                  SizedBox(height: 40),
                ],
              ),
            )
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        height: 80,
        padding: EdgeInsets.all(16),
        child: RpFilledButton(
          text: 'Update Details',
        ),
      ),
    );
  }
}
