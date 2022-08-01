// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:pashusansaar/user_details/user_details_update_screen.dart';
// import 'package:pashusansaar/utils/colors.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'user_details/user_details_fetch_screen.dart';
// import 'package:get/get.dart';
// import 'package:flutter_countdown_timer/index.dart';
//
// class OTPScreen extends StatefulWidget {
//   final String phoneNumber;
//
//   OTPScreen(this.phoneNumber);
//
//   @override
//   _OTPScreenState createState() => _OTPScreenState();
// }
//
// class _OTPScreenState extends State<OTPScreen>
//     with SingleTickerProviderStateMixin {
//   var onTapRecognizer;
//
//   TextEditingController textEditingController = TextEditingController();
//   String _verificationCode;
//   int _resendToken;
//
//   StreamController<ErrorAnimationType> errorController;
//
//   bool hasError = false, _startTimer = false;
//   String currentText = "";
//   final GlobalKey<ScaffoldState> scaffoldKey =
//   GlobalKey<ScaffoldState>(debugLabel: 'otpScaffoldKey');
//   final formKey = GlobalKey<FormState>(debugLabel: 'otpFormStateKey');
//   int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
//   CountdownTimerController countdownTimerController;
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _verifyPhone();
//       countdownTimerController =
//           CountdownTimerController(endTime: endTime, onEnd: onEnd);
//       setState(() {
//         _startTimer = true;
//       });
//       return ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('OTP भेजा गया है')));
//     });
//
//     onTapRecognizer = TapGestureRecognizer()
//       ..onTap = () {
//         _verifyPhone();
//         countdownTimerController = CountdownTimerController(
//             endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 60,
//             onEnd: onEnd);
//
//         setState(() {
//           _startTimer = true;
//         });
//
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text('OTP पुनः भेजा गया है')));
//
//         // Navigator.pop(context);
//       };
//     errorController = StreamController<ErrorAnimationType>();
//     checkUserLoginState();
//     super.initState();
//   }
//
//   void onEnd() {
//     print('onEnd');
//   }
//
//   checkUserLoginState() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       prefs.setString('mobileNumber', widget.phoneNumber);
//     });
//   }
//
//   textWidget() => RichText(
//     textAlign: TextAlign.center,
//     text: TextSpan(
//         text: "did_not_receive_code".tr,
//         style: TextStyle(color: Colors.black54, fontSize: 15),
//         children: [
//           TextSpan(
//               text: "resend_button".tr,
//               // recognizer: TapGestureRecognizer()..onTap(),
//               recognizer: onTapRecognizer,
//               style: TextStyle(
//                   color: primaryColor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16)),
//           // WidgetSpan(
//           //     child: _startTimer ? Text('Hello') : Text('.'))
//         ]),
//   );
//
//   @override
//   void dispose() {
//     errorController.close();
//     super.dispose();
//   }
//
//   _verifyPhone() async {
//     await FirebaseAuth.instance
//         .verifyPhoneNumber(
//         phoneNumber: '+91${widget.phoneNumber}',
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await FirebaseAuth.instance
//               .signInWithCredential(credential)
//               .then((value) async {
//             if (value.user != null) {
//               Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => UserDetailsFetch(
//                           currentUser: value.user.uid,
//                           mobile: widget.phoneNumber)));
//             }
//           });
//         },
//         verificationFailed: (FirebaseAuthException e) async {
//           print('verificationFailed==>' + e.toString());
//           FirebaseFirestore.instance
//               .collection('logger')
//               .doc(widget.phoneNumber)
//               .collection('OTP-VerificationFailed')
//               .doc()
//               .set({
//             'issue': e.toString(),
//             'mobile': widget.phoneNumber,
//             'userId': FirebaseAuth.instance.currentUser == null
//                 ? ''
//                 : FirebaseAuth.instance.currentUser.uid,
//             'date':
//             DateFormat().add_yMMMd().add_jm().format(DateTime.now()),
//           });
//         },
//         codeSent: (String verficationID, int resendToken) async {
//           FirebaseFirestore.instance
//               .collection('logger')
//               .doc(widget.phoneNumber)
//               .collection('OTP-Sent')
//               .doc()
//               .set({
//             'otp': verficationID,
//             'resendToken': resendToken,
//             'mobile': widget.phoneNumber,
//             'userId': FirebaseAuth.instance.currentUser == null
//                 ? ''
//                 : FirebaseAuth.instance.currentUser.uid,
//             'date':
//             DateFormat().add_yMMMd().add_jm().format(DateTime.now()),
//           }).then((value) => setState(() {
//             _verificationCode = verficationID;
//             _resendToken = resendToken;
//             _startTimer = true;
//           }));
//         },
//         codeAutoRetrievalTimeout: (String verificationID) {
//           print('codeAutoTimeout===' + verificationID);
//         },
//         timeout: Duration(seconds: 60),
//         forceResendingToken: _resendToken)
//         .catchError((error) async {
//       print('otp-error===>' + error.toString());
//       FirebaseFirestore.instance
//           .collection('logger')
//           .doc(widget.phoneNumber)
//           .collection('OTP-Error')
//           .doc()
//           .set({
//         'issue': error.toString(),
//         'mobile': widget.phoneNumber,
//         'userId': FirebaseAuth.instance.currentUser == null
//             ? ''
//             : FirebaseAuth.instance.currentUser.uid,
//         'date': DateFormat().add_yMMMd().add_jm().format(DateTime.now()),
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       key: scaffoldKey,
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: ListView(
//
//             Padding(
//               padding: EdgeInsets.all(15),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: RaisedButton(
//                   padding: EdgeInsets.all(10.0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24),
//                   ),
//                   elevation: 5,
//                   color: primaryColor,
//                   child: Text(
//                     "verify_button".tr,
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   onPressed: () async {
//
//                       try {
//                         await FirebaseAuth.instance
//                             .signInWithCredential(PhoneAuthProvider.credential(
//                             verificationId: _verificationCode,
//                             smsCode: currentText))
//                             .then((value) async {
//                           if (value.user != null) {
//                             try {
//                               FirebaseFirestore.instance
//                                   .collection("userInfo")
//                                   .doc(FirebaseAuth.instance.currentUser.uid)
//                                   .get(
//                                   GetOptions(source: Source.serverAndCache))
//                                   .then((profile) {
//                                 profile.exists
//                                     ? Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             UserDetailsUpdate(
//                                               currentUser: value.user.uid,
//                                               mobile: widget.phoneNumber,
//                                               name: profile['name'],
//                                               referralCode: profile[
//                                               'enteredReferralCode'],
//                                             )))
//                                     : Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             UserDetailsFetch(
//                                                 currentUser: value.user.uid,
//                                                 mobile:
//                                                 widget.phoneNumber)));
//                               });
//                             } catch (e) {
//                               Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => UserDetailsFetch(
//                                           currentUser: value.user.uid,
//                                           mobile: widget.phoneNumber)));
//                             }
//                           }
//                         });
//                       } catch (e) {
//                         FocusScope.of(context).unfocus();
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('invalid_otp'.tr)));
//                       }
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }