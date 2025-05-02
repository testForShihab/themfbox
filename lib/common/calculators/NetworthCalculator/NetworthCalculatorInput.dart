import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/common/calculators/NetworthCalculator/NetworthCalculatorOutput.dart';
import 'package:mymfbox2_0/utils/Config.dart';

import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../input_formatters.dart';

class NetworthCalculatorInput extends StatefulWidget {
  const NetworthCalculatorInput({super.key});

  @override
  State<NetworthCalculatorInput> createState() =>
      _NetworthCalculatorInputState();
}

class _NetworthCalculatorInputState extends State<NetworthCalculatorInput> {
  late double devHeight, devWidth;
  String client_name = GetStorage().read("client_name");

  num financialAssets = 500000;
  num fixedIncomeAssets = 200000;
  num cashBankAccount = 300000;
  num property = 200000;
  num goldJwelleries = 200000;
  num othersAny = 200000;

  num homeLoan = 50000;
  num personalOtherLoans = 250000;
  num incomeTaxOwed = 200000;
  num outstandingBills = 500000;
  num creditCardDues = 200000;
  num othersLiabilities = 20000;

  num balance = 0;

  String distReturn1 = "0";

  String distReturn2 = "0";

  num currentSavings = 0;
  num energyCorpus = 0;

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Networth Calculator",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Financial Assets",
                      style: AppFonts.f50012.copyWith(fontSize: 16)),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Shares & Equity Mutual Funds (Rs.)",
                    initialValue: Utils.formatNumber(500000),
                    inputFormatters: [
                      MaxValueFormatter(
                        1000000,
                        isDecimal: false,
                        isReadableInput: true,
                      ),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                      ReadableNumberFormatter(),
                    ],
                    suffixText:
                        Utils.formatNumber(financialAssets, isAmount: true),
                    onChange: (val) {
                      final tempVal = val.split(',').join();
                      financialAssets = num.tryParse(tempVal) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title:
                        "Fixed Income Assets (Rs.) (Fixed deposits, Bonds, debt funds, PPF etc.)",
                    initialValue: Utils.formatNumber(200000),
                    inputFormatters: [
                      MaxValueFormatter(
                        1000000,
                        isDecimal: false,
                        isReadableInput: true,
                      ),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                      ReadableNumberFormatter(),
                    ],
                    suffixText:
                        Utils.formatNumber(fixedIncomeAssets, isAmount: true),
                    onChange: (val) {
                      final tempVal = val.split(',').join();
                      fixedIncomeAssets = num.tryParse(tempVal) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title:
                        "Cash and Bank Accounts (Rs.)(Savings accounts, Cash in hand, liquid funds, etc.)",
                    initialValue: Utils.formatNumber(300000),
                    inputFormatters: [
                      MaxValueFormatter(
                        1000000,
                        isDecimal: false,
                        isReadableInput: true,
                      ),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                      ReadableNumberFormatter(),
                    ],
                    suffixText:
                        Utils.formatNumber(cashBankAccount, isAmount: true),
                    onChange: (val) {
                      final tempVal = val.split(',').join();
                      cashBankAccount = num.tryParse(tempVal) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Property (Rs.)",
                    initialValue: Utils.formatNumber(200000),
                    inputFormatters: [
                      MaxValueFormatter(
                        1000000,
                        isDecimal: false,
                        isReadableInput: true,
                      ),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                      ReadableNumberFormatter(),
                    ],
                    suffixText: Utils.formatNumber(property, isAmount: true),
                    onChange: (val) {
                      final tempVal = val.split(',').join();
                      property = num.tryParse(tempVal) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Gold and Jewelleries (Rs.)",
                    initialValue: Utils.formatNumber(200000),
                    inputFormatters: [
                      MaxValueFormatter(
                        1000000,
                        isDecimal: false,
                        isReadableInput: true,
                      ),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                      ReadableNumberFormatter(),
                    ],
                    suffixText:
                        Utils.formatNumber(goldJwelleries, isAmount: true),
                    onChange: (val) {
                      final tempVal = val.split(',').join();
                      goldJwelleries = num.tryParse(tempVal) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Others (if any) (Rs.)",
                    initialValue: Utils.formatNumber(200000),
                    inputFormatters: [
                      MaxValueFormatter(
                        1000000,
                        isDecimal: false,
                        isReadableInput: true,
                      ),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                      ReadableNumberFormatter(),
                    ],
                    suffixText: Utils.formatNumber(othersAny, isAmount: true),
                    onChange: (val) {
                      final tempVal = val.split(',').join();
                      othersAny = num.tryParse(tempVal) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  Text("Liabilities",
                      style: AppFonts.f50012.copyWith(fontSize: 16)),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Home Loan (Rs.)",
                    initialValue: Utils.formatNumber(50000),
                    inputFormatters: [
                      MaxValueFormatter(
                        1000000,
                        isDecimal: false,
                        isReadableInput: true,
                      ),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                      ReadableNumberFormatter(),
                    ],
                    suffixText: Utils.formatNumber(homeLoan, isAmount: true),
                    onChange: (val) {
                      final tempVal = val.split(',').join();
                      homeLoan = num.tryParse(tempVal) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Personal & other Loans (Rs.)",
                    initialValue: Utils.formatNumber(250000),
                    inputFormatters: [
                      MaxValueFormatter(
                        1000000,
                        isDecimal: false,
                        isReadableInput: true,
                      ),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                      ReadableNumberFormatter(),
                    ],
                    suffixText:
                        Utils.formatNumber(personalOtherLoans, isAmount: true),
                    onChange: (val) {
                      final tempVal = val.split(',').join();
                      personalOtherLoans = num.tryParse(tempVal) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Income Tax owed (Rs.)",
                    initialValue: Utils.formatNumber(200000),
                    inputFormatters: [
                      MaxValueFormatter(
                        1000000,
                        isDecimal: false,
                        isReadableInput: true,
                      ),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                      ReadableNumberFormatter(),
                    ],
                    suffixText:
                        Utils.formatNumber(incomeTaxOwed, isAmount: true),
                    onChange: (val) {
                      final tempVal = val.split(',').join();
                      incomeTaxOwed = num.tryParse(tempVal) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Outstanding bills / payments (Rs.)",
                    initialValue: Utils.formatNumber(500000),
                    inputFormatters: [
                      MaxValueFormatter(
                        1000000,
                        isDecimal: false,
                        isReadableInput: true,
                      ),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                      ReadableNumberFormatter(),
                    ],
                    suffixText:
                        Utils.formatNumber(outstandingBills, isAmount: true),
                    onChange: (val) {
                      final tempVal = val.split(',').join();
                      outstandingBills = num.tryParse(tempVal) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Credit Card dues (Rs.)",
                    initialValue: Utils.formatNumber(200000),
                    inputFormatters: [
                      MaxValueFormatter(
                        1000000,
                        isDecimal: false,
                        isReadableInput: true,
                      ),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                      ReadableNumberFormatter(),
                    ],
                    suffixText:
                        Utils.formatNumber(creditCardDues, isAmount: true),
                    onChange: (val) {
                      final tempVal = val.split(',').join();
                      creditCardDues = num.tryParse(tempVal) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Other liabilities (if any) (Rs.)",
                    initialValue: Utils.formatNumber(20000),
                    inputFormatters: [
                      MaxValueFormatter(
                        1000000,
                        isDecimal: false,
                        isReadableInput: true,
                      ),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                      ReadableNumberFormatter(),
                    ],
                    suffixText:
                        Utils.formatNumber(othersLiabilities, isAmount: true),
                    onChange: (val) {
                      final tempVal = val.split(',').join();
                      othersLiabilities = num.tryParse(tempVal) ?? 0;
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: devWidth,
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: SizedBox(
                  height: 45,
                  child: ElevatedButton(
                      onPressed: () async {
                        EasyLoading.isShow;

                        bool isValid = validator();
                        if (!isValid) return;
                        print('Financial Assets = $financialAssets');
                        print('Fixed Income Assets = $fixedIncomeAssets');
                        print('Cash Bank Account  = $cashBankAccount');
                        print('Property = $property');
                        print('Gold Jwelleries = $goldJwelleries');
                        print('Others Any = $othersAny');

                        print('Home Loan = $homeLoan');
                        print('Personal Other Loans = $personalOtherLoans');
                        print('Income Tax Owed = $incomeTaxOwed');
                        print('Outstanding Bills = $outstandingBills');
                        print('Credit Card Dues = $creditCardDues');
                        print('Others Liabilities = $othersLiabilities');

                        Map data = await Api.getNetworthCalculator(
                            shares_equity_value: '$financialAssets',
                            fixed_income_value: '$fixedIncomeAssets',
                            cash_value: '$cashBankAccount',
                            property_value: '$property',
                            gold_value: '$goldJwelleries',
                            other_assets_value: '$othersAny',
                            home_loan_value: '$homeLoan',
                            personal_other_loan_value: '$personalOtherLoans',
                            income_tax_value: '$incomeTaxOwed',
                            outstanding_bill_value: '$outstandingBills',
                            credit_card_due_value: '$creditCardDues',
                            other_liabilities_value: '$othersLiabilities',
                            client_name: client_name);
                        Get.to(() => NetworthCalculatorOutput(
                              networthCalculatorResult: data['result'],
                              shares_equity: financialAssets,
                              fixed_income: fixedIncomeAssets,
                              cash_value: cashBankAccount,
                              property_value: property,
                              gold_value: goldJwelleries,
                              other_assets_value: othersAny,
                              home_loan_value: homeLoan,
                              personal_other_loan_value: personalOtherLoans,
                              income_tax_value: incomeTaxOwed,
                              outstanding_bill_value: outstandingBills,
                              credit_card_due_value: creditCardDues,
                              other_liabilities_value: othersLiabilities,
                            ));
                        EasyLoading.dismiss();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Config.appTheme.buttonColor,
                          foregroundColor:
                              Colors.white // Set the background color here
                          ),
                      child: Text("CALCULATE"))),
            ),
          ],
        ),
      ),
    );
  }

  validator() {
    /*List l = [
      financialAssets,
      fixedIncomeAssets,
      cashBankAccount,
      property,
      goldJwelleries,
      othersAny,
      homeLoan,
      personalOtherLoans,
      incomeTaxOwed,
      outstandingBills,
      creditCardDues,
      othersLiabilities
    ];
    if (l.contains(null)) {
      EasyLoading.showError("All Fields are mandatory!");
      return false;
    }*/
    /*  if (l.contains(0)) {
      EasyLoading.showError("Zero Not Allowed");
      return false;
    }*/

    if (financialAssets == 0 &&
        fixedIncomeAssets == 0 &&
        cashBankAccount == 0 &&
        property == 0 &&
        goldJwelleries == 0 &&
        othersAny == 0) {
      EasyLoading.showError("Please enter the value for financial assets");
      return false;
    }

    if (homeLoan == 0 &&
        personalOtherLoans == 0 &&
        incomeTaxOwed == 0 &&
        outstandingBills == 0 &&
        creditCardDues == 0 &&
        othersLiabilities == 0) {
      EasyLoading.showError("Please enter the value for liabilities");
      return false;
    }

    /*if (financialAssets <= -1) {
      EasyLoading.showError(
          "Please enter the correct value of Shares & Equity Mutual Funds assets");
      return false;
    }
    if (fixedIncomeAssets <= -1) {
      EasyLoading.showError(
          "Please enter the correct value of Fixed Income assets");
      return false;
    }
    if (cashBankAccount <= -1) {
      EasyLoading.showError(
          "Please enter the correct value of Cash and Bank Accounts assets");
      return false;
    }
    if (property <= -1) {
      EasyLoading.showError(
          "Please enter the correct value of Property assets");
      return false;
    }
    if (goldJwelleries <= -1) {
      EasyLoading.showError(
          "Please enter the correct value of Gold and Jewelleries assets");
      return false;
    }
    if (othersAny <= -1) {
      EasyLoading.showError("Please enter the correct value of Others assets");
      return false;
    }
    if (homeLoan <= -1) {
      EasyLoading.showError("Please enter the correct value of Home Loan");
      return false;
    }
    if (personalOtherLoans <= -1) {
      EasyLoading.showError(
          "Please enter the correct value of Personal & other Loans");
      return false;
    }
    if (incomeTaxOwed <= -1) {
      EasyLoading.showError(
          "Please enter the correct value of Income Tax owed");
      return false;
    }
    if (outstandingBills <= -1) {
      EasyLoading.showError(
          "Please enter the correct value of Outstanding bills / payments");
      return false;
    }
    if (creditCardDues <= -1) {
      EasyLoading.showError(
          "Please enter the correct value of Credit Card dues");
      return false;
    }
    if (othersLiabilities <= -1) {
      EasyLoading.showError(
          "Please enter the correct value of Other liabilities");
      return false;
    }*/
    /*  for (var value in l) {
      if (value <= -1) {
        EasyLoading.showError(
            "Please enter the correct value -1 below not allowed");
        return false;
      }
    }*/
    return true;
  }
}
