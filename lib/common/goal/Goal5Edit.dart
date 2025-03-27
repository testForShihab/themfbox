import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../utils/AppThemes.dart';
import 'GoalSuggestedSchemesResponce.dart';

class Goal5Edit extends StatefulWidget {
  final GoalSchemeList goalSchemeList;
  final int intIndex;

  Goal5Edit({required Key key, required this.goalSchemeList, required this.intIndex}) : super(key: key);

  _Goal5EditState createState() => _Goal5EditState();
}

class _Goal5EditState extends State<Goal5Edit> {
  String user_id = GetStorage().read("user_id");
  String user_name = GetStorage().read("user_name");
  String user_pan = GetStorage().read("user_pan");
  String user_mobile = GetStorage().read("user_mobile");
  String client_name = GetStorage().read("client_name");
  String admin_id = GetStorage().read("admin_id");
  String admin_type_id = GetStorage().read("admin_type_id");
  String user_bse_or_nse = GetStorage().read("user_bse_or_nse");
  int user_nse_active = GetStorage().read("user_nse_active");

  NumberFormat numberFormat = NumberFormat.currency(locale: "HI", symbol: "", decimalDigits: 0);
  late GoalSchemeList goalSchemeList;
  String from_scheme_name = "";
  int sipamount = 0;

  List<String> toSchemeOptionList = [];
  String to_scheme_option_str = "Growth";
  TextEditingController amountController = new TextEditingController();
  TextEditingController dateController = TextEditingController();
  final dateFormat = new DateFormat('dd-MM-yyyy');

  String chosenDate = "01";
  String originalDate = "01";
  List<String> datesList = [];
  late DateTime dateTime;

  @override
  void initState() {
    super.initState();

    goalSchemeList = widget.goalSchemeList;
    from_scheme_name = goalSchemeList.schemeName!;
    sipamount = goalSchemeList.allocationAmount!;
    dateController.text=goalSchemeList.sipDate!;
     dateTime = dateFormat.parse(goalSchemeList.sipDate!);


    // tempDate = new DateFormat("dd-MM-yyyy").parse(goalSchemeList.sipDate);


    new Future.delayed(Duration.zero, () {
      init(context);
    });
  }

