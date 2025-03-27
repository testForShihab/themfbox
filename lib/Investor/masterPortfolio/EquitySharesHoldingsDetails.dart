import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../api/InvestorApi.dart';
import '../../rp_widgets/ColumnText.dart';
import '../../rp_widgets/InvAppBar.dart';
import '../../rp_widgets/SideBar.dart';
import '../../utils/Config.dart';
import '../../utils/Utils.dart';


class EquitySharesHoldingsDetails extends StatefulWidget {
  const EquitySharesHoldingsDetails({
    super.key,
    required this.compayName,
  });

  final String compayName;

  @override
  State<EquitySharesHoldingsDetails> createState() => _EquitySharesHoldingsDetailsState();
}

class _EquitySharesHoldingsDetailsState extends State<EquitySharesHoldingsDetails> {

  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  String compayName = " ";

  List<response> transactions = [];
  bool isLoading = true;

  Future getDirectEquityTransactionDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      Map data = await InvestorApi.getDirectEquityTransactionDetails(
          user_id: user_id,
          client_name: client_name,
          company_name: widget.compayName);

      print("API Response: $data"); // Debug print

      if (data['status'] != 200) {
        Utils.showError(context, data['msg']);
        setState(() {
          isLoading = false;
        });
        return;
      }

      setState(() {
        if (data['equity_transaction_list'] != null) {
          var rawList = List<Map<String, dynamic>>.from(data['equity_transaction_list']);
          transactions = rawList.map((item) => response.fromJson(item)).toList();
          print("Processed transactions length: ${transactions.length}");
        } else {
          transactions = [];
        }
        isLoading = false;
      });
    } catch (e) {
      print("Error processing data: $e");
      setState(() {
        isLoading = false;
        transactions = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    compayName = widget.compayName;
    getDirectEquityTransactionDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar:
      invAppBar(title: Utils.getFirst24C(compayName) ,showCartIcon: false),
      body: SideBar(
        child: isLoading 
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Total Transactions: ${transactions.length}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (transactions.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('No transactions found'),
                      ),
                    )
                  else
                    ...transactions.map((transaction) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [

                                  Expanded(
                                    child: ColumnText(
                                      title: "Exchange Name",
                                      value: transaction.exchangeType ?? '-',
                                      alignment: CrossAxisAlignment.start,
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 18,),
                              Row(
                                children: [
                                  Expanded(
                                    child: ColumnText(
                                      title: "Script Name",
                                      value: transaction.companyName ?? '-',
                                      alignment: CrossAxisAlignment.start,
                                    ),
                                  ),
                                  Expanded(
                                    child: ColumnText(
                                      title: "Transaction Type",
                                      value: transaction.trxnType ?? '-',
                                      alignment: CrossAxisAlignment.end,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 18,),
                              rpRow(
                                lhead: "Purchase Date",
                                lSubHead: transaction.purchaseDateStr ?? '-',
                                rhead: "Shares",
                                rSubHead: transaction.share?.toStringAsFixed(0) ?? '-',
                                chead: "Price",
                                cSubHead: transaction.price?.toStringAsFixed(2) ?? '-',
                              ),
                            ],
                          ),
                        ),
                      ),
                    )).toList(),
                ],
              ),
            ),
      ),
    );
  }




  Widget rpRow({
    required String lhead,
    required String lSubHead,
    required String rhead,
    required String rSubHead,
    required String chead,
    required String cSubHead,
    final TextStyle? valueStyle,
    final TextStyle? titleStyle,
  }) {
    return Row(
      children: [
        Expanded(
            child: ColumnText(
                title: lhead,
                value: lSubHead,
                alignment: CrossAxisAlignment.start)),
        Expanded(
            child: ColumnText(
              title: rhead,
              value: rSubHead,
              alignment: CrossAxisAlignment.center,
              valueStyle: valueStyle,
              titleStyle: titleStyle,
            )),
        Expanded(
            child: ColumnText(
                title: chead,
                value: cSubHead,
                alignment: CrossAxisAlignment.end)),
      ],
    );
  }
}

class response {
  int? id;
  String? name;
  String? pan;
  String? exchangeType;
  String? equityHolderName;
  String? companyName;
  String? companyCode;
  String? purchaseDate;
  double? share;
  double? price;
  String? regNo;
  String? trxnType;
  String? brokerName;
  String? dematBankName;
  String? clientName;
  int? userId;
  String? purchaseDateStr;

  response(
      {this.id,
        this.name,
        this.pan,
        this.exchangeType,
        this.equityHolderName,
        this.companyName,
        this.companyCode,
        this.purchaseDate,
        this.share,
        this.price,
        this.regNo,
        this.trxnType,
        this.brokerName,
        this.dematBankName,
        this.clientName,
        this.userId,
        this.purchaseDateStr});

  response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pan = json['pan'];
    exchangeType = json['exchange_type'];
    equityHolderName = json['equity_holder_name'];
    companyName = json['company_name'];
    companyCode = json['company_code'];
    purchaseDate = json['purchase_date'];
    share = json['share']?.toDouble();
    price = json['price']?.toDouble();
    regNo = json['reg_no'];
    trxnType = json['trxn_type'];
    brokerName = json['broker_name'];
    dematBankName = json['demat_bank_name'];
    clientName = json['client_name'];
    userId = json['user_id'];
    purchaseDateStr = json['purchase_date_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['pan'] = this.pan;
    data['exchange_type'] = this.exchangeType;
    data['equity_holder_name'] = this.equityHolderName;
    data['company_name'] = this.companyName;
    data['company_code'] = this.companyCode;
    data['purchase_date'] = this.purchaseDate;
    data['share'] = this.share;
    data['price'] = this.price;
    data['reg_no'] = this.regNo;
    data['trxn_type'] = this.trxnType;
    data['broker_name'] = this.brokerName;
    data['demat_bank_name'] = this.dematBankName;
    data['client_name'] = this.clientName;
    data['user_id'] = this.userId;
    data['purchase_date_str'] = this.purchaseDateStr;
    return data;
  }
}
