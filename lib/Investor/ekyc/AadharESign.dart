import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/Investor/ekyc/ContractWebview.dart';
import 'package:mymfbox2_0/api/EkycApi.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class AadharESign extends StatefulWidget {
  const AadharESign({super.key});

  @override
  State<AadharESign> createState() => _AadharESignState();
}

class _AadharESignState extends State<AadharESign> {
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  String ekyc_id = GetStorage().read("ekyc_id");

  List acceptedList = [
    false,
    false,
  ];

  List terms = [
    "I here by confirm that the signature to be used here is a copy of my hand signature and I agree on it being as my valid consent for the document to be digitally signed by me.",
    "I consent for Signzy technologies pvt ltd to link the given signature to my email ID or mobile number I have provided and on my consent to be used for purpose of digitally consenting to agreements in future."
  ];

  Map contract = {};

  Future getContractPreview() async {
    if (contract.isNotEmpty) return 0;
    panLoading.value = true;

    Map data = await EkycApi.getContractPreview(
        user_id: user_id, client_name: client_name, ekyc_id: ekyc_id);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      panError.value = data['msg'] ?? "null error";
      panLoading.value = false;
      return -1;
    }

    panLoading.value = false;
    contract = data;
    return 0;
  }

  late double devHeight, devWidth;
  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;

    return FutureBuilder(
        future: getContractPreview(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: rpAppBar(
              title: "Aadhar Sign",
              bgColor: Config.appTheme.themeColor,
              foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Preview your document and Aadhaar eSign to complete the KYC process.",
                        style: AppFonts.f50014Grey),
                    SizedBox(height: 16),
                    instructionCard(),
                    SizedBox(height: 16),
                    pdfArea(),
                    SizedBox(height: 16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: acceptedList[index],
                              onChanged: (value) {
                                acceptedList[index] = value ?? false;
                                setState(() {});
                              },
                            ),
                            Expanded(
                              child: Text(
                                terms[index],
                                style: AppFonts.f50012Grey,
                              ),
                            )
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(height: 16),
                    ),
                    SizedBox(height: 72),
                  ],
                ),
              ),
            ),
            bottomSheet: Visibility(
              visible: !acceptedList.contains(false),
              child: CalculateButton(
                onPress: () async {
                  Get.to(() => ContractWebview(url: contract['redirect_url']));
                },
                text: "CONTINUE TO AADHAAR eSIGN",
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
          );
        });
  }

  List instructionList = [
    "1. Once you click on the below button, you will be redirected to aadhar esign via Signzy.",
    "2. Preview your KYC document and complete the process by entering aadhaar OTP.",
    "3. Once you have completed the process, you will be automatically redirected, and your KYC will be submitted for further processing."
  ];
  Widget instructionCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_circle),
              SizedBox(width: 10),
              Text("Instructions", style: AppFonts.f50014Black)
            ],
          ),
          SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: instructionList.length,
            itemBuilder: (context, index) {
              String temp = instructionList[index];
              return Text(
                temp,
                style: AppFonts.f50012Grey,
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(height: 8),
          )
        ],
      ),
    );
  }

  RxBool panLoading = true.obs;
  RxString panError = "".obs;
  Widget pdfArea() {
    return Obx(() {
      if (panLoading.isTrue)
        return Utils.shimmerWidget(300, margin: EdgeInsets.zero);
      if (panError.isNotEmpty) return Text(panError.value);

      return SizedBox(
        height: 250,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: PDF().cachedFromUrl(
                  placeholder: (progress) =>
                      Utils.shimmerWidget(400, margin: EdgeInsets.zero),
                  errorWidget: (error) {
                    return Text("Error = $error");
                  },
                  "${contract['contractPDFUrl']}"),
            ),
            blackMask(),
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 40,
                width: devWidth - 64,
                child: PlainButton(
                  text: "Contract Preview",
                  onPressed: () {
                    contractBottomSheet();
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  contractBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: 700,
          child: Column(
            children: [
              BottomSheetTitle(title: "Contract Preview"),
              Divider(height: 0, color: Config.appTheme.lineColor),
              Expanded(
                child: PDF().cachedFromUrl(
                    placeholder: (progress) =>
                        Utils.shimmerWidget(400, margin: EdgeInsets.zero),
                    errorWidget: (error) {
                      return Text("Error = $error");
                    },
                    "${contract['contractPDFUrl']}"),
              ),
              SizedBox(height: 16),
              CalculateButton(
                  onPress: () {
                    Get.to(
                        () => ContractWebview(url: contract['redirect_url']));
                  },
                  text: "CONTINUE TO AADHAAR eSIGN",
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)))
            ],
          ),
        );
      },
    );
  }

  Widget blackMask() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
    );
  }
}
