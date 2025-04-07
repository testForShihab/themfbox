import 'package:flutter/material.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  late double devHeight, devWidth;

  ExpansionTileController mobileRelationController = ExpansionTileController();
  ExpansionTileController emailRelationController = ExpansionTileController();
  ExpansionTileController occupationController = ExpansionTileController();

  List mobileRelationList = [
    "Self",
  ];
  List emailRelationList = [
    "Self",
  ];

  List occupationList = [
    "Student",
  ];

  String mobileRelation = "Self";
  String emailRelation = "Self";
  String occupation = "Self";

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: invAppBar(
        // toolbarHeight: 200,
        title: "Update Profile",
        // bottomSpace: topFilterArea(),
      ),
      /*rpAppBar(
          title: "Update Profile",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),*/
      body: SideBar( 
        child: Container(
          color: Config.appTheme.mainBgColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                topCard(),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        AmountInputCard(
                          title: "Mobile Number",
                          initialValue: "",
                          suffixText: "",
                          hasSuffix: false,
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          borderRadius: BorderRadius.circular(20),
                          onChange: (val) {},
                        ),
                        SizedBox(height: 16),
                        mobileRelationTile(),
                        SizedBox(height: 16),
                        AmountInputCard(
                          title: "Email Id",
                          initialValue: "",
                          suffixText: "",
                          hasSuffix: false,
                          keyboardType: TextInputType.emailAddress,
                          borderRadius: BorderRadius.circular(20),
                          onChange: (val) {},
                        ),
                        SizedBox(height: 16),
                        emailRelationTile(),
                        SizedBox(height: 16),
                        occupationTile(),
                        SizedBox(height: 16),
                        addressCard(),
                        SizedBox(height: 16),
                        nomineeCard(),
                        SizedBox(height: 16),
                      ]),
                ),
                Container(
                  width: devWidth,
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: SizedBox(
                    width: devWidth * 0.76,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Config.appTheme.themeColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        textStyle: AppFonts.f50014Black.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {},
                      child: Text("UPDATE PROFILE"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container topCard() {
    return Container(
      color: Config.appTheme.themeColor,
      child: Container(
        width: devWidth,
        margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
        decoration: BoxDecoration(
            color: Color(0xFFDEE6E6), borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ColumnText(title: "Name", value: "Mohan G"),
              SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: ColumnText(title: "PAN", value: "ABCDE1234J"),
                  ),
                  Expanded(
                    child: ColumnText(
                      title: "DOB",
                      value: "29 Aug 1987",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ColumnText(title: "Client Code", value: "994084"),
                  ),
                  Expanded(
                    child: ColumnText(
                      title: "Holding Nature",
                      value: "Single",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container addressCard() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Address", style: AppFonts.f50014Black ,),
              Text(
                "Edit",
                style: AppFonts.f40013.copyWith(
                    color: Config.appTheme.themeColor,
                    decoration: TextDecoration.underline),
              ),
            ],
          ),
          DottedLine(
            verticalPadding: 4,
          ),
          Text("14, New Street, Palakari, Trichy, Tamil Nadu- 620008, India",
              style: AppFonts.f50014Black.copyWith(fontSize: 13))
        ],
      ),
    );
  }

  Container nomineeCard() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Nominee Details", style: AppFonts.f50014Black),
              Text(
                "Edit",
                style: AppFonts.f40013.copyWith(
                    color: Config.appTheme.themeColor,
                    decoration: TextDecoration.underline),
              ),
            ],
          ),
          DottedLine(
            verticalPadding: 4,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1,
                  color: AppColors.lineColor,
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("assets/48.png", height: 30),
                SizedBox(width: 10),
                ColumnText(
                  title: "Rohit Tanwar",
                  value: "Son",
                  titleStyle: AppFonts.f50012.copyWith(color: Colors.black),
                  valueStyle: AppFonts.f50012
                      .copyWith(color: Config.appTheme.themeColor),
                ),
                Spacer(),
                Text(
                  "100%",
                  style: AppFonts.f40013.copyWith(color: Colors.black),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget mobileRelationTile() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: mobileRelationController,
          title: Text("Mobile Relation", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mobileRelation, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: mobileRelationList.length,
              itemBuilder: (context, index) {
                String temp = mobileRelationList[index];
                return InkWell(
                  onTap: () {
                    mobileRelation = temp;
                    mobileRelationController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: mobileRelation,
                        onChanged: (value) {
                          mobileRelation = temp;
                          mobileRelationController.collapse();
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

  Widget emailRelationTile() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: emailRelationController,
          title: Text("Email Relation", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(emailRelation, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: emailRelationList.length,
              itemBuilder: (context, index) {
                String temp = emailRelationList[index];
                return InkWell(
                  onTap: () {
                    emailRelation = temp;
                    emailRelationController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: emailRelation,
                        onChanged: (value) {
                          emailRelation = temp;
                          emailRelationController.collapse();
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

  Widget occupationTile() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: occupationController,
          title: Text("Occupation", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(occupation, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: occupationList.length,
              itemBuilder: (context, index) {
                String temp = occupationList[index];
                return InkWell(
                  onTap: () {
                    occupation = temp;
                    occupationController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: occupation,
                        onChanged: (value) {
                          occupation = temp;
                          occupationController.collapse();
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
}
