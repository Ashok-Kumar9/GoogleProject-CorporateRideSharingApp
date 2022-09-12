import 'dart:io';

import 'package:corporate_ride_sharing/utils/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../components/reusable_widgets.dart';

class ShowWebView extends StatefulWidget {
  const ShowWebView({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  _ShowWebViewState createState() => _ShowWebViewState();
}

class _ShowWebViewState extends State<ShowWebView> {
  final ValueNotifier<double> progressNotifier = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff1b1b1b),
        appBar: AppBar(
          backgroundColor: const Color(0xff1b1b1b),
          // elevation: 0,
          title: Text(widget.url, style: Theme.of(context).textTheme.h5),
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          actions: [
            ReusableWidgets().circularIconAppBarButton(
              iconData: Icons.copy_rounded,
              backGroundColor: ColorShades.backGroundGrey,
              onTap: () => Clipboard.setData(ClipboardData(text: widget.url))
                  .then((value) {
                ReusableWidgets().showToast("Copied");
              }),
            ),
            ReusableWidgets().circularIconAppBarButton(
              iconData: Icons.share_rounded,
              backGroundColor: ColorShades.backGroundGrey,
              onTap: () => Share.share(widget.url),
            ),
          ],
        ),
        body: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: progressNotifier,
              builder: (BuildContext context, double value, child) {
                return value < 1
                    ? LinearProgressIndicator(
                        backgroundColor: Colors.grey,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.indigo),
                        value: value,
                      )
                    : Container();
              },
            ),
            Expanded(
              child: WebView(
                  initialUrl: widget.url,
                  javascriptMode: JavascriptMode.unrestricted,
                  backgroundColor: const Color(0xff1b1b1b),
                  onProgress: (int progress) {
                    progressNotifier.value = progress / 100;
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
