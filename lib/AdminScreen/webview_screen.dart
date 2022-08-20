// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:usdt_beta/style/color.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class WebViewExample extends StatefulWidget {
//   final String link;
//   WebViewExample(this.link);
//   @override
//   WebViewExampleState createState() => WebViewExampleState();
// }
//
// class WebViewExampleState extends State<WebViewExample> {
//   @override
//   void initState() {
//     super.initState();
//     // Enable virtual display.
//     if (Platform.isAndroid) WebView.platform = AndroidWebView();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     log(widget.link);
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Center(
//           child: WebView(
//             backgroundColor: bgColor,
//             initialUrl: widget.link,
//             zoomEnabled: true,
//           ),
//         ),
//       ),
//     );
//   }
// }