import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/InvestorMenu/InvestorMenu.dart';
import 'package:mymfbox2_0/Investor/InvestorMenu/riskProfile/RiskProfileScore.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/rp_widgets/PercentageBar.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class RiskProfile extends StatefulWidget {
  const RiskProfile({super.key});

  @override
  State<RiskProfile> createState() => _RiskProfileState();
}

class _RiskProfileState extends State<RiskProfile> {
  late double devWidth, devHeight;
  double percent = 10;
  num amount = 10;
  int selectedOption = -1;
  int prevResponse = -1;
  Map data = {};

  final List<Map<String, dynamic>> questions = [
    {
      'question':
          "What percentage of your Monthly Income(after paying home loan EMIs and credit card bills) do you save and invest for the long term?",
      'options': ["Less than 5%", "5 to 10%", "10 to 20%", "More than 20%"],
    },
    {
      'question': "What is your attitude towards savings?",
      'options': [
        "Lifestyle is important to me at this point of time. I can save later.",
        "I would like to save, but I cannot save much due to lifestyle and financial liabilities.",
        "I try to save a fixed amount every month and also invest a big portion of my one-time cash-flows.",
        "I have been saving a fixed percentage of my salary every month, based on how much I need to meet my goals. I do not rely on one-time cash-flows for investing."
      ],
    },
    {
      'question':
          "Have you invested in equity mutual funds before? If yes, for how many years?",
      'options': ["Never", "1 to 3 years", "3 to 5 years", "More than 5 years"],
    },
    {
      'question':
          "To get above average (more than FD) returns you have to take risks",
      'options': ["Strongly disagree", "Disagree", "Agree", "Strongly Agree"],
    },
    {
      'question': "How will you describe your attitude towards investing",
      'options': [
        "Protect your capital",
        "Be ready for small amount of loss, but not much",
        "Be ready for reasonable amount of short term loss, as long as your money grows in the long term",
        "Short term losses do not matter, if you have conviction in your long term investments"
      ],
    },
    {
      'question':
          "If your equity investment makes 20% losses next year will you",
      'options': [
        "Sell your investments and put the proceeds in Fixed Deposits",
        "Sell some investments, which made high losses and continue to hold some",
        "Do nothing",
        "Take advantage of the correction and invest some more money"
      ],
    },
    {
      'question': "Are you interested in market and investing?",
      'options': [
        "I have no interest",
        "I do not follow business news and the markets regularly",
        "I follow business news and market whenever I have time",
        "I follow the markets everyday or at least, every other day"
      ],
    },
    {
      'question':
          "How do you approach making financial or investment decisions",
      'options': [
        "I feel stressed about it and try to avoid making decisions",
        "I ask for advice from friends and relatives",
        "I seek professional advice",
        "I am knowledgeable about investments. I evaluate various options to make the best decision"
      ],
    },
    {
      'question':
          "How secure do you feel about your salary /business income continuing for next 10 years?",
      'options': [
        "Not secure at all",
        "Somewhat secure",
        "Fairly secure",
        "Very secure"
      ],
    },
    {
      'question':
          "How much of your investment portfolio you may have to withdraw in the next five years?",
      'options': ["More than 30%", "20 - 30%", "10 - 20%", "less than 10%"],
    },
    {
      'question':
          "When is the earliest you anticipate needing all or a substantial portion of your investments?",
      'options': [
        "Less than 3 years",
        "3 to 5 years",
        "5 - 7 years",
        "7 - 10 years",
        "More than 10 years"
      ],
    },
  ];
  int currIndex = 0;
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");

  @override
  void initState() {
    super.initState();
  }

