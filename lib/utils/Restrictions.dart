import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/utils/Constants.dart';

class Restrictions {
  static bool get isBranchApiAllowed {
    int type_id = GetStorage().read("type_id");
    List allowedList = [
      UserType.ADMIN,
    ];
    return allowedList.contains(type_id);
  }

  static bool get isRmApiAllowed {
    int type_id = GetStorage().read("type_id");
    List allowedList = [
      UserType.ADMIN,
      UserType.BRANCH,
    ];
    return allowedList.contains(type_id);
  }

  static bool get isAssociateApiAllowed {
    int type_id = GetStorage().read("type_id");
    List allowedList = [
      UserType.ADMIN,
      UserType.BRANCH,
      UserType.RM,
    ];
    return allowedList.contains(type_id);
  }
}
