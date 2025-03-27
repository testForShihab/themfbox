import 'package:get/get.dart';
import 'package:mymfbox2_0/pojo/JointHolderPojo.dart';

import 'join_holder_date_state.dart';

final JoinHolderDataController joinHolderDataController =
    Get.put(JoinHolderDataController());

class JoinHolderDataController extends GetxController {
  final _state =
      Rx<JoinHoldersDataState>(JoinHoldersDataState(jointHolderList: []));

  JoinHoldersDataState get state => _state.value;

  void initiateData(List<JointHolderPojo> models) {
    _state.value = JoinHoldersDataState(jointHolderList: models);
  }

  void addJoinHolder(List<JointHolderPojo> models) {
    final currentHoldersList =
        List<JointHolderPojo>.from(_state.value.jointHolderList);
    currentHoldersList.addAll(models);
    _state.value = JoinHoldersDataState(jointHolderList: currentHoldersList);
  }

  void updateDetails(JointHolderPojo model) {
    final currentList =
        List<JointHolderPojo>.from(_state.value.jointHolderList);
    currentList.removeWhere((e) => e.jointHolderId == model.jointHolderId);
    currentList.add(model);

    _state.value = JoinHoldersDataState(jointHolderList: currentList);
  }

  void removeModel(JointHolderPojo model) {
    final currentList =
        List<JointHolderPojo>.from(_state.value.jointHolderList);
    currentList.removeWhere((e) => e.jointHolderId == model.jointHolderId);

    _state.value = JoinHoldersDataState(jointHolderList: currentList);
    updateIds();
  }

  void updateIds() {
    final currentList =
        List<JointHolderPojo>.from(_state.value.jointHolderList);
    if (currentList.isEmpty) return;
    final tempList = <JointHolderPojo>[];
    for (var i = 0; i < currentList.length; i++) {
      final e = currentList[i];
      final tempModel = JointHolderPojo(
        jointHolderId: i + 1,
        jointHolderSourceWealth: e.jointHolderSourceWealth,
        jointHolderPolitical: e.jointHolderPolitical,
        jointHolderPlaceBirth: e.jointHolderPlaceBirth,
        jointHolderPan: e.jointHolderPan,
        jointHolderOccupation: e.jointHolderOccupation,
        jointHolderName: e.jointHolderName,
        jointHolderMobileRelation: e.jointHolderMobileRelation,
        jointHolderMobile: e.jointHolderMobile,
        jointHolderIncome: e.jointHolderIncome,
        jointHolderEmailRelation: e.jointHolderEmailRelation,
        jointHolderEmail: e.jointHolderEmail,
        jointHolderDob: e.jointHolderDob,
        jointHolderCountryBirth: e.jointHolderCountryBirth,
        jointHolderAddressType: e.jointHolderAddressType,
      );
      tempList.add(tempModel);
    }
    _state.value = JoinHoldersDataState(jointHolderList: tempList);
  }
}
