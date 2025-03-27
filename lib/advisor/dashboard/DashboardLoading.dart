import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class DashboardLoading extends StatelessWidget {
  const DashboardLoading({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    double devHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Config.appTheme.mainBgColor,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Config.appTheme.mainBgColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: Column(
            children: [
              SizedBox(height: devHeight * 0.018),
              child,
              SizedBox(height: devHeight * 0.01),
              Utils.shimmerWidget(devHeight * 0.17),
              SizedBox(height: devHeight * 0.02),
              Utils.shimmerWidget(100),
              SizedBox(height: devHeight * 0.02),
              Utils.shimmerWidget(devHeight * 0.30),
              SizedBox(height: devHeight * 0.02),
              Utils.shimmerWidget(100),
              SizedBox(height: devHeight * 0.02),
              Utils.shimmerWidget(100),
              SizedBox(height: devHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
