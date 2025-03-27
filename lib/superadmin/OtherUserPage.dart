import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/login/CheckUserType.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/SearchField.dart';
import 'package:mymfbox2_0/superadmin/SuperAdminDashboard.types.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class OtherUserPage extends StatefulWidget {
  const OtherUserPage(
      {super.key, required this.subBrokerList, required this.title});
  final List<AdminPojo> subBrokerList;
  final String title;
  @override
  State<OtherUserPage> createState() => _OtherUserPageState();
}

class _OtherUserPageState extends State<OtherUserPage> {
  List userList = [];

  @override
  void initState() {
    //  implement initState
    super.initState();
    userList = widget.subBrokerList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: adminAppBar(
          title: widget.title,
          hasAction: false,
          fgColor: Colors.white,
          arrowColor: Colors.white,
          bgColor: Config.appTheme.themeColor),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SearchField(
              hintText: "Search ${widget.title}",
              onChange: (val) {
                if (val.isEmpty) {
                  setState(() {
                    userList = widget.subBrokerList;
                  });
                  return;
                }
                setState(() {
                  userList = widget.subBrokerList
                      .where((element) => element.name!
                          .toLowerCase()
                          .contains(val.toLowerCase()))
                      .toList();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: userList.length,
              itemBuilder: (context, index) {
                AdminPojo user = userList[index];
                return Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    onTap: () async {
                      await GetStorage().write('type_id', user.typeId);
                      await GetStorage().write('client_name', user.clientName);
                      Config.app_client_name =
                          user.clientName ?? "null from api";

                      await GetStorage().write("mfd_id", user.userId);
                      await GetStorage().write("mfd_name", user.name);
                      await GetStorage().write("mfd_pan", user.pan);
                      await GetStorage().write("mfd_mobile", user.mobile);
                      await GetStorage().write("superAdminAsAdmin", true);

                      Get.offAll(() => CheckUserType());
                    },
                    title: Text("${user.name}"),
                    subtitle: Text("${user.mobile}"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
