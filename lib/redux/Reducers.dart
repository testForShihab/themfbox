import 'package:mymfbox2_0/redux/Actions.dart';
import 'package:mymfbox2_0/redux/AppState.dart';

AppState updateCart(AppState state, dynamic action) {
  if (action is UpdateCart) {
    state.cartCountPojo = action.cartCountPojo;
  }
  return state;
}
