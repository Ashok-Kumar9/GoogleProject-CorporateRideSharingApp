import 'package:corporate_ride_sharing/utils/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../webView/web_view.dart';

class UrlLauncher {
  static Future openURL({
    required String url,
  }) =>
      _launchURL(url);

  static Future _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
    await launch(url);
  }

  static Future openMessage(
      {required String phoneNumber, required String message}) async {
    final url = 'sms:$phoneNumber?body=${Uri.encodeFull(message)}';
    await _launchURL(url);
  }
}

class AppInfo extends StatefulWidget {
  const AppInfo({Key? key}) : super(key: key);

  @override
  State<AppInfo> createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  String version = "1.0.9";

  GestureDetector option(icon, String name, ontap()) {
    return GestureDetector(
      onTap: ontap,
      child: ListTile(
        visualDensity: VisualDensity.comfortable,
        horizontalTitleGap: 3,
        leading: Icon(
          icon,
          size: 30,
          color: Colors.indigo,
        ),
        title: Text(
          name,
          style: const TextStyle(
            color: Color(0xffEEEEEE),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorShades.backGroundBlack,
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text('App Info', style: Theme.of(context).textTheme.h3),
        ),
        backgroundColor: const Color.fromRGBO(33, 33, 33, 1),
        body: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                child: Column(
                  children: <Widget>[
                    Text('Version $version',
                        style: Theme.of(context).textTheme.h4),
                    const SizedBox(height: 16.0),
                    Container(
                      height: screenHeight * 0.2,
                      width: screenHeight * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent,
                        image: const DecorationImage(
                          image: AssetImage('assets/images/splash.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36.0),
                    Text('\u00a9 2022-2023\nRideWithMe Pvt. Ltd.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.h5.copyWith(
                            color: const Color.fromRGBO(158, 158, 158, 1))),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 35, 20, 0),
                  color: const Color(0xff1B1B1B),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        option(
                          Icons.group_rounded,
                          'Team ',
                          () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ShowWebView(
                                    url: "https://careers.google.com/teams/")));
                          },
                        ),
                        option(
                          Icons.receipt_long,
                          'Licenses ',
                          () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ShowWebView(
                                    url:
                                        "https://en.wikipedia.org/wiki/Privacy")));
                          },
                        ),
                        option(Icons.security_rounded, 'Privacy Policy ', () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ShowWebView(
                                  url: "https://policies.google.com/")));
                        }),
                        option(
                          Icons.handyman_rounded,
                          'Terms And Conditions',
                          () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ShowWebView(
                                    url:
                                        "https://policies.google.com/terms?hl=en")));
                          },
                        ),
                        option(
                          Icons.info_rounded,
                          'Return And Refund Policy',
                          () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ShowWebView(
                                    url:
                                        "https://support.google.com/googleplay/workflow/9813244?hl=en")));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