  Map responseHistory = {};
  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;
    double percBarWidth = devWidth - 32;
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: AppBar(
        leading: SizedBox(),
        leadingWidth: 0,
        backgroundColor: Config.appTheme.themeColor,
        foregroundColor: Colors.white,
        title: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Row(
            children: [
              Icon(Icons.arrow_back),
              SizedBox(width: 10),
              Text("Check Risk Profile", style: AppFonts.appBarTitle),
              SizedBox(width: 12),
            ],
          ),
        ),
      ),
      body: SideBar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Question  ${currIndex + 1} / ${questions.length}",
                      style: AppFonts.f50014Black
                          .copyWith(color: Config.appTheme.themeColor),
                    ),
                    SizedBox(height: 16),
                    percentageBar(),
                    SizedBox(height: 16),
                    Text(
                      questions[currIndex]["question"],
                      style: AppFonts.f50014Black,
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              optionsArea(),
              SizedBox(height: devHeight * 0.2),
            ],
          ),
        ),
      ),
      bottomSheet: getBottomButton(),
      // bottomSheet: Container(
      //     width: devWidth,
      //     padding: EdgeInsets.all(16),
      //     color: Colors.white,
      //     child: Row(
      //       children: [
      //         if (currIndex > 0) previousButton(),
      //         if (currIndex == 10) finishbutton(),
      //         // if (currIndex < 10) nextButton(context),
      //         if (currIndex < 10) nx(),
      //       ],
      //     )),
    );
  }

  Widget getBottomButton() {
    if (currIndex == 0) return nextButton();
    if (currIndex == 10) return finishButton();
    return prevNextButton();
  }

  Widget nextButton() {
    return CalculateButton(
      onPress: () async {
        if (selectedOption == -1) {
          Utils.showError(context, "Please select the option");
          return;
        }
        if (currIndex < questions.length) {
          int res = await saveRiskProfile();
          if (res == -1) return;
          responseHistory[currIndex] = selectedOption;

          if (responseHistory.containsKey(currIndex + 1))
            selectedOption = responseHistory[currIndex + 1];
          else
            selectedOption = -1;

          currIndex++;
          setState(() {});
        }
      },
      text: "Next",
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    );
  }

  Widget prevNextButton() {
    return Container(
      color: Colors.white,
      height: 80,
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
              child: PlainButton(
            padding: EdgeInsets.zero,
            text: "Previous",
            onPressed: () {
              if (currIndex <= 0) return;

              currIndex--;
              selectedOption = responseHistory[currIndex];
              setState(() {});
            },
          )),
          SizedBox(width: 16),
          Expanded(
              child: RpFilledButton(
            text: "Next",
            onPressed: () async {
              if (selectedOption == -1) {
                Utils.showError(context, "Please select the option");
                return;
              }
              if (currIndex < questions.length) {
                int res = await saveRiskProfile();
                if (res == -1) return;
                responseHistory[currIndex] = selectedOption;

                if (responseHistory.containsKey(currIndex + 1))
                  selectedOption = responseHistory[currIndex + 1];
                else
                  selectedOption = -1;

                currIndex++;
                setState(() {});
              }
            },
          ))
        ],
      ),
    );
  }

  Widget finishButton() {
    return Container(
      color: Colors.white,
      height: 80,
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
              child: PlainButton(
            padding: EdgeInsets.zero,
            text: "Previous",
            onPressed: () {
              if (currIndex <= 0) return;

              currIndex--;
              selectedOption = responseHistory[currIndex];
              setState(() {});
            },
          )),
          SizedBox(width: 16),
          Expanded(
              child: RpFilledButton(
            text: "Finish",
            onPressed: () async {
              Map data = await InvestorApi.saveRiskProfile(
                  user_id: user_id,
                  client_name: client_name,
                  questionId: currIndex + 1,
                  answerId: selectedOption + 1);

              print("Message: ${data['msg']}");
              if (currIndex <= 10) {
                Get.off(RiskProfileScore(responsemsg: data['msg']));
              }
            },
          ))
        ],
      ),
    );
  }

  Future saveRiskProfile() async {
    EasyLoading.show();

    Map data = await InvestorApi.saveRiskProfile(
        user_id: user_id,
        client_name: client_name,
        questionId: currIndex + 1,
        answerId: selectedOption + 1);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    EasyLoading.dismiss();
    return 0;
  }

  Widget optionsArea() {
    List options = questions[currIndex]['options'];
    return ListView.builder(
      shrinkWrap: true,
      itemCount: options.length,
      itemBuilder: (context, index) {
        bool isSelected = (selectedOption == index);
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedOption = index;
            });
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
            child: Row(
              children: [
                Radio(
                  value: index,
                  groupValue: selectedOption,
                  onChanged: (int? val) {
                    setState(() {
                      selectedOption = val!;
                    });
                  },
                ),
                Expanded(
                  child: (isSelected)
                      ? selectedContainer(options[index])
                      : normalContainer(options[index]),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget previousButton() {
    return Container(
      decoration: BoxDecoration(),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          side: BorderSide(color: Config.appTheme.themeColor, width: 2),
        ),
        onPressed: () {
          if (currIndex > 0) {
            currIndex--;
            selectedOption = responseHistory[currIndex];
            setState(() {});
          }
        },
        child: Text(
          'PREVIOUS',
          style: TextStyle(fontSize: 16, color: Config.appTheme.themeColor),
        ),
      ),
    );
  }

  Widget normalContainer(String text) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(10)),
      child: Text(
        text,
        style: AppFonts.f50014Grey,
      ),
    );
  }

  Widget selectedContainer(String text) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Config.appTheme.mainBgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Config.appTheme.themeColor, width: 2)),
      child: Text(
        text,
        style: AppFonts.f50014Black.copyWith(color: Config.appTheme.themeColor),
      ),
    );
  }

  showExitDialog() async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Go Back?"),
              content: Text(
                  "Are you sure you want to cancel checking your risk profile?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("No")),
                TextButton(
                    onPressed: () {
                      Get.to(InvestorMenu());
                    },
                    child: Text("Yes")),
              ],
            ));
  }

  Widget percentageBar() {
    double total = devWidth - 32;
    double singleUnit = total / 11;

    return Stack(
      children: [
        Container(
          height: 7,
          width: total,
          decoration: BoxDecoration(
              color: Color(0xffDFDFDF),
              borderRadius: BorderRadius.circular(10)),
        ),
        Container(
          height: 7,
          width: singleUnit * (currIndex + 1),
          decoration: BoxDecoration(
              color: Config.appTheme.themeColor,
              borderRadius: BorderRadius.circular(10)),
        ),
      ],
    );
  }
}
