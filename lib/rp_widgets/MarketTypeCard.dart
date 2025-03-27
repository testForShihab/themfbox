import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';

class MarketTypeCard extends StatelessWidget {
  const MarketTypeCard({
    super.key,
    required this.client_code_map,
  });

  final Map client_code_map;

  @override
  Widget build(BuildContext context) {
    String logo = client_code_map['logo'];
    String holdingNature = client_code_map['holding_nature'];
    String arn = client_code_map['broker_code'];
    String marketType = client_code_map['bse_nse_mfu_flag'] ?? "null";
    String investorCode = client_code_map['investor_code'];
    String taxStatus = client_code_map['tax_status'];
    String inv_name = client_code_map['inv_name'];

    return ListTile(
      leading: Image.network(logo, height: 32),
      title: Text(inv_name),
      tileColor: Colors.white,
      titleTextStyle: AppFonts.f50014Black,
      subtitleTextStyle: AppFonts.f50012,
      subtitle: Text("$investorCode-$holdingNature-$taxStatus-$arn"),
    );
  }
}
