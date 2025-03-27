import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  List list = [
    {
      "id": 248408,
      "amc_code": "B",
      "product_code": "152WD",
      "sys_type": "SIP",
      "frequency": "OM",
      "dates":
          "01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28",
      "active_flag": "Y",
      "created_date": "22-03-2024"
    },
    {
      "id": 249289,
      "amc_code": "B",
      "product_code": "152WD",
      "sys_type": "SIP",
      "frequency": "OW",
      "dates": "02,03,04,05,06",
      "active_flag": "Y",
      "created_date": "22-03-2024"
    }
  ];
  List frequencyList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () {}, child: Text("data")),
      ),
    );
  }

  generateFrequencyList() {
    if (frequencyList.isEmpty) {
      for (Map element in list) frequencyList.add(element);
    }
  }
}
