import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/NoData.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpChip.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/RpSmallTf.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:http/http.dart' as http;

class TransactionReport extends StatefulWidget {
  TransactionReport({super.key, this.selectStartDate,this.selectEndDate,this.type = ""});
  DateTime? selectStartDate;
  DateTime? selectEndDate;
  String type = "";

  @override
  State<TransactionReport> createState() => _TransactionReportState();
}

class _TransactionReportState extends State<TransactionReport> {
  late double devWidth, devHeight;
  String clientName = GetStorage().read('client_name');
  int userId = GetStorage().read('mfd_id');
  String mobile = GetStorage().read("mfd_mobile");
  Map? clientCodeMap = GetStorage().read('client_code_map');
  int type_id = GetStorage().read('type_id');

  ScrollController scrollController = ScrollController();

  String pan = GetStorage().read("pan") ?? "";
  String name = GetStorage().read("name") ?? "";

  bool isLoading = true;
  bool isPageLoad = true;
  List investorList = [];
  String selectedSort = "";
  List transList = [];
  List rejectionList = [];
  String selectedAmcName = "All AMC";
  String selectedAmcCode = "";
  List amcList = [];
  List branchList = [];
  List rmList = [];
  List subBrokerList = [];

  num grandTotal = 0;
  num rejectionCount = 0;
  int pageId = 1;
  String searchKey = "";
  bool isFirst = true;
  String investorId = "";
  String selectedInvestor = "";

  String selectedRta = "";
  String selectedBranch = "All";
  String selectedRm = "All";
  String selectedSubBroker = "All";
  String investorName = 'Select Investor';
  String amcSearch = "";

  String investorPan = '';
  Timer? searchOnStop;
  String selectedEndValue = "XIRR";

  List typeList = [
    "All",
    "All Inflow",
    "All Outflow",
    "Purchase",
    "Redemption",
    "Switch In",
    "Switch Out",
    "Transfer",
    "SIP",
    "STP In",
    "STP Out",
    "SWP",
    "Dividend Payout",
    "Dividend Reinvest",
    "Rejection"
  ];
  Map rtaMap = {
    "All": "",
    "Cams": "Cams",
    "K-Fintech": "Karvy",
  };
  Map reportActionData = {
    "Download Excel Report": ["", "", "assets/excel.png"],
  };
  String rta = "All";
  String rtaValue = "";
  String selectedType = "All";
  String selectedTypeFinal = "All";
  DateTime selectedFolioDate = DateTime.now();
  ExpansionTileController nameController = ExpansionTileController();

   DateTime? selectStartDate;
   DateTime? selectEndDate;
   String? type;

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  ExpansionTileController startDatecontroller = ExpansionTileController();
  ExpansionTileController endDateController = ExpansionTileController();

  int count = 0;
  int page_id = 1;

  bool positiveNegativeFetching = false;

  @override
  void initState() {
    //  implement initState
    super.initState();
    scrollController.addListener(scrollListener);

    selectStartDate = widget.selectStartDate;
    selectEndDate = widget.selectEndDate;
    type = widget.type;

      selectedStartDate = selectStartDate ?? DateTime.now().subtract(Duration(days: 4));
      selectedEndDate = selectEndDate ?? DateTime.now().subtract(Duration(days: 1));
      //selectedTypeFinal = type ?? selectedType;
      selectedTypeFinal = (type != null && type!.isNotEmpty) ? type! : "All";
      selectedType = selectedTypeFinal;

    print("selectStartDate:  ----> $selectedStartDate");
    print("selectEndDate:  ----> $selectedType");
    print("type: ----> $selectedTypeFinal");
    }

