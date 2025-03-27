import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';

class TransactController extends GetxController{
  var startDate = DateTime.now().add(Duration(days: 7)).obs;

  // Method to update start date and ensure end date is recalculated
  void setStartDateWithCallback(DateTime newDate, Function callback) {
    // Create a new DateTime instance to ensure reactivity
    DateTime updatedDate = DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
    );
    
    // Update the observable
    startDate(updatedDate);  // Using call syntax instead of .value
    
    // Call the callback (findSipEndDate) after the date is updated
    callback();
  }

  // Method to preserve start date during other operations
  Future preserveStartDate(Function callback) async {
    DateTime preserved = DateTime(
      startDate.value.year,
      startDate.value.month,
      startDate.value.day,
    );
    
    await callback();
    
    // Restore the preserved date using call syntax
    startDate(preserved);
  }

  Widget rpDatePicker(String title) {
    return Obx(() => Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppFonts.f50014Black),
          Text(
            startDate.value.toString().split(" ")[0],
            style: AppFonts.f50012,
          ),
        ],
      ),
    ));
  }
}
