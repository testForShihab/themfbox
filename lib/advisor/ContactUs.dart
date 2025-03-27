import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/Utils.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  late double devHeight, devWidth;

  int mfd_id = getUserId();
  String client_name = GetStorage().read("client_name");
  List<dynamic> yearData = [];
  String mfd_name = GetStorage().read('mfd_name');

  @override
  void initState() {
    //  implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Contact Us",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: SideBar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              topCard(),
              SizedBox(height: 16),
              profileCard(
                  "Distributor Helpline:",
                  Icon(
                    Icons.call,
                    color: Config.appTheme.themeColor,
                    size: 20,
                  ),
                  "+91 80 41706980",
                  "mobile"),
              profileCard(
                  "Pradip: ",
                  Icon(
                    Icons.call,
                    color: Config.appTheme.themeColor,
                    size: 20,
                  ),
                  "+91 9900511400",
                  "mobile"),
              profileCard(
                  "Email: ",
                  Icon(
                    Icons.email,
                    color: Config.appTheme.themeColor,
                    size: 20,
                  ),
                  "connect@advisorkhoj.com",
                  "email"),
              profileCard(
                  "Service Queries: ",
                  Icon(
                    Icons.email,
                    color: Config.appTheme.themeColor,
                    size: 20,
                  ),
                  "service@advisorkhoj.com",
                  "email"),
              profileCard(
                  "Sales & APIs: ",
                  Icon(
                    Icons.email,
                    color: Config.appTheme.themeColor,
                    size: 20,
                  ),
                  "sales@advisorkhoj.com",
                  "email"),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileCard(String title, Widget icon, String details, String type) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          if (type == "mobile") {
            _launchPhoneDialer(details);
          } else {
            _launchEmailClient(context, details);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                icon,
                SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: AppFonts.f50014Black
                      .copyWith(color: Config.appTheme.themeColor),
                ),
              ],
            ),
            SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              // child: GestureDetector(
              //   onTap: () =>
              //       _launchEmailClient(context, "connect@advisorkhoj.com"),
              child: Text(
                details,
                style: AppFonts.f50014Grey.copyWith(
                    color: Config.appTheme.themeColor,
                    fontSize: (type == "email") ? 18 : 16),
              ),
              // ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topCard() {
    return Container(
      color: Config.appTheme.themeColor,
      child: Container(
        width: devWidth,
        margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Config.appTheme.themeColor25,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on,
                  color: Config.appTheme.themeColor,
                  size: 20,
                ),
                SizedBox(width: 2),
                Text(
                  "Address: ",
                  style: AppFonts.f70018Black,
                ),
              ],
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                "Gamechanger Business Services (I) Pvt. Ltd",
                style: AppFonts.f40016
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 20),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text("No. 27, Santosh Tower, 1st Floor,",
                  style: AppFonts.f50014Grey.copyWith(color: Colors.black)),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text("15th Cross Road, 100 Feet Ring Road,",
                  style: AppFonts.f50014Grey.copyWith(color: Colors.black)),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text("J.P. Nagar, 4th Phase,",
                  style: AppFonts.f50014Grey.copyWith(color: Colors.black)),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text("Bangalore, Karnataka.",
                  style: AppFonts.f50014Grey.copyWith(color: Colors.black)),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text("PIN - 560078",
                  style: AppFonts.f50014Grey.copyWith(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  Widget addressCard() {
    return SizedBox(
      width: devWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on,
                color: Config.appTheme.themeColor,
                size: 20,
              ),
              SizedBox(width: 2),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Address: ",
                        style:
                            AppFonts.f50014Grey.copyWith(color: Colors.black),
                      ),
                      TextSpan(
                        text: "Gamechanger Business Services (I) Pvt. Ltd",
                        style: AppFonts.f50014Grey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              "JK Towers, 719/A, 53-2, 3rd Floor,",
              style: AppFonts.f50014Grey,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              "46th Cross, 8th Block Jayanagar,",
              style: AppFonts.f50014Grey,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              "Bangalore, Karnataka (India). PIN - 560082",
              style: AppFonts.f50014Grey,
            ),
          ),
          SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.call,
                color: Config.appTheme.themeColor,
                size: 18,
              ),
              SizedBox(width: 4),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Distributor Helpline: ",
                        style:
                            AppFonts.f50014Grey.copyWith(color: Colors.black),
                      ),
                      TextSpan(
                        text: "+91 80 41706980",
                        style: AppFonts.f50014Grey.copyWith(
                          color: Config.appTheme.themeColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _launchPhoneDialer("+91 80 41706980"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.call,
                color: Config.appTheme.themeColor,
                size: 18,
              ),
              SizedBox(width: 4),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Pradip: ",
                        style:
                            AppFonts.f50014Grey.copyWith(color: Colors.black),
                      ),
                      TextSpan(
                        text: "+91 9900511400",
                        style: AppFonts.f50014Grey.copyWith(
                          color: Config.appTheme.themeColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _launchPhoneDialer("+91 9900511400"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.email,
                color: Config.appTheme.themeColor,
                size: 18,
              ),
              SizedBox(width: 4),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Email: ",
                        style:
                            AppFonts.f50014Grey.copyWith(color: Colors.black),
                      ),
                      TextSpan(
                        text: "connect@advisorkhoj.com",
                        style: AppFonts.f50014Grey.copyWith(
                          color: Config.appTheme.themeColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _launchEmailClient(
                              context, "connect@advisorkhoj.com"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.email,
                color: Config.appTheme.themeColor,
                size: 18,
              ),
              SizedBox(width: 4),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Service Queries: ",
                        style:
                            AppFonts.f50014Grey.copyWith(color: Colors.black),
                      ),
                      TextSpan(
                        text: "service@advisorkhoj.com",
                        style: AppFonts.f50014Grey.copyWith(
                          color: Config.appTheme.themeColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _launchEmailClient(
                              context, "service@advisorkhoj.com"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.email,
                color: Config.appTheme.themeColor,
                size: 18,
              ),
              SizedBox(width: 4),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Sales & APIs: ",
                        style:
                            AppFonts.f50014Grey.copyWith(color: Colors.black),
                      ),
                      TextSpan(
                        text: "sales@advisorkhoj.com",
                        style: AppFonts.f50014Grey.copyWith(
                          color: Config.appTheme.themeColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _launchEmailClient(
                              context, "sales@advisorkhoj.com"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _launchPhoneDialer(String phoneNumber) async {
    final Uri _phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(_phoneUri)) {
      await launchUrl(_phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  void _launchEmailClient(BuildContext context, String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: <String, String>{
        'subject': '',
        'body': '',
      },
    );

    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open email client.'),
        ),
      );
    }
  }

  void _showManualEmailDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Email Client Unavailable'),
        content: Text(
          'It seems you don\'t have an email client set up. You can manually send an email to $email.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
