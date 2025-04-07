import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Registration/JointHolder/Controller/JoinHolderDetailsController/join_holder_details_controller.dart';
import 'package:mymfbox2_0/rp_widgets/Loading.dart';

import '../../../api/onBoarding/nse/NseOnBoardApi.dart';
import '../../../pojo/JointHolderPojo.dart';
import '../../../rp_widgets/CalculateButton.dart';
import '../../../rp_widgets/RpAppBar.dart';
import '../../../utils/AppFonts.dart';
import '../../../utils/Config.dart';
import '../../../utils/Utils.dart';
import 'Controller/JoinHolderDataController/join_holder_data_controller.dart';
import 'add_joint_holder_info_details_page.dart';

class JointHolderInfoPage extends StatefulWidget {
  const JointHolderInfoPage({super.key});

  @override
  State<JointHolderInfoPage> createState() => _JointHolderInfoPageState();
}

class _JointHolderInfoPageState extends State<JointHolderInfoPage> {
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  String bse_nse_mfu_flag = Get.arguments ?? " ";

  @override
  void initState() {
    super.initState();
    jointHolderDetailsController.getJoinHolderData();
  }

  Widget applicantCard({
    required String title,
    required String img,
    Widget trailing = const SizedBox(),
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            // Image.asset(img, height: 32),
            SizedBox(width: 10),
            Text("$title Applicant", style: AppFonts.f50014Black),
            Spacer(),
            trailing,
          ],
        ),
      ),
    );
  }

  showBtmSheet({
    required BuildContext context,
    required JointHolderPojo jointHolderPojo,
    required String title,
    bool isEdit = false,
    required int modelId,
  }) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (context) {
          return AspectRatio(
            aspectRatio: 2 / 3.5,
            child: AddJoinHolderInfoDetailPage(
              modelId: modelId,
              isEdit: isEdit,
              model: jointHolderPojo,
              title: title,
              userId: user_id,
              bseNseMfuFlag: bse_nse_mfu_flag,
              clientName: client_name,
            ),
          );
        });
  }

  Future saveJointHolderInfo(List<String> list) async {
    EasyLoading.show();
    Map data = await NseOnBoardApi.saveJointHolderInfo(
        user_id: user_id,
        client_name: client_name,
        investor_id: user_id,
        joint_holder_details: list,
        bse_nse_mfu_flag: bse_nse_mfu_flag);

    EasyLoading.dismiss();
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
        title: 'Joint Holder Info',
        bgColor: Config.appTheme.themeColor,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: Obx(() {
        final jointHoldersList = joinHolderDataController.state.jointHolderList;
        return CalculateButton(
            onPress: () async {
              EasyLoading.show();
              List<String> list = [];
              for (var e in jointHoldersList) {
                Map<String, dynamic> data = e.toJson();
                list.add(jsonEncode(data));
              }
              int res = await saveJointHolderInfo(list);
              EasyLoading.dismiss();
              if (res == 0) Get.back();
            },
            text: "CONTINUE");
      }),
      body: Obx(
        () {
          final state = joinHolderDataController.state;
          final list = state.jointHolderList;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(height: 20),
                if (list.isNotEmpty)
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (ctx, index) {
                        final img = "assets/applicant${index + 2}.png";
                        final pojo = list[index];
                        return applicantCard(
                          title: switch (index) {
                            0 => '1st',
                            1 => '2nd',
                            2 => '3rd',
                            _ => '',
                          },
                          img: img,
                          onTap: () {
                            showBtmSheet(
                              modelId: index + 1,
                              isEdit: true,
                              context: context,
                              jointHolderPojo: pojo,
                              title: switch (index) {
                                0 => '1st',
                                1 => '2nd',
                                2 => '3rd',
                                _ => '',
                              },
                            );
                          },
                          trailing: Row(
                            children: [
                              Text(
                                'Edit',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    joinHolderDataController.removeModel(pojo);
                                  },
                                  child: Text('Remove'))
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                if (list.length < 2)
                  applicantCard(
                    title: 'Add',
                    img: "assets/applicant1.png",
                    onTap: () {
                      showBtmSheet(
                        modelId: list.length + 1,
                        context: context,
                        jointHolderPojo: JointHolderPojo(),
                        title: 'Add',
                      );
                    },
                    trailing: Icon(Icons.add_circle),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
