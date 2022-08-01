import 'package:corporate_ride_sharing/components/animation_dialog.dart';
import 'package:corporate_ride_sharing/components/custom_button.dart';
import 'package:corporate_ride_sharing/components/reusable_widgets.dart';
import 'package:corporate_ride_sharing/screens/home/home_screen.dart';
import 'package:corporate_ride_sharing/utils/sharedPrefs/shared_prefs.dart';
import 'package:corporate_ride_sharing/utils/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/index.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);
  final String phoneNumber;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  final TextEditingController _otpController = TextEditingController();
  final otpFocusNode = FocusNode();
  FirebaseAuth auth = FirebaseAuth.instance;
  late CountdownTimerController controller;
  late TapGestureRecognizer onTapRecognizer;
  User? user;
  String verificationID = "";
  bool startShowingTimer = false;

  @override
  void initState() {
    super.initState();
    loginWithPhone();
    _otpController.addListener(() => setState(() {}));
    _animationController = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false);
        }
      });

    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        loginWithPhone();
        controller = CountdownTimerController(
            endTime: DateTime.now().millisecondsSinceEpoch + 30000);

        ReusableWidgets().showSnackBar(context, "OTP is sent again");
        setState(() {});
      };
  }

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
      phoneNumber: "+91${widget.phoneNumber}",
      verificationCompleted: (PhoneAuthCredential credential) =>
          verifyOTP(credential),
      verificationFailed: (FirebaseAuthException e) =>
          ReusableWidgets().showSnackBar(context, e.message.toString()),
      codeSent: (String verificationId, int? resendToken) {
        verificationID = verificationId;
        setState(() {
          controller = CountdownTimerController(
              endTime: DateTime.now().millisecondsSinceEpoch + 30000);
          startShowingTimer = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationID = verificationId;
      },
    );
  }

  void verifyOTP(PhoneAuthCredential credential) async {
    try {
      await auth.signInWithCredential(credential).then(
        (value) {
          if (value.user != null) {
            SharedPrefs().isLoggedIn = true;
            otpFocusNode.unfocus();
            animationDialog(context, animationController: _animationController);
          }
        },
      );
    } catch (e) {
      ReusableWidgets().showToast("Seems like you entered wrong OTP");
    }
  }

  RichText resendOtpTextWidget() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "Didn't received the OTP? ",
        style: Theme.of(context).textTheme.h6,
        children: [
          TextSpan(
            text: "Re-send",
            recognizer: onTapRecognizer,
            style: Theme.of(context)
                .textTheme
                .h5
                .copyWith(color: ColorShades.neon),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _otpController.dispose();
    otpFocusNode.dispose();
    onTapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorShades.backGroundBlack,
          body: Container(
              height: screenHeight - MediaQuery.of(context).padding.top,
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.04,
                horizontal: screenWidth * 0.08,
              ).copyWith(top: screenHeight * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "We have sent you the OTP",
                    style: Theme.of(context).textTheme.h2,
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Text(
                    "Enter the 6 digit otp sent on ${widget.phoneNumber} to proceed",
                    style: Theme.of(context)
                        .textTheme
                        .h5
                        .copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  SizedBox(
                    width: double.maxFinite,
                    child: TextField(
                      controller: _otpController,
                      focusNode: otpFocusNode,
                      autofocus: true,
                      maxLength: 6,
                      cursorColor: Colors.white,
                      style: Theme.of(context).textTheme.h2,
                      keyboardType: TextInputType.number,
                      onChanged: (value) async {
                        if (value.length >= 6) {
                          otpFocusNode.unfocus();
                        }
                      },
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: InputDecoration(
                          counterText: '',
                          hintStyle: Theme.of(context).textTheme.h2.copyWith(
                              color: const Color.fromRGBO(97, 97, 97, 1)),
                          hintText: 'OTP',
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  if (startShowingTimer)
                    Center(
                      child: CountdownTimer(
                          controller: controller,
                          widgetBuilder: (BuildContext context,
                              CurrentRemainingTime? remainingDuration) {
                            if (remainingDuration == null) {
                              return resendOtpTextWidget();
                            }
                            return CircleAvatar(
                              backgroundColor: ColorShades.neon,
                              child: Text(
                                '${remainingDuration.sec}',
                                style: Theme.of(context)
                                    .textTheme
                                    .h5
                                    .copyWith(color: ColorShades.white),
                              ),
                            );
                          }),
                    ),
                  const Spacer(),
                  CustomButton(
                    isActive:
                        _otpController.text.length == 6 && startShowingTimer,
                    onPressed: () => verifyOTP(PhoneAuthProvider.credential(
                        verificationId: verificationID,
                        smsCode: _otpController.text)),
                    child: Center(
                      child: Text(
                        "Continue",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.h3,
                        // textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }
}
