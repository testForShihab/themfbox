import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Registration/RegistrationSuccessful/Model/nominee_auth_response.dart';

import '../../../../api/onBoarding/CommonOnBoardApi.dart';
import '../../../../utils/Utils.dart';
import 'authenticate_nominee_state.dart';

final AuthenticateNomineeController authenticateNomineeController =
    Get.put(AuthenticateNomineeController());

class AuthenticateNomineeController extends GetxController {
  final _state =
      Rx<AuthenticateNomineeState>(AuthenticateNomineeInitialState());

  String clientName = GetStorage().read("client_name");
  int userId = GetStorage().read("user_id");

  AuthenticateNomineeState get state => _state.value;

  Future<void> launchAuthenticateNomineeUrl() async {
    EasyLoading.show();
    _state.value = AuthenticateNomineeLoadingState();
    final res = await CommonOnBoardApi.getNomineeAuthenticationLink(
        user_id: userId, client_name: clientName, investor_code: '');
    if (res?.status != 200) {
      Utils.showError(null, 'Error authenticating nominee');
      _state.value = AuthenticateNomineeErrorState(
          errorMessage: 'Error authenticating nominee');
      return;
    }

    _state.value = AuthenticateNomineeLoadedState(
        authDetails: res?.result ?? AuthDetails());
    EasyLoading.dismiss();
  }
}
