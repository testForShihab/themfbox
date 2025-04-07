import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class Loading extends StatelessWidget {
  const Loading({super.key, this.appBar});
  final PreferredSizeWidget? appBar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Config.appTheme.mainBgColor,
      body: Column(
        children: [
          SizedBox(height: 16),
          Utils.shimmerWidget(100),
          SizedBox(height: 16),
          Utils.shimmerWidget(100),
          SizedBox(height: 16),
          Utils.shimmerWidget(100),
          SizedBox(height: 16),
          Utils.shimmerWidget(100),
        ],
      ),
    );
  }
}
