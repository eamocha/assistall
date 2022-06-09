import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReusableWebview extends StatefulWidget {
  final String finalUrl;
  const ReusableWebview(this.finalUrl);

  @override
  _ReusableWebviewState createState() => _ReusableWebviewState(this.finalUrl);
}

class _ReusableWebviewState extends State<ReusableWebview> {
  final String finalUrl;
   _ReusableWebviewState(this.finalUrl);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        initialUrl: finalUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
