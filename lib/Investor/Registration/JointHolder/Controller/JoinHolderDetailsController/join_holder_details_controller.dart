import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/onBoarding/CommonOnBoardApi.dart';

import '../JoinHolderDataController/join_holder_data_controller.dart';
import 'join_holder_detail_state.dart';

final JointHolderDetailsController jointHolderDetailsController =
    Get.put(JointHolderDetailsController());

class JointHolderDetailsController extends GetxController {
  final _state = Rx<JointHolderDetailsState>(JointHolderDetailsLoadingState());

  JointHolderDetailsState get state => _state.value;

  String clientName = GetStorage().read("client_name");
  int userId = GetStorage().read("user_id");

  Future<void> getJoinHolderData() async {
    _state.value = JointHolderDetailsLoadingState();
    final res = await CommonOnBoardApi.getJointHolderDetails(
      user_id: userId,
      client_name: clientName,
    );
    if (res.status != 200) {
      _state.value = JointHolderDetailsErrorState(
          errorMessage: 'Error fetching joint holder details');
      return;
    }
    _state.value = JointHolderDetailsLoadedState(
      joinHolderList: res.list ?? [],
    );
    joinHolderDataController.initiateData(res.joinHolders);
  }
}
