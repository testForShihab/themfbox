import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:url_launcher/url_launcher.dart';

class InvestorContactUs extends StatefulWidget {
  const InvestorContactUs({super.key});

  @override
  State<InvestorContactUs> createState() => _InvestorContactUsState();
}

class _InvestorContactUsState extends State<InvestorContactUs> {
  @override
  late double devHeight, devWidth;
  int user_id = GetStorage().read('user_id') ?? 0;
  String client_name = GetStorage().read("client_name");

  Map<String, dynamic> resultFields = {};

  String companyName = "";
  String companyAddress1 = "";
  String companyAddress2 = "";
  String companyPhone = "";
  String companyEmail = "";
  String websiteUrl = "";
  String websiteName = "";
  String domainUrl = "";
  Future getContactDetailsByClientName() async {
    Map<String, dynamic> data = await InvestorApi.getContactDetailsByClientName(
      client_name: client_name,
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    companyName = data['result']['company_name'] ?? "";
    companyAddress1 = data['result']['company_address1'] ?? "";
    companyAddress2 = data['result']['company_address2'] ?? "";
    companyPhone = data['result']['company_phone'] ?? "";
    companyEmail = data['result']['company_email'] ?? "";
    websiteUrl = data['result']['website_url'] ?? "";
    websiteName = data['result']['website_name'] ?? "";
    domainUrl = data['result']['domain_url'] ?? "";

   /* if (!websiteName.startsWith('https://') && !websiteName.startsWith("http://")) {
      websiteName = 'https://$websiteName';
    }*/

    return 0;
  }

  void initState() {
    getContactDetailsByClientName();
    print("global init state called");
    super.initState();
  }

  Future getDatas() async {
    await getContactDetailsByClientName();
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    print("client_name $client_name");
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
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
                    Container(
                      color: Config.appTheme.themeColor,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Text(
                          textAlign: TextAlign.justify,
                          "You can get in touch with us through below platforms.Our Team will reach out to you as soon as it would be possible.",
                          style: AppFonts.f50014Black
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    topCard(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Customer Support",
                            style: AppFonts.f50014Grey.copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    profileCard(
                        "Helpline:",
                        Icon(
                          Icons.call,
                          color: Config.appTheme.themeColor,
                          size: 20,
                        ),
                        companyPhone,
                        "mobile"),
                    profileCard(
                        "Email: ",
                        Icon(
                          Icons.email,
                          color: Config.appTheme.themeColor,
                          size: 20,
                        ),
                        companyEmail,
                        "email"),
                    /* profileCard(
                        "Website Url: ",
                        Icon(
                          Icons.link,
                          color: Config.appTheme.themeColor,
                          size: 20,
                        ),
                        domainUrl,
                        "website"),*/
                    profileCard(
                        "Website Name",
                        Icon(
                          Icons.public,
                          color: Config.appTheme.themeColor,
                          size: 20,
                        ),
                        websiteName,
                        "website"),
                  ],
                ),
              ),
            ),
          );
        });
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
          } else if (type == "email") {
            _launchEmailClient(context, details);
          } else if (type == "website") {
            _launchURL(context, websiteName);
            print("url $details");
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
            //  SizedBox(height: 16),
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
                companyName,
                style: AppFonts.f40016
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 18),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(companyAddress1,
                  style: AppFonts.f50014Grey.copyWith(color: Colors.black)),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(companyAddress2,
                  style: AppFonts.f50014Grey.copyWith(color: Colors.black)),
            ),
          ],
        ),
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

  void _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);

    try {
      // Use canLaunchUrl from url_launcher
      // bool canLaunchUrl = await canLaunch('http://themfbox.eurekasec.com');
      final bool canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch $url'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error launching URL: $e'),
        ),
      );
    }
  }

  // void _launchURL(BuildContext context, String url) async {
  //   print("Attempting to launch URL: $url");
  //   var webUrl = url;

  //   try {
  //     bool canLaunchUrl = await canLaunch(webUrl);
  //     print("Can launch URL: $canLaunchUrl");
  //     if (canLaunchUrl) {
  //       await launch(url);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Could not launch $url'),
  //         ),
  //       );
  //       print('Could not launch $url');
  //     }
  //   } catch (e) {
  //     print("Error launching URL: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error launching URL: $e'),
  //       ),
  //     );
  //   }
  // }

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
