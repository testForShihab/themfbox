import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

class Utils {
  static double getImageScaler = 1;
  static double getTextScaler = 1;
  static bool isSmallDevice = false;

  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  static String getWhatsappIcon({required Color color, required int height, required int width}) {
    // Convert the color to hex format
    String hexColor = colorToHex(color);

    // Return the SVG string with dynamic color, width, and height
    String icon = '''<?xml version="1.0" encoding="iso-8859-1"?>
    <!-- Generator: Adobe Illustrator 21.1.0, SVG Export Plug-In . SVG Version: 6.00 Build 0) -->
    <svg fill="$hexColor" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 50 50" width="${width}px" height="${height}px">
      <path d="M25,2C12.318,2,2,12.318,2,25c0,3.96,1.023,7.854,2.963,11.29L2.037,46.73c-0.096,0.343-0.003,0.711,0.245,0.966C2.473,47.893,2.733,48,3,48c0.08,0,0.161-0.01,0.24-0.029l10.896-2.699C17.463,47.058,21.21,48,25,48c12.682,0,23-10.318,23-23S37.682,2,25,2z M36.57,33.116c-0.492,1.362-2.852,2.605-3.986,2.772c-1.018,0.149-2.306,0.213-3.72-0.231c-0.857-0.27-1.957-0.628-3.366-1.229c-5.923-2.526-9.791-8.415-10.087-8.804C15.116,25.235,13,22.463,13,19.594s1.525-4.28,2.067-4.864c0.542-0.584,1.181-0.73,1.575-0.73s0.787,0.005,1.132,0.021c0.363,0.018,0.85-0.137,1.329,1.001c0.492,1.168,1.673,4.037,1.819,4.33c0.148,0.292,0.246,0.633,0.05,1.022c-0.196,0.389-0.294,0.632-0.59,0.973s-0.62,0.76-0.886,1.022c-0.296,0.291-0.603,0.606-0.259,1.19c0.344,0.584,1.529,2.493,3.285,4.039c2.255,1.986,4.158,2.602,4.748,2.894c0.59,0.292,0.935,0.243,1.279-0.146c0.344-0.39,1.476-1.703,1.869-2.286s0.787-0.487,1.329-0.292c0.542,0.194,3.445,1.604,4.035,1.896c0.59,0.292,0.984,0.438,1.132,0.681C37.062,30.587,37.062,31.755,36.57,33.116z"/>
    </svg>''';

    return icon;
  }

  static Widget getImage(String imageUrl, double imageHeight) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/empty.png', // Local placeholder image
      image: imageUrl,
      height: imageHeight,
      imageErrorBuilder: (context, error, stackTrace) {
        // If the image fails to load, show the default image from the network
        return Image.network(
          'https://api.mymfbox.com/images/amc/empty.png',
          height: imageHeight,
        );
      },
    );
  }

  static Widget showBoxError({required double height, String? msg}) {
    return Container(
      height: height,
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Config.appTheme.lineColor)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 34),
          SizedBox(height: 10),
          Text(msg ?? "null error", style: AppFonts.f50014Black)
        ],
      ),
    );
  }

  static showError(BuildContext? context, String text) {
    if (EasyLoading.isShow) EasyLoading.dismiss();
    double devWidth;
    if (context == null)
      devWidth = 300;
    else
      devWidth = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context ?? Get.context!,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      )),
      builder: (context) {
        return Container(
          height: (text.length < 100) ? 160 : 200,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red),
                  Text("  Error")
                ],
              ),
              SizedBox(height: 5),
              Text(text),
              SizedBox(height: 16),
              SizedBox(
                  width: devWidth,
                  height: 45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Config.appTheme.themeColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("Ok")))
            ],
          ),
        );
      },
    );
  }

  static Widget shimmerWidget(double height, {EdgeInsets? margin}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      direction: ShimmerDirection.ltr,
      child: Container(
        margin: margin ?? EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[300],
        ),
        height: height,
        width: double.infinity,
      ),
    );
  }

  static Widget rpSelectedCard(
      {required String text, required ButtonType type}) {
    return Container(
      padding: EdgeInsets.fromLTRB(40, 14, 40, 4),
      margin: EdgeInsets.only(top: 8, bottom: 12),
      decoration: BoxDecoration(
        color: Config.appTheme.overlay85,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text("$text", style: AppFonts.f50014Theme),
    );
  }

  static String formatNumber(num? source,
      {bool isAmount = false, bool isShortAmount = false}) {
    if (source == null) return "0";
    NumberFormat formatter = NumberFormat("#,##,###.##");
    String suffix = "";
    if (isShortAmount) {
      if (source > crore) {
        source /= crore;
        suffix = " Cr";
      } else if (source > lakh) {
        source /= lakh;
        suffix = " L";
      } else {
        source /= 1000;
        suffix = " K";
      }
    }
    String result = formatter.format(source);
    return result + suffix;
  }

  static String navformatNumber(num? source) {
    if (source == null) return "0";
    NumberFormat formatter = NumberFormat("#,##,###.####");
    String result = formatter.format(source);
    return result ;
  }

  static double getMultiplier(double percent) {
    double multiplier = 0;

    if (percent >= 50) {
      multiplier = 1;
    } else if (percent >= 30 && percent < 50) {
      multiplier = 2;
    } else if (percent >= 20 && percent < 30) {
      multiplier = 3;
    } else if (percent >= 10 && percent < 20) {
      multiplier = 5;
    } else if (percent >= 5 && percent < 10) {
      multiplier = 10;
    } else if (percent >= 3 && percent < 5) {
      multiplier = 15;
    } else if (percent >= 1 && percent < 3) {
      multiplier = 25;
    } else {
      multiplier = 3;
    }

    return multiplier;
  }

  static String getFirst13(String? s, {int count = 20}) {
    if (s == null) return "null";
    if (s.length > count) {
      s = s.substring(0, count);
      s += "..";
    }
    return s;
  }

  static String getFirst24C(String? s, {int count = 30}) {
    if (s == null) return "null";
    if (s.length > count) {
      s = s.substring(0, count);
      s += "..";
    }
    return s;
  }

  static String getFirst10(String? s, {int count = 15}) {
    if (s == null) return "null";
    if (s.length > count) {
      s = s.substring(0, count);
      s += "..";
    }
    return s;
  }

  static String getFormattedDate({DateTime? date}) {
    date ??= DateTime.now();
    return "${date.day} ${monthList[date.month]} ${date.year}";
  }

  static String getchequeFormattedDate({DateTime? date}) {
    date ??= DateTime.now();
    return "${date.day}-${monthList[date.month]}-${date.year}";
  }

  static bool isValidSlider(num temp) {
    if (temp < 0 || temp > 100)
      return false;
    else
      return true;
  }

  static String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  static String? getKeyByValue(Map map, String value) {
    if (value.isEmpty) return null;
    return map.keys.firstWhere((element) => map[element] == value);
  }

  static String getDividendCode({
    required String schemeAmfi,
    required String marketType,
    required String payout,
  }) {
    List list = [
      "IDCW",
      "INCOME DISTRIBUTION",
    ];
    bool showPayoutOptions = false;
    for (String element in list) {
      if (schemeAmfi.toUpperCase().contains(element)) showPayoutOptions = true;
    }

    marketType = marketType.toUpperCase();

    if (!showPayoutOptions) {
      if (marketType == "NSE") return "Z";
      if (marketType == "BSE") return "Z";
      if (marketType == "MFU") return "N";
    } else {
      if (marketType == "NSE") {
        if (payout.contains("Reinvest")) return "Y";
        if (payout.contains("Payout")) return "N";
      }
      if (marketType == "BSE") {
        if (payout.contains("Reinvest")) return "Y";
        if (payout.contains("Payout")) return "N";
      }
      if (marketType == "MFU") {
        if (payout.contains("Reinvest")) return "R";
        if (payout.contains("Payout")) return "P";
      }
    }
    return "invalid";
  }

  static bool searchVisibility(String title, String searchKey) {
    title = title.toLowerCase();
    searchKey = searchKey.toLowerCase();

    if (searchKey.isEmpty)
      return true;
    else {
      return title.contains(searchKey);
    }
  }
}

