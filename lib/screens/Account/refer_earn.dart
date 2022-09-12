import 'package:corporate_ride_sharing/utils/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

import '../../components/custom_button.dart';
import '../../components/reusable_widgets.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({Key? key}) : super(key: key);

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  final TextEditingController _referralCodeController = TextEditingController();

  bool haveReferralCode = false;
  String referralCode = "A9Y87F2M";
  bool isQueryFinished = false;
  var referAmount = 49;
  var referPercentage = 15;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(33, 33, 33, 1),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(33, 33, 33, 1),
          title: Text(
            'Refer Us',
            style: Theme.of(context).textTheme.h3,
          ),
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    haveReferralCode
                        ? Column(
                            children: [
                              SizedBox(height: screenHeight * 0.03),
                              Text(
                                "Have a referral code?",
                                style: Theme.of(context).textTheme.h2,
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                margin: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.1),
                                decoration:
                                    BoxDecorations().detailPageBoxDecoration,
                                child: Center(
                                  child: TextField(
                                    autofocus: true,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    controller: _referralCodeController,
                                    cursorColor: Colors.white,
                                    style: Theme.of(context).textTheme.h3,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            ReusableWidgets().showToast(
                                                "Please enter a valid code!");
                                          },
                                          child: const Icon(
                                            Icons.send,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .h3
                                            .copyWith(color: Colors.grey),
                                        hintText: 'GJHTYFRGDT',
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(height: screenHeight * 0.03),
                              Text(
                                "Have a referral code?",
                                style: Theme.of(context).textTheme.h3,
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              CustomButton(
                                border: 3.0,
                                isActive: true,
                                onPressed: () {
                                  setState(() {
                                    haveReferralCode = true;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.1),
                                  child: Text(
                                    "Redeem",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.h3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    SizedBox(height: screenHeight * 0.03),
                    Neumorphic(
                      margin: const EdgeInsets.symmetric(horizontal: 12.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 24.0),
                      style: const NeumorphicStyle(
                        intensity: 0,
                        color: Color(0xff1B1B1B),
                        depth: 0,
                      ),
                      child: Column(
                        children: [
                          Lottie.asset(
                            "assets/animations/refer_earn.json",
                            repeat: false,
                            frameRate: FrameRate.max,
                          ),
                          Text(
                            "On successful referral, you will get a reward of ₹$referAmount and your friend will get $referPercentage % off on their first ride.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.h5,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      "Share your code",
                      style: Theme.of(context).textTheme.h3,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "Members have won 1 Lakh+ in cashback",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.h5,
                    ),
                    const SizedBox(height: 24.0),
                    GestureDetector(
                      onTap: () =>
                          Clipboard.setData(ClipboardData(text: referralCode))
                              .then((value) {
                        ReusableWidgets().showToast("Copied");
                      }),
                      child: Neumorphic(
                        margin: const EdgeInsets.symmetric(horizontal: 12.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 16.0),
                        style: NeumorphicStyle(
                            intensity: 0,
                            color: const Color(0xff1B1B1B),
                            depth: 0,
                            boxShape: NeumorphicBoxShape.beveled(
                                const BorderRadius.all(Radius.circular(8.0)))),
                        child: Row(
                          children: [
                            Text(
                              "Referral Code",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.h4,
                            ),
                            Expanded(
                              child: Text(
                                referralCode,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.h4,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            const Icon(Icons.copy_rounded)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 36.0),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (!kIsWeb)
              CustomButton(
                  border: 6.0,
                  isActive: true,
                  onPressed: () {
                    Share.share(
                        "Hey, use my referral code $referralCode to get 10% off on your first ride on the app. Download the app now: https://play.google.com/store/apps/details?id=com.google.android.apps.maps");
                  },
                  child: Center(
                    child: Text(
                      "SHARE NOW",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.h2,
                    ),
                  )),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
