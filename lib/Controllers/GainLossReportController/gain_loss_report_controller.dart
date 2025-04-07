import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/pojo/gain_loss_report_response.dart';

import '../../api/ReportApi.dart';
import '../../utils/Utils.dart';
import 'gain_loss_report_state.dart';

class GainLossController extends GetxController {
  final _state = Rx<GainLossState>(GainLossInitialState());

  GainLossState get state => _state.value;

  String clientName = GetStorage().read("client_name");
  int userId = GetStorage().read("user_id");

  String selectedFy = '';

  DateTime? startDate;

  DateTime? endDate;

  Future<GainLossReportResponse> getGainLossResponse() async {
    final res = await ReportApi.getMfGainLossReport(
      user_id: userId,
      client_name: clientName,
      financial_year: selectedFy == "date-range" ? "" : selectedFy,
      option: (selectedFy == "date-range") ? "range" : "fy",
      start_date: startDate != null ? formatDate(startDate!) : '',
      end_date: endDate != null ? formatDate(endDate!) : '',
    );
    return res;
  }

  Future<void> fetchGainLossData() async {
    final castState = _state.value;
    try {
      switch (_state.value) {
        case GainLossLoadedState(
            selectedFinancialYear: final selectedFinancialYr,
            startDate: final selectedStartDate,
            endDate: final selectedEndDate,
          ):
          selectedFy = selectedFinancialYr ?? '';
          startDate = selectedStartDate ?? DateTime.now();
          endDate = selectedEndDate ?? DateTime.now();
        case GainLossInitialState():
        case GainLossLoadingState():
        case GainLossErrorState():
      }
      if (castState case GainLossLoadedState()) {
        _state.value = GainLossLoadingState();
        final res = await getGainLossResponse();
        _state.value = castState.copyWith(
          result: res.result,
        );
        return;
      }
      _state.value = GainLossLoadingState();
      final res = await getGainLossResponse();
      _state.value =
          GainLossLoadedState(result: res.result ?? GainLossDetails());
    } catch (e) {
      print('Error fetching GainLoss data: $e');
      _state.value = GainLossErrorState(errorMessage: e.toString());
    }
  }

  Future<void> getFinancialYears() async {
    try {
      final castState = _state.value;
      if (castState case GainLossLoadedState()) {
        final res = await ReportApi.getGainLossFinancialYears(
            user_id: userId, client_name: clientName);
        _state.value = castState.copyWith(
          financialYears: res.list ?? [],
        );
      }
    } catch (e) {
      print('Error fetching financial years');
    }
  }

  void selectFinancialYear(String fy) {
    final castState = _state.value;
    if (castState case GainLossLoadedState()) {
      _state.value = castState.copyWith(
        selectedFinancialYear: fy,
      );
    }
  }

  void resetFilterData() async {
    _state.value = GainLossLoadingState();
    final res = await getGainLossResponse();
    _state.value = GainLossLoadedState(result: res.result ?? GainLossDetails());
  }

  void selectStartDate(DateTime startDate) {
    final castState = _state.value;
    if (castState case GainLossLoadedState()) {
      _state.value = castState.copyWith(
        startDate: startDate,
      );
    }
  }

  void selectEndDate(DateTime endDate) {
    final castState = _state.value;
    if (castState case GainLossLoadedState()) {
      _state.value = castState.copyWith(
        endDate: endDate,
      );
    }
  }

  void selectDebt() {
    final castState = _state.value;
    if (castState case GainLossLoadedState()) {
      _state.value = castState.copyWith(
        isDebtSelected: true,
      );
    }
  }

  void unselectDebt() {
    final castState = _state.value;
    if (castState case GainLossLoadedState()) {
      _state.value = castState.copyWith(
        isDebtSelected: false,
      );
    }
  }

  Future<void> downloadOrSendPdf(ActionType actionType) async {
    final castState = _state.value;
    if (castState case GainLossLoadedState()) {
      _state.value = castState.copyWith(
        isDownloadingPdf: true,
      );
      final res = await ReportApi.downloadGainLossReportPDF(
          user_id: userId,
          client_name: clientName,
          type: switch (actionType) {
            ActionType.download => 'download',
            ActionType.email => 'Email',
          },
          startDate: startDate != null ? formatDate(startDate!) : '',
          endDate: endDate != null ? formatDate(endDate!) : '',
          financial_year: selectedFy == "date-range" ? "" : selectedFy,
          option: (selectedFy == "date-range") ? "range" : "fy");

      if (res['status'] != 200) {
        print('Error downloading data');
        return;
      }
      Get.back();

      switch (actionType) {
        case ActionType.download:
          rpDownloadFile(url: res['msg'], index: 0);
        case ActionType.email:
          print('Email Sent successfully');
      }

      _state.value = castState.copyWith(
        isDownloadingPdf: false,
      );
    }
  }

  formatDate(DateTime dt) {
    return DateFormat("dd-MM-yyyy").format(dt);
  }
}

enum ActionType {
  download,
  email,
}