int getUserId() {
  int? type_id = GetStorage().read("type_id");
  int? mfd_id = GetStorage().read("mfd_id");
  int? user_id = GetStorage().read("user_id");
  int? family_id = GetStorage().read("family_id");
  int? adminAsInvestor = GetStorage().read("adminAsInvestor");
  int? adminAsFamily = GetStorage().read("adminAsFamily");
  bool? familyAsInvestor = GetStorage().read("familyAsInvestor");

  // if (type_id == 9) return mfd_id!;

  if (type_id == 1) return user_id!;

  if (type_id == 3) {
    if (familyAsInvestor == true) {
      return user_id!;
    } else {
      return family_id!;
    }
  }

  if (type_id == 5 ||
      type_id == 2 ||
      type_id == 4 ||
      type_id == 7 ||
      type_id == 9) {
    if (adminAsInvestor != null) return user_id!;

    if (adminAsFamily != null) {
      if (familyAsInvestor == true) {
        return user_id!;
      } else {
        return family_id!;
      }
    }

    return mfd_id!;
  }

  /*if (type_id == 2) {
    if (adminAsInvestor != null) return user_id ?? -6;
    if (adminAsFamily != null) return family_id ?? -8;
    return mfd_id ?? -2;
  }
  if (type_id == 4){
    if (adminAsInvestor != null) return user_id ?? -6;
    if (adminAsFamily != null) return family_id ?? -8;
    return mfd_id ?? -5;
  }
  if (type_id == 7) {
    if (adminAsInvestor != null) return user_id ?? -6;
    if (adminAsFamily != null) return family_id ?? -8;
    return mfd_id ?? -5;
  }*/
  return 0;
}

convertDtToStr(DateTime dt) {
  String day = dt.day.toString().padLeft(2, "0");
  String month = dt.month.toString().padLeft(2, "0");
  String year = dt.year.toString().padLeft(2, "0");

  return "$day-$month-$year";
}

convertSIPDtToStr(DateTime dt) {
  String day = dt.day.toString().padLeft(2, "0");
  String month = dt.month.toString().padLeft(2, "0");
  String year = dt.year.toString().padLeft(2, "0");

  return "$day/$month/$year";
}

DateTime convertStrToDt(String str) {
  if (str.isEmpty) return DateTime(2002);
  List list = str.split("-");
  int day = int.parse(list[0]);
  int month = int.parse(list[1]);
  int year = int.parse(list[2]);

  DateTime dt = DateTime(year, month, day);
  return dt;
}



double setImageSize(num size) {
  return size * Utils.getImageScaler;
}

Future<void> rpDownloadFile({required String url, required int index,  BuildContext? context}) async {
  Dio dio = Dio();
  String dirloc = "";

  if (Platform.isIOS) {
    if (await Permission.storage.request().isGranted)
      dirloc = (await getTemporaryDirectory()).path;
    // else
    //   showError();
  }
  // android
  else if (Platform.isAndroid) {
    // if (await Permission.storage.request().isGranted)
    dirloc = (await getExternalStorageDirectory())?.path ?? "";
  }
  print("Url == $url");
  if (index == 2) {
    Fluttertoast.showToast(
        msg: url,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Config.appTheme.themeColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  try {
    EasyLoading.show(status: 'loading...');
    FileUtils.mkdir([dirloc]);
    String fileName = url.substring(url.lastIndexOf("/") + 1);
    fileName = "/$fileName";
    await dio.download(url, dirloc + fileName,
        onReceiveProgress: (receivedBytes, totalBytes) {});

    EasyLoading.dismiss();
    final _result = await OpenFile.open(dirloc + fileName);
    Fluttertoast.showToast(
        msg: _result.message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Config.appTheme.themeColor,
        textColor: Colors.white,
        fontSize: 16.0);
  } catch (e) {
    print('Error opening PDF: $e');
  }
}

Future<void> rpDownloadExcelFile({required String url, required int index,  BuildContext? context}) async {
  Dio dio = Dio();
  String dirloc = "";

  if (Platform.isIOS) {
    if (await Permission.storage.request().isGranted)
      dirloc = (await getTemporaryDirectory()).path;
    // else
    //   showError();
  }
  // android
  else if (Platform.isAndroid) {
    // if (await Permission.storage.request().isGranted)
    dirloc = (await getExternalStorageDirectory())?.path ?? "";
  }
  print("Url == $url");
  try {
    EasyLoading.show(status: 'loading...');
    FileUtils.mkdir([dirloc]);
    String fileName = url.substring(url.lastIndexOf("/") + 1);
    fileName = "/$fileName";
    await dio.download(url, dirloc + fileName,
        onReceiveProgress: (receivedBytes, totalBytes) {});

    EasyLoading.dismiss();
    final _result = await OpenFile.open(dirloc + fileName);
    Fluttertoast.showToast(
        msg: _result.message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Config.appTheme.themeColor,
        textColor: Colors.white,
        fontSize: 16.0);
  } catch (e) {
    print('Error opening PDF: $e');
  }
}

class WhatsappIcon extends StatelessWidget {
  final double height;
  final double width;
  final Color color;

  const WhatsappIcon({required this.height, required this.width,required this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      Utils.getWhatsappIcon(color: color, height: height.toInt(), width: width.toInt()),
      height: height,
      width: width,
    );
  }
}