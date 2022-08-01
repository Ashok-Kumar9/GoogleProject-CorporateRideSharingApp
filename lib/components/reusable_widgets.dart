import 'package:corporate_ride_sharing/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class ReusableWidgets {
  Center threeBounceLoader() {
    return const Center(
      child: SpinKitThreeBounce(
        color: Colors.white,
        size: 20.0,
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: Theme.of(context).textTheme.h5,
        textAlign: TextAlign.center,
      ),
      backgroundColor: ColorShades.backGroundGrey,
    ));
  }

  Future<bool?> showToast(String message) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: ColorShades.backGroundGrey,
      textColor: Colors.white,
    );
  }


}
