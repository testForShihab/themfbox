import 'package:mymfbox2_0/pojo/CartPojo.dart';

class SuccessPojo {
  String? bank;
  String? paymentMode;
  String? paymentStatus;
  String? arn;
  String? euin;
  List<CartPojo>? cart;

  SuccessPojo(
      {this.bank,
      this.paymentMode,
      this.paymentStatus,
      this.arn,
      this.euin,
      this.cart});

  SuccessPojo.fromJson(Map<String, dynamic> json) {
    bank = json['bank'];
    paymentMode = json['payment_mode'];
    paymentStatus = json['payment_status'];
    arn = json['arn'];
    euin = json['euin'];
    cart = json['cart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['bank'] = bank;
    data['payment_mode'] = paymentMode;
    data['payment_status'] = paymentStatus;
    data['arn'] = arn;
    data['euin'] = euin;
    data['cart'] = cart;

    return data;
  }
}