  init(BuildContext context) async {

    setState(() {
      var oldDatesList = goalSchemeList.sipDates?.split(",");
      for (String date in oldDatesList!) {
        if (date.length == 1) {
          date = "0" + date;
        }
        datesList.add(date);
      }
    });

    amountController.text = goalSchemeList.allocationAmount.toString();
    amountController.selection =
        TextSelection.fromPosition(TextPosition(offset: amountController.text.length));

    chosenDate = goalSchemeList.sipDate!.split("-").first;
    originalDate = goalSchemeList.sipDate!.split("-").first;
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Config.appTheme.mainBgColor,
        appBar: (user_id != 0)
            ? adminAppBar(title: "Recommended Funds" ,hasAction: false)
            : rpAppBar(title: "Recommended Funds"),
        body: Container(
          child: Column(
            children: [

              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 16,bottom: 0),
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[

                          Container(
                            margin: EdgeInsets.all(0),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Color(0XFFFFFFFF),
                                border: Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.all(Radius.circular(8))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  color: Colors.white,
                                  child: Text(goalSchemeList.schemeName!,
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      softWrap: true,
                                      style: AppFonts.f50014Black),
                                ),

                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                  child: Text(
                                    "Monthly Investment Amount(SIP)",
                                   // style: Utils.TextFieldLabelStyle,
                                  ),
                                ),

                                Container(
                                  height: 60,
                                  child: TextField(
                                    textAlign: TextAlign.start,
                                    controller: amountController,
                                    obscureText: false,
                                    keyboardType: TextInputType.numberWithOptions(
                                        signed: true, decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    enabled: true,
                                    style: AppFonts.f50014Theme,
                                    cursorColor: Config.appTheme.themeColor,
                                    decoration: InputDecoration(
                                      labelText: '',
                                      labelStyle: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF666666),
                                      ),
                                      helperText: '',
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFCDD3ED),
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Color(0xFFCDD3ED)),
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text(
                                    "Investment Date",
                                   // style: Utils.TextFieldLabelStyle,
                                  ),
                                ),
                                Container(
                                  height: 60,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: TextField(
                                    readOnly: true,
                                    controller: dateController,
                                    obscureText: false,
                                    //style: Config.appTheme.themeColor,
                                    onTap: () async {
                                      var date = await showDatePicker(
                                        context: context,
                                        initialDate:dateTime,
                                        firstDate: new DateTime.now(),
                                        lastDate: new DateTime.now().add(new Duration(days: 30)),
                                        fieldHintText: goalSchemeList.sipDate,
                                      );

                                      dateController.text = dateFormat.format(date!);
                                    },
                                    cursorColor: Config.appTheme.themeColor,
                                    decoration: InputDecoration(
                                      labelText: "",
                                     // labelStyle: Utils.TextFieldLabelStyle,
                                      alignLabelWithHint: true,
                                      helperText: '',
                                      //focusedBorder: Utils.UnderlineFocusedBorder,
                                      //enabledBorder: Utils.UnderlineEnabledBorder,
                                    ),
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.only(top: 16, bottom: 16),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                          child: Material(
                                            child: ElevatedButton(
                                              child: Text(
                                                "Cancel",
                                               // style: AppTheme.textStylePrimaryFont15w400Roboto,
                                              ),
                                             // style: Utils.ElevatedButtonStylePlain,
                                              onPressed: () {
                                                Get.back();
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                          child: Material(
                                            child: ElevatedButton(
                                              child: Text(
                                                "Apply",
                                               // style: Utils.ElevatedButtonTextStyleWhite,
                                              ),
                                            //  style: Utils.ElevatedButtonStyleBlue,
                                              onPressed: () {

                                                String amount = amountController.text;
                                                String Strdate = dateController.text;
                                                int int_amount = int.parse('$amount');
                                                goalSchemeList.allocationAmount = int_amount;
                                                goalSchemeList.sipDate = Strdate;
                                                Get.back(result: goalSchemeList);

                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                       /*   Container(
                            margin: EdgeInsets.fromLTRB(0, 32, 0, 16),
                            padding: EdgeInsets.fromLTRB(0, 24, 0, 24),
                            decoration: BoxDecoration(
                                color: Color(0XFFFFFFFF),
                                border: Border.all(color: AppTheme.grey, width: 1),
                                borderRadius: BorderRadius.all(Radius.circular(6))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: TextField(
                                    controller: amountController,
                                    obscureText: false,
                                    keyboardType: TextInputType.number,
                                    enabled: true,
                                    style: Apptheme.textStylePrimaryFont15,
                                    cursorColor: Apptheme.primaryColor,
                                    decoration: InputDecoration(
                                      labelText: 'Monthly Investment Amount(SIP)',
                                      labelStyle: Utils.TextFieldLabelStyle,
                                      helperText: '',
                                      focusedBorder: Utils.UnderlineFocusedBorder,
                                      enabledBorder: Utils.UnderlineEnabledBorder,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),

                                Container(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: TextField(
                                    readOnly: true,
                                    controller: dateController,
                                    obscureText: false,
                                    style: Apptheme.textStylePrimaryFont15,
                                    onTap: () async {
                                      var date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: new DateTime.now(),
                                        lastDate: new DateTime.now().add(new Duration(days: 30)),
                                        fieldHintText: goalSchemeList.sipDate,
                                      );

                                      dateController.text = dateFormat.format(date);
                                    },
                                    cursorColor: Apptheme.primaryColor,
                                    decoration: InputDecoration(
                                      labelText: "Investment Date",
                                      labelStyle: Utils.TextFieldLabelStyle,
                                      alignLabelWithHint: true,
                                      helperText: '',
                                      focusedBorder: Utils.UnderlineFocusedBorder,
                                      enabledBorder: Utils.UnderlineEnabledBorder,
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 6,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 0, bottom: 24),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    margin: EdgeInsets.fromLTRB(0, 16, 8, 0),
                                    child: ElevatedButton(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(fontSize: 15, color: Apptheme.primaryColor),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          side: BorderSide(width: 1, color: Apptheme.primaryColor),
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(3)),
                                          ),
                                          padding: EdgeInsets.fromLTRB(
                                              0, 16, 0, 16) //content padding inside button
                                      ),
                                      onPressed: () {
                                        Get.to(Portfolio());
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    margin: EdgeInsets.fromLTRB(8, 16, 0, 0),
                                    child: ElevatedButton(
                                      child: Text(
                                        "Apply",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0XFFFFFFFF),
                                            fontFamily: 'Mulish',
                                            fontWeight: FontWeight.w500),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          primary: Apptheme.primaryColor,
                                          side: BorderSide(width: 1, color: Apptheme.primaryColor),
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(3)),
                                          ),
                                          padding: EdgeInsets.fromLTRB(
                                              0, 16, 0, 16) //content padding inside button
                                      ),
                                      onPressed: () {
                                        String amount = amountController.text;
                                        String Strdate = dateController.text;
                                        int int_amount = int.parse('$amount');
                                        goalSchemeList.allocationAmount = int_amount;
                                        goalSchemeList.sipDate = Strdate;
                                        Get.back(result: goalSchemeList);

                                        // goalSchemeMainList
                                        //     .singleWhere(((i) => i.schemeName == goalSchemeList.schemeName))
                                        //     .allocationAmount = int.parse(amountController.text);
                                        //
                                        // goalSchemeMainList
                                        //     .singleWhere(((i) => i.schemeName == goalSchemeList.schemeName))
                                        //     .sipDate = goalSchemeList.sipDate.replaceFirst(originalDate, chosenDate);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),*/
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