  Future scrollListener() async {
    double extentAfter = scrollController.position.extentAfter;
    if (extentAfter < 100 && !positiveNegativeFetching) {
      positiveNegativeFetching = true;
      print("Incrementing page_id: $page_id");
      await getMoreReport();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future searchInvestor(StateSetter bottomState) async {
    investorList = [];
    EasyLoading.show(status: "Searching for `$searchKey`");
    Map data = await AdminApi.getInvestors(
        page_id: pageId,
        client_name: clientName,
        user_id: userId,
        search: searchKey,
        branch: "",
        rmList: []);
    EasyLoading.dismiss();

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    List list = data['list'];
    bottomState(() {
      investorList = List.from(list);
    });

    return 0;
  }

  Future fetchMoreInvestor() async {
    pageId++;
    Map data = await AdminApi.getInvestors(
        page_id: pageId,
        client_name: clientName,
        user_id: userId,
        branch: "",
        rmList: []);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    List list = data['list'];

    investorList.addAll(list);
    investorList = investorList.toSet().toList();

    setState(() {});
    return 0;
  }

  Future getAllAmc() async {
    if (amcList.isNotEmpty) return 0;

    Map data = await TransactionApi.getSipAmc(
      client_name: clientName,
      bse_nse_mfu_flag: "nse",
    );

    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      print("Error if");
      return -1;
    }
    amcList = data['list'];
    amcList.insert(0, {
      "amc_name": "All AMC",
      "amc_code": "Zero",
      "amc_logo": "",
    });
    selectedAmcName = amcList[0]['amc_name'];
    selectedAmcCode = amcList[0]['amc_code'];

    return 0;
  }

  Future getAllBranch() async {
    if (branchList.isNotEmpty) return 0;
    Map data = await Api.getAllBranch(mobile: mobile, client_name: clientName);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    branchList = List<String>.from(data['list']);
    branchList.insert(0, "All");
    return 0;
  }

  Future getAllRM() async {
    if (rmList.isNotEmpty) return 0;
    Map data = await Api.getAllRM(
        mobile: mobile,
        client_name: clientName,
        branch: selectedBranch == "All" ? "" : selectedBranch);

    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    rmList = List<String>.from(data['list']);
    rmList.insert(0, "All");
    return 0;
  }

  Future getAllSubBroker() async {
    if (subBrokerList.isNotEmpty) return 0;
    Map data = await Api.getAllSubbroker(
        mobile: mobile,
        client_name: clientName,
        rm_name: selectedRm == "All" ? "" : selectedRm);

    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    subBrokerList = List<String>.from(data['list']);
    subBrokerList.insert(0, "All");
    return 0;
  }

  Future getInitialInvestor() async {
    Map data = await AdminApi.getInvestors(
        page_id: pageId,
        client_name: clientName,
        user_id: userId,
        branch: "",
        rmList: []);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    investorList = data['list'];
    print("investorList ${investorList.length}");

    return 0;
  }

  searchHandler(StateSetter bottomState) {
    const duration = Duration(milliseconds: 1000);
    if (searchOnStop != null) {
      setState(() {
        searchOnStop!.cancel();
      });
    }
    setState(() {
      searchOnStop = Timer(duration, () async {
        await searchInvestor(bottomState);
      });
    });
  }

  Future getDatas() async {
    if (!isFirst) return 0;
    await getInitialInvestor();
    await getInitialReport();
    await getAllAmc();
    if (type_id == UserType.ADMIN) await getAllBranch();
    if (type_id == UserType.ADMIN) await getAllRM();
    await getAllSubBroker();
    isFirst = false;
    return 0;
  }

  formatDate(DateTime dt) {
    return DateFormat("dd-MM-yyyy").format(dt);
  }

  xirrFormatDate(DateTime dt) {
    return DateFormat("dd MMM yyyy").format(dt);
  }

  Future getInitialReport() async {
    Map data ={};
    if(selectedTypeFinal == "Rejection"){
      data = await AdminApi.getTransactionRejectionReport(
          user_id: userId,
          client_name: clientName,
          start_date: formatDate(selectedStartDate!),
          end_date: formatDate(selectedEndDate!),
          purchase_type: 'Rejection',
          page_id: page_id
      );
    }else{
      data = await AdminApi.getTransactionReport(
        user_id: userId,
        client_name: clientName,
        start_date: formatDate(selectedStartDate!),
        end_date: formatDate(selectedEndDate!),
        branch: selectedBranch == "All" ? "" : selectedBranch,
        rm_name: selectedRm == "All" ? "" : selectedRm,
        subbroker_name: selectedSubBroker == "All" ? "" : selectedSubBroker,
        purchase_type: selectedTypeFinal,
        registrar: selectedRta,
        investor_id: investorId,
        amc_name: selectedAmcName == "All AMC" ? "" : selectedAmcName,
        page_id: page_id,
        sortDirection: '',
        sort_by: '',
        search: '',
      );

    }

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    grandTotal = data['total_amount'] ?? 0;
    count = data['total_count'] ?? 0;
    transList = data['tran_list'];
    print("transact list ${transList.length}");
    isLoading = false;

    return 0;
  }


  Future getMoreReport() async {
    page_id++;
    print("getMoreReport pageId = $page_id");
    EasyLoading.show();
    Map data = {};
    if(selectedTypeFinal == "rejection"){
      data = await AdminApi.getTransactionRejectionReport(
          user_id: userId,
          client_name: clientName,
          start_date: formatDate(selectedStartDate!),
          end_date: formatDate(selectedEndDate!),
          purchase_type: 'Rejection',
          page_id: page_id
      );
    }else {
      data = await AdminApi.getTransactionReport(
        user_id: userId,
        client_name: clientName,
        start_date: formatDate(selectedStartDate!),
        end_date: formatDate(selectedEndDate!),
        branch: selectedBranch == "All" ? "" : selectedBranch,
        rm_name: selectedRm == "All" ? "" : selectedRm,
        subbroker_name: selectedSubBroker == "All" ? "" : selectedSubBroker,
        purchase_type: selectedTypeFinal,
        registrar: selectedRta,
        investor_id: investorId,
        amc_name: selectedAmcName == "All AMC" ? "" : selectedAmcName,
        page_id: page_id,
        sortDirection: '',
        sort_by: '',
        search: '',
      );
    }

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    List newList = data['tran_list'];
    transList.addAll(newList);
    positiveNegativeFetching = false;
    EasyLoading.dismiss();

    setState(() {});

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
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
                    Text("Transaction Report",
                        style: AppFonts.appBarTitle.copyWith(fontSize: 18)),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          if (!isLoading) {
                            showCustomizedSummaryBottomSheet();
                          }
                        },
                        child: Icon(Icons.filter_alt_outlined)),
                    SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        showReportActionBottomSheet();
                      },
                      child: Icon(
                        Icons.pending_outlined,
                      ),
                    )
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                topArea(),
                blackCard(),
                countArea(),
                Expanded(
                  child: isLoading
                      ? Utils.shimmerWidget(devHeight,
                          margin: EdgeInsets.all(16))
                      : (!isLoading && transList.isEmpty)
                          ? NoData()
                          : bottomArea(),
                ),
              ],
            ),
          );
        });
  }

  getKeyByValue(Map map, String value) {
    return map.keys.firstWhere((element) => map[element] == value);
  }

  showReportActionBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Config.appTheme.mainBgColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: devWidth * 0.05),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Report Actions",
                            style: AppFonts.f50014Black.copyWith(fontSize: 16)),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        reportActionContainer(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget reportActionContainer() {
    String startDate = formatDate(selectedStartDate!);
    String endDate = formatDate(selectedEndDate!);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: reportActionData.length,
        separatorBuilder: (context, index) {
          return DottedLine(verticalPadding: 4);
        },
        itemBuilder: (context, index) {
          String title = reportActionData.keys.elementAt(index);
          List stitle = reportActionData.values.elementAt(index);
          String rmName = selectedRm == "All" ? "" : selectedRm;

          String imagePath = stitle[2];
          String msgUrl = "";
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () async {
                EasyLoading.show();
                if (index == 0) {
                  EasyLoading.show();

                  String url =
                      "${ApiConfig.apiUrl}/admin/download/downloadTransactionReportExcel?key=${ApiConfig.apiKey}&purchase_type=$selectedType&start_date=$startDate&end_date=$endDate&branch=&rm_name="
                      "&subbroker=&client_name=$clientName&registrar=&user_id=$userId&investor_id=$investorId&amc_name=";
                  http.Response response = await http.post(Uri.parse(url));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  String resUrl = data['msg'];
                  print("Excel $url");
                  rpDownloadFile(url: resUrl, context: context, index: index);
                  EasyLoading.dismiss();
                  Get.back();
                }
                EasyLoading.dismiss();
              },
              child: RpListTile(
                title: SizedBox(
                  width: 220,
                  child: Text(
                    title,
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor),
                  ),
                ),
                subTitle: Visibility(
                  visible: stitle[0].isNotEmpty,
                  child: Text(stitle[0], style: AppFonts.f40013),
                ),
                leading: Image.asset(
                  imagePath,
                  color: Config.appTheme.themeColor,
                  width: 32,
                  height: 32,
                ),
                showArrow: false,
              ),
            ),
          );
        },
      ),
    );
  }

  void showError() {
    Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Config.appTheme.themeColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  showCustomizedSummaryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (_, bottomState) {
          return SizedBox(
            height: devHeight * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BottomSheetTitle(title: "Customize Report"),
                SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          padding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (type_id != 2) ...[
                                if (type_id != 7)
                                  rtaExpansionTile(context, bottomState),
                                SizedBox(height: 4),
                                if (type_id != 7)
                                  amcExpansionTile(context, bottomState),
                                if (type_id != 7) SizedBox(height: 4),
                                if (type_id != 7)
                                  investorSearchCard(context, bottomState),
                                if (type_id != 7) SizedBox(height: 4),
                                if (type_id != 7)
                                  branchExpansionTile(context, bottomState),
                                if (type_id != 7) SizedBox(height: 4),
                                if (type_id != 7)
                                  rmExpansionTile(context, bottomState),
                                if (type_id != 7) SizedBox(height: 4),
                                if (type_id != 7)
                                  subBrokerExpansionTile(context, bottomState),
                                if (type_id != 7) SizedBox(height: 4),
                                startDateExpansionTile(context, bottomState),
                                SizedBox(height: 4),
                                endDateExpansionTile(context, bottomState),
                              ] else ...[
                                startDateExpansionTile(context, bottomState),
                                SizedBox(height: 4),
                                endDateExpansionTile(context, bottomState),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                buttonCard(),
              ],
            ),
          );
        });
      },
    );
  }

  bool bottomSheetShowDetails = false;
  showXirrReportBottomSheet(
      String shortName,
      String folioNo,
      String amcLogo,
      String startValue,
      DateTime selectedStartDate,
      String invCostStartDate,
      String currValueStartDate,
      DateTime selectedEndDate,
      String invCostEndDate,
      String currValueEndDate,
      String realisedGainLoss,
      String totalInflow,
      String totalOutflow,
      String dividendPaid,
      String absoluteReturn,
      String xirr) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (_, bottomState) {
          return Container(
            color: Colors.white,
            height: devHeight * 0.82,
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "XIRR Report",
                        style: AppFonts.f50014Black.copyWith(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.close),
                    )
                  ],
                ),
                Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(amcLogo, height: 32),
                              SizedBox(width: 8),
                              Expanded(
                                child: ColumnText(
                                  title: shortName,
                                  value: "Folio : $folioNo",
                                  titleStyle: AppFonts.f50014Black,
                                  valueStyle: AppFonts.f40013
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Config
                                    .appTheme.placeHolderInputTitleAndArrow,
                              )
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            "As on ${Utils.getFormattedDate(date: selectedStartDate)}",
                            style: AppFonts.f40013,
                          ),
                          SizedBox(height: 10),
                          summaryRowBlack(
                              initial: "A",
                              bgColor: Color(0xFF4155B9),
                              title: "Investment Cost",
                              value: Utils.formatNumber(
                                  double.parse(invCostStartDate))),
                          SizedBox(
                            height: 5,
                          ),
                          summaryRowBlack(
                              initial: "B",
                              bgColor: Color(0xFF4155B9),
                              title: "Current Value",
                              value: Utils.formatNumber(
                                  double.parse(currValueStartDate))),
                          DottedLine(),
                          Text(
                            "As on ${Utils.getFormattedDate(date: selectedEndDate)}",
                            style: AppFonts.f40013,
                          ),
                          SizedBox(height: 5),
                          summaryRowBlack(
                              initial: "C",
                              bgColor: Color(0xFFFF6F61),
                              title: "Investment Cost",
                              value: Utils.formatNumber(
                                  double.parse(invCostEndDate))),
                          summaryRowBlack(
                              initial: "D",
                              bgColor: Color(0xFFFF6F61),
                              title: "Current Value",
                              value: Utils.formatNumber(
                                  double.parse(currValueEndDate))),
                          SizedBox(height: 5),
                          DottedLine(),
                          Row(
                            children: [
                              InitialCard(
                                bgColor: Color(0xFF3C9AB6),
                                title: "E",
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  blackText("Gain/Loss"),
                                ],
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  blackText(
                                      "$rupee ${Utils.formatNumber(double.parse(realisedGainLoss))}"),
                                  GestureDetector(
                                    onTap: () {
                                      bottomSheetShowDetails =
                                          !bottomSheetShowDetails;
                                      bottomState(() {});
                                    },
                                    child: Text(
                                      "${(bottomSheetShowDetails) ? "Hide" : "View"} details",
                                      style: AppFonts.f40013.copyWith(
                                          color: Config.appTheme.themeColor,
                                          decorationColor:
                                              Config.appTheme.themeColor,
                                          decoration: TextDecoration.underline),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 16),
                          Visibility(
                              visible: bottomSheetShowDetails,
                              child: Column(
                                children: [
                                  summaryRowBlack(
                                      initial: "F",
                                      bgColor: Color(0xFF5DB25D),
                                      title: "Purchase",
                                      value: totalInflow),
                                  summaryRowBlack(
                                      initial: "G",
                                      bgColor: Color(0xFFE79C23),
                                      title: "Redemption",
                                      value: totalOutflow),
                                  summaryRowBlack(
                                      initial: "H",
                                      bgColor: Color(0xFFE79C23),
                                      title: "Dividend Pay",
                                      value: dividendPaid),
                                ],
                              )),
                          DottedLine(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ColumnText(
                                  title: "Absolute Return",
                                  value:
                                      "${double.parse(absoluteReturn).toStringAsFixed(2)}%",
                                  alignment: CrossAxisAlignment.start,
                                  titleStyle: AppFonts.f40013
                                      .copyWith(color: Colors.black),
                                  valueStyle: AppFonts.f50014Black.copyWith(
                                      color: (double.parse(absoluteReturn) > 0)
                                          ? Config.appTheme.defaultProfit
                                          : Config.appTheme.defaultLoss)),
                              ColumnText(
                                  title: "XIRR",
                                  value:
                                      "${double.parse(xirr).toStringAsFixed(2)}%",
                                  alignment: CrossAxisAlignment.end,
                                  titleStyle: AppFonts.f40013
                                      .copyWith(color: Colors.black),
                                  valueStyle: AppFonts.f50014Black.copyWith(
                                      color: (double.parse(absoluteReturn) > 0)
                                          ? Config.appTheme.defaultProfit
                                          : Config.appTheme.defaultLoss)),
                            ],
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }

  Widget appBarColumn(String title, String value, Widget suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: AppFonts.f40013.copyWith(color: Colors.white)),
        Container(
          width: devWidth * 0.42,
          padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Color(0XFFDEE6E6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Row(
              children: [
                Text(value,
                    style: TextStyle(
                        color: Config.appTheme.themeColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Spacer(),
                suffix
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buttonCard() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: 45,
        child: ElevatedButton(
          onPressed: () async {
            selectedInvestor = investorName;
            print("investorName $investorName");
            if (investorId == 0) {
              Utils.showError(context, "Please Select the Investor");
              return;
            }
            isPageLoad = false;
            EasyLoading.show();
            grandTotal = 0;
            transList = [];
            await getInitialReport();
            EasyLoading.dismiss();
            setState(() {});

            Get.back();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Config.appTheme.buttonColor,
            foregroundColor: Colors.white,
          ),
          child: Text("SUBMIT"),
        ),
      ),
    );
  }

  Widget endDateExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: endDateController,
            onExpansionChanged: (val) {},
            title: Text("End Date", style: AppFonts.f50014Black),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Utils.getFormattedDate(date: selectedEndDate),
                    style: AppFonts.f50012),
              ],
            ),
            children: [
              SizedBox(
                height: 200,
                child: ScrollDatePicker(
                  selectedDate: selectedEndDate!,
                  onDateTimeChanged: (value) {
                    selectedEndDate = value;
                    bottomState(() {});
                  },
                ),
              ),
            ],
          )),
    );
  }

  Widget startDateExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: startDatecontroller,
            title: Text("Start Date", style: AppFonts.f50014Black),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Utils.getFormattedDate(date: selectedStartDate),
                    style: AppFonts.f50012),
              ],
            ),
            children: [
              SizedBox(
                height: 200,
                child: ScrollDatePicker(
                  selectedDate: selectedStartDate!,
                  onDateTimeChanged: (value) {
                    selectedStartDate = value;
                    bottomState(() {});
                  },
                ),
              ),
            ],
          )),
    );
  }

  Widget investorSearchCard(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: nameController,
          title: Text("Client Name", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(investorName, style: AppFonts.f50012),
              // DottedLine(),
            ],
          ),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 12, 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Config.appTheme.lineColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: RpSmallTf(
                  onChange: (val) {
                    searchKey = val;
                    searchHandler(bottomState);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 350,
              child: ListView.builder(
                itemCount: investorList.length,
                itemBuilder: (context, index) {
                  String name = investorList[index]['name'];
                  String id = investorList[index]['id'].toString();
                  return InkWell(
                    onTap: () {
                      investorName = name;
                      investorId = id;
                      nameController.collapse();
                      bottomState(() {});
                      setState(() {});
                    },
                    child: ListTile(
                      leading: InitialCard(title: (name == "") ? "." : name),
                      title: Text(name),
                    ),
                  );
                },
              ),
            ),
            InkWell(
              onTap: () async {
                if (searchKey.isNotEmpty) return;

                EasyLoading.show();
                await fetchMoreInvestor();
                EasyLoading.dismiss();
              },
              child: Text(
                "Load More Results",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Config.appTheme.themeColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
    // return Expanded(
    //   child: SizedBox(
    //     height: cardHeight,
    //     child: SingleChildScrollView(
    //       child: Container(
    //         margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
    //         decoration: BoxDecoration(
    //           color: Colors.white,
    //           borderRadius: BorderRadius.circular(10),
    //         ),
    //         child: Theme(
    //           data:
    //               Theme.of(context).copyWith(dividerColor: Colors.transparent),
    //           child: ExpansionTile(
    //             initiallyExpanded: true,
    //             controller: nameController,
    //             title: Text("Investor", style: AppFonts.f50014Black),
    //             subtitle: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   investorName,
    //                   style: TextStyle(
    //                     fontWeight: FontWeight.w500,
    //                     fontSize: 13,
    //                     color: Config.appTheme.themeColor,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             children: [
    //               Padding(
    //                 padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
    //                 child: SizedBox(
    //                   height: 40,
    //                   child: TextFormField(
    //                     onChanged: (val) {
    //                       searchKey = val;
    //                       searchHandler(bottomState);
    //                     },
    //                     decoration: InputDecoration(
    //                       suffixIcon: Icon(
    //                         Icons.close,
    //                         color: Config.appTheme.themeColor,
    //                       ),
    //                       contentPadding: EdgeInsets.fromLTRB(10, 2, 12, 2),
    //                       border: OutlineInputBorder(
    //                         borderRadius: BorderRadius.circular(10),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Column(
    //                 children: [
    //                   ListView.builder(
    //                     physics: NeverScrollableScrollPhysics(),
    //                     itemCount: investorList.length,
    //                     shrinkWrap: true,
    //                     itemBuilder: (context, index) {
    //                       String name = investorList[index]['name'];
    //                       String pan = investorList[index]['pan'];
    //                       int id = investorList[index]['id'];

    //                       return InkWell(
    //                         onTap: () {
    //                           print("tapped ${investorList[index]['id']}");
    //                           print("tapped $name");
    //                           investorId = id as String;
    //                           investorName = name;
    //                           investorPan = pan;
    //                           print("investorId $investorId");
    //                           bottomState(() {});
    //                           setState(() {});
    //                         },
    //                         child: ListTile(
    //                           leading: InitialCard(title: name),
    //                           title: Text(name),
    //                         ),
    //                       );
    //                     },
    //                   ),
    //                   InkWell(
    //                     onTap: () async {
    //                       if (searchKey.isNotEmpty) return;
    //                       EasyLoading.show();
    //                       await fetchMoreInvestor();
    //                       bottomState(() {});
    //                       EasyLoading.dismiss();
    //                     },
    //                     child: Text(
    //                       "Load More Results",
    //                       style: TextStyle(
    //                         decoration: TextDecoration.underline,
    //                         color: Config.appTheme.themeColor,
    //                         fontWeight: FontWeight.w500,
    //                       ),
    //                     ),
    //                   ),
    //                   SizedBox(height: 16),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  Map folioMap = {
    "Live Folios": "Live",
    "All Folios": "All",
    "Non segregated Folios": "NonSegregated",
  };
  String selectedFolioType = "Live";
  ExpansionTileController folioController = ExpansionTileController();
  Widget folioExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: folioController,
          title: Text("Folio Type", style: AppFonts.f50014Black),
          tilePadding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${getKeyByValue(folioMap, selectedFolioType)}",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Config.appTheme.themeColor)),
              DottedLine(),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: folioMap.length,
              itemBuilder: (context, index) {
                String key = folioMap.keys.elementAt(index);
                String value = folioMap.values.elementAt(index);

                return InkWell(
                  onTap: () {
                    selectedFolioType = value;
                    folioController.collapse();
                    bottomState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: value,
                        groupValue: selectedFolioType,
                        onChanged: (temp) {
                          selectedFolioType = value;
                          folioController.collapse();
                          bottomState(() {});
                        },
                      ),
                      Text(key),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ExpansionTileController branchController = ExpansionTileController();
  Widget branchExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: branchController,
          title: Text("Branch", style: AppFonts.f50014Black),
          tilePadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedBranch, style: AppFonts.f50012),
              DottedLine(),
            ],
          ),
          children: [
            SizedBox(
              height: 100,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: branchList.length,
                      itemBuilder: (context, index) {
                        String title = branchList[index];

                        return InkWell(
                          onTap: () async {
                            selectedBranch = title;
                            print("selectedBranch $selectedBranch");
                            rmList = [];
                            await getAllRM();
                            bottomState(() {});
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: title,
                                groupValue: selectedBranch,
                                onChanged: (temp) async {
                                  selectedBranch = title;
                                  print("selectedBranch $selectedBranch");
                                  rmList = [];
                                  await getAllRM();
                                  bottomState(() {});
                                  setState(() {});
                                },
                              ),
                              Text(title),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ExpansionTileController rmController = ExpansionTileController();
  Widget rmExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: rmController,
          title: Text("RM", style: AppFonts.f50014Black),
          tilePadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedRm, style: AppFonts.f50012),
              DottedLine(),
            ],
          ),
          children: [
            SizedBox(
              height: 100,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: rmList.length,
                      itemBuilder: (context, index) {
                        String title = rmList[index];

                        return InkWell(
                          onTap: () async {
                            selectedRm = title;
                            print("selectedRm $selectedRm");
                            subBrokerList = [];
                            await getAllSubBroker();
                            bottomState(() {});
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: title,
                                groupValue: selectedRm,
                                onChanged: (temp) async {
                                  selectedRm = title;
                                  print("selectedRm $selectedRm");
                                  subBrokerList = [];
                                  await getAllSubBroker();
                                  bottomState(() {});
                                  setState(() {});
                                },
                              ),
                              Text(title),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ExpansionTileController subBrokerController = ExpansionTileController();
  Widget subBrokerExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: subBrokerController,
          title: Text("Associate", style: AppFonts.f50014Black),
          tilePadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedSubBroker, style: AppFonts.f50012),
              DottedLine(),
            ],
          ),
          children: [
            SizedBox(
              height: 100,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: subBrokerList.length,
                      itemBuilder: (context, index) {
                        String title = subBrokerList[index];

                        return InkWell(
                          onTap: () {
                            selectedSubBroker = title;
                            print("selectedSubBroker $selectedSubBroker");
                            bottomState(() {});
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: title,
                                groupValue: selectedSubBroker,
                                onChanged: (temp) {
                                  selectedSubBroker = title;
                                  print("selectedSubBroker $selectedSubBroker");
                                  bottomState(() {});
                                },
                              ),
                              Text(title),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCancelApplyButton(ButtonType type) {
    if (type == ButtonType.plain)
      return PlainButton(
        color: Config.appTheme.buttonColor,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        text: "CLEAR ALL",
        onPressed: () {},
      );
    else
      return RpFilledButton(
        color: Config.appTheme.buttonColor,
        text: "APPLY",
        onPressed: () {
          Get.back();
          setState(() {});
        },
      );
  }

  Widget bottomArea() {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (isLoading)
              ? Utils.shimmerWidget(devHeight)
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:
                      isLoading ? transList.length + 1 : transList.length,
                  itemBuilder: (context, index) {
                    if (index == transList.length) {
                      return isLoading ? Utils.shimmerWidget(devHeight) : SizedBox(); // Show shimmer effect or empty space when loading
                    }
                    Map data = transList[index];

                    // Access data as usual
                    return bottomCard(data);
                  },
                ),
        ],
      ),
    );
  }


  /*Widget bottomArea() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            controller: scrollController,  // Use the scrollController directly here
            itemCount: transList.length + 1, // Add 1 for loading indicator (optional)
            itemBuilder: (context, index) {
              if (index == transList.length) {
                return isLoading ? Utils.shimmerWidget(devHeight) : SizedBox(); // Loading indicator or empty space
              }

              Map data = transList[index];
              return bottomCard(data); // Display the transaction data
            },
          ),
        ],
      ),
    );
  }*/

  Container countArea() {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${transList.length} Items of $count",
            style: AppFonts.f40013
                .copyWith(color: Config.appTheme.placeHolderInputTitleAndArrow),
          ),
        ],
      ),
    );
  }

  String getFirst20(String text) {
    String s = text.split(":").first;
    if (s.length > 20) s = '${s.substring(0, 20)}...';
    return s;
  }

  Widget bottomCard(Map data) {
    String investorName = data['investor_name'] ?? "";
    String pan = data['pan'] ?? "";
    String scheme = data['scheme'] ?? "";
     String amcLogo = data['amc_logo'] ?? "";
    String folio = data['folio'] ?? "";
    String trxnDate = data['trxn_date'] ?? "";
    DateTime originalDate = DateTime.parse(trxnDate);
    String trnature = data['trxn_type'] ?? "";
    String amount = data['amount'] ?? "0";
    String nav = data['nav'] ?? "0";
    String units = data['units'] ?? "0";
    String tds = data['tds'] ?? "0.0";
    String stt = data['stt'] ?? "0.0";

    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InitialCard(title: investorName[0]),
                SizedBox(width: 8),
                Expanded(
                  child: ColumnText(
                    title: investorName,
                    value: "PAN: $pan",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(amcLogo, height: 32),
                SizedBox(width: 8),
                Expanded(
                  child: ColumnText(
                    title: scheme,
                    value: "Folio: $folio",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013.copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatDate(originalDate), style: AppFonts.f50014Theme),
                RpChip(label: getFirst20(trnature)),
              ],
            ),
            rpRow(
              lhead: "Amount",
              lSubHead: "$rupee ${Utils.formatNumber(double.parse(amount).round())}",
              rhead: "NAV",
              rSubHead: Utils.formatNumber(double.parse(nav)),
              chead: "Units",
              cSubHead: Utils.formatNumber(double.parse(units), isAmount: false),
            ),
            SizedBox(height: 8),
            rpRow(
              lhead: "TDS",
              lSubHead: tds,
              rhead: "STT",
              rSubHead: stt,
              chead: "",
              cSubHead: "",
            ),
          ],
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
        Expanded(child: ColumnText(title: lhead, value: lSubHead,alignment: CrossAxisAlignment.start)),
        Expanded(child: ColumnText(title: rhead, value: rSubHead,alignment: CrossAxisAlignment.center,valueStyle: valueStyle,titleStyle: titleStyle,)),
        Expanded(child: ColumnText(title: chead,value: cSubHead,alignment: CrossAxisAlignment.end)),
      ],
    );
  }

  Container blackCard() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             if(selectedType != "Rejection") ColumnText(
                title: "Grand Total",
                value:
                    "$rupee ${Utils.formatNumber(grandTotal.round(), isAmount: false)}",
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.lineColor),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title: "Transactions",
                value: "$count",
                alignment: (selectedType == "Rejection") ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.lineColor),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
  final ScrollController _scrollController = ScrollController();

  Widget topArea() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollToItem(selectedTypeFinal);
    });

    return Container(
      color: Config.appTheme.themeColor,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: typeList.length,
              itemBuilder: (context, index) {
                String type = typeList[index];
                String? selectedTypeFinal;

                if (selectedType == "All Inflow") {
                  selectedTypeFinal = "Inflow";
                } else if (selectedType == "All Outflow") {
                  selectedTypeFinal = "Outflow";
                } else {
                  selectedTypeFinal = selectedType;
                }
                //print("type = $selectedTypeFinal");

                return GestureDetector(
                  onTap: () async {
                    if (selectedTypeFinal == type) {
                      print("api called");
                      grandTotal = 0;
                      await getInitialReport();
                      setState(() {});
                    }
                  },
                  child: selectedType == type
                      ? getButton(text: type, type: ButtonType.filled)
                      : getButton(text: type, type: ButtonType.plain),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(width: 16),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  showCustomizedSummaryBottomSheet();
                },
                child: appBarColumn(
                    "Start Date",
                    "${formatDate(selectedStartDate!)}",
                    Icon(Icons.keyboard_arrow_down,
                        color: Config.appTheme.themeColor)),
              ),
              GestureDetector(
                onTap: () {
                  showCustomizedSummaryBottomSheet();
                },
                child: appBarColumn(
                    "End Date",
                    "${formatDate(selectedEndDate!)}",
                    Icon(Icons.keyboard_arrow_down,
                        color: Config.appTheme.themeColor)),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  void _scrollToItem(String selectedItem) {
    final index = typeList.indexOf(selectedItem);
    print("index of item $index");
    if (index != -1) {
      final scrollControllerOffset = _scrollController.position.maxScrollExtent / typeList.length;
      final targetPos = index * scrollControllerOffset;

      _scrollController.animateTo(
        targetPos,
        duration: Duration(milliseconds: 100),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  Map xirrMap = {'cagr': "XIRR", 'absolute_return': "Abs Return"};
  String xirrType = "cagr";

  Widget getButton({required String text, required ButtonType type}) {
    EdgeInsets padding = EdgeInsets.symmetric(horizontal: 16);
    if (type == ButtonType.plain) {
      return PlainRButton(
        text: text,
        padding: padding,
        onPressed: () async {
          selectedType = text;
          if (selectedType == "All Inflow") {
            selectedTypeFinal = "Inflow";
          } else if (selectedType == "All Outflow") {
            selectedTypeFinal = "Outflow";
          } else {
            selectedTypeFinal = selectedType;
          }
          print("type getbutton");
          grandTotal = 0;
          await getInitialReport();
          Map data = {};
          if(selectedTypeFinal == "Rejection"){
            data = await AdminApi.getTransactionRejectionReport(
                user_id: userId,
                client_name: clientName,
                start_date: formatDate(selectedStartDate!),
                end_date: formatDate(selectedEndDate!),
                purchase_type: 'Rejection',
                page_id: page_id
            );
          } else{
              data = await AdminApi.getTransactionReport(
              user_id: userId,
              client_name: clientName,
              start_date: formatDate(selectedStartDate!),
              end_date: formatDate(selectedEndDate!),
              branch: selectedBranch == "All" ? "" : selectedBranch,
              rm_name: selectedRm == "All" ? "" : selectedRm,
              subbroker_name: selectedSubBroker == "All" ? "" : selectedSubBroker,
              purchase_type: selectedTypeFinal,
              registrar: selectedRta,
              investor_id: investorId,
              amc_name: selectedAmcName == "All AMC" ? "" : selectedAmcName,
              page_id: page_id,
              sortDirection: '',
              sort_by: '',
              search: '',
            );
          }
          if (data['status'] != 200) {
            Utils.showError(context, data['msg']);
            return -1;
          }
          selectedSort = "";
          setState(() {});
        },
      );
    } else {
      return RpFilledRButton(text: text, padding: padding);
    }
  }

  bool showDetails = false;

  Widget summaryRow({
    required String initial,
    required Color bgColor,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          InitialCard(title: initial, bgColor: bgColor),
          SizedBox(width: 10),
          whiteText(title),
          Spacer(),
          whiteText("$rupee $value")
        ],
      ),
    );
  }

  Widget whiteText(String text) {
    return Text(
      text,
      style: AppFonts.f50014Black.copyWith(color: Colors.white),
    );
  }

  ExpansionTileController rtaController = ExpansionTileController();
  Widget rtaExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: rtaController,
          onExpansionChanged: (val) {},
          title: Text("RTA", style: AppFonts.f50014Black),
          tilePadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${getKeyByValue(rtaMap, selectedRta)}",
                  style: AppFonts.f50012),
              DottedLine(),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: rtaMap.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    selectedRta = rtaMap.values.elementAt(index);
                    print("selectedRta $selectedRta");
                    bottomState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: rtaMap.values.elementAt(index),
                        groupValue: selectedRta,
                        onChanged: (value) {
                          selectedRta = rtaMap.values.elementAt(index);
                          print("selectedRta $selectedRta");
                          bottomState(() {});
                        },
                      ),
                      Text(
                        "${rtaMap.keys.elementAt(index)}",
                        style: AppFonts.f50012,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ExpansionTileController amcController = ExpansionTileController();
  Widget amcExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: amcController,
          onExpansionChanged: (val) {},
          title: Text("AMC", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedAmcName, style: AppFonts.f50012),
            ],
          ),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12, 4, 12, 10),
              child: SizedBox(
                height: 40,
                child: TextFormField(
                  initialValue: amcSearch,
                  onChanged: (val) {
                    setState(() {
                      amcSearch = val;
                    });
                    bottomState(() {});
                  },
                  decoration: InputDecoration(
                      // suffixIcon: Icon(Icons.close,
                      //     color: Config.appTheme.themeColor),
                      contentPadding: EdgeInsets.fromLTRB(10, 2, 12, 2),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ),
            SizedBox(
              height: 400,
              child: ListView.builder(
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: amcList.length,
                itemBuilder: (context, index) {
                  Map data = amcList[index];
                  String name = data['amc_name'];
                  String code = data['amc_code'];
                  String img = data['amc_logo'] ?? "";

                  return Visibility(
                    visible: searchVisibility(name, amcSearch),
                    child: InkWell(
                      onTap: () {
                        selectedAmcName = name;
                        selectedAmcCode = code;
                        bottomState(() {});
                        amcController.collapse();
                      },
                      child: Row(
                        children: [
                          Radio(
                              value: code,
                              groupValue: selectedAmcCode,
                              onChanged: (val) {
                                selectedAmcName = name;
                                selectedAmcCode = code;
                                bottomState(() {});
                                amcController.collapse();
                              }),
                          /*index == 0
                              ? Container(height: 32)
                              : Image.network(img, height: 32),*/
                          SizedBox(width: 10),
                          Expanded(
                              child: Text(name, style: AppFonts.f50014Grey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  searchVisibility(String title, String searchKey) {
    title = title.toLowerCase();
    searchKey = searchKey.toLowerCase();

    if (searchKey.isEmpty)
      return true;
    else {
      return title.contains(searchKey);
    }
  }

  Widget summaryRowBlack({
    required String initial,
    required Color bgColor,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          InitialCard(title: initial, bgColor: bgColor),
          SizedBox(width: 10),
          blackText(title),
          Spacer(),
          blackText("$rupee $value")
        ],
      ),
    );
  }

  Widget blackText(String text) {
    return Text(
      text,
      style: AppFonts.f50014Black.copyWith(color: Colors.black),
    );
  }
}

class PlainRButton extends StatelessWidget {
  const PlainRButton(
      {super.key, required this.text, this.onPressed, this.padding});
  final String text;
  final Function()? onPressed;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.sizeOf(context).width;

    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: padding ??
            EdgeInsets.symmetric(horizontal: devWidth * 0.15, vertical: 2),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppFonts.f50014Black.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class RpFilledRButton extends StatelessWidget {
  const RpFilledRButton(
      {super.key, this.onPressed, required this.text, this.padding});

  final Function()? onPressed;
  final EdgeInsets? padding;
  final String text;
  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.sizeOf(context).width;

    return InkWell(
      onTap: onPressed,
      child: Container(
          padding: padding ??
              EdgeInsets.symmetric(horizontal: devWidth * 0.15, vertical: 2),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppFonts.f50014Black
                .copyWith(color: Config.appTheme.themeColor),
          ))),
    );
  }
}
