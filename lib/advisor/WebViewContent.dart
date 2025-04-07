

import 'package:flutter/material.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewContent extends StatefulWidget {
   WebviewContent({
    super.key,
    required this.webViewTitle,
    required this.disqusUrl,
    this.showIcon,
  });
  final String webViewTitle;
  final String disqusUrl;
  bool? showIcon = true;

  @override
  State<WebviewContent> createState() => _WebviewContentState();
}

class _WebviewContentState extends State<WebviewContent> {
  String title = "";
  String dicussUrl = "";
  WebViewController? controller;
  bool? showIcon;
  @override
  void initState() {
    //  implement initState
    super.initState();
    title = widget.webViewTitle;
    dicussUrl = widget.disqusUrl;
    showIcon = widget.showIcon;

    print("webview title $title");
    print("webview dicussUrl $dicussUrl");

    controller = WebViewController()
      ..loadRequest(Uri.parse(dicussUrl))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );
    setState(() {});
  }

  String getFirst18(String text) {
    String s = text.split(":").first;
    if (s.length > 18) s = '${s.substring(0, 18)}...';
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: rpAppBar(
          title: getFirst18(title),
          bgColor: Config.appTheme.themeColor,
          /*actions: [
           if(showIcon == true) IconButton(onPressed: () {}, icon: Icon(Icons.share)),
          ],*/
          foregroundColor: Colors.white),
      body: (controller == null)
          ? Text("loading..")
          : WebViewWidget(
              controller: controller!,
            ),
    );
  }
}
