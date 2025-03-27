import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';

class ApiTest extends StatefulWidget {
  const ApiTest({super.key});

  @override
  State<ApiTest> createState() => _ApiTestState();
}

class _ApiTestState extends State<ApiTest> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop)
          return;
        else
          showBackAlert();
      },
      child: Scaffold(
        appBar: invAppBar(),
        body: Center(
          child: Text("Hello"),
        ),
      ),
    );
  }

  showBackAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Are You Sure ?"),
          content: Text("Do you want to quit?"),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                child: Text("Yes")),
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("No")),
          ],
        );
      },
    );
  }
}
