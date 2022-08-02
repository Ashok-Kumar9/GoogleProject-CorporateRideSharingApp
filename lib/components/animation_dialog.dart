import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/style.dart';

animationDialog(BuildContext context, {required AnimationController animationController}) {
  final double screenHeight = MediaQuery.of(context).size.height;
  final double screenWidth = MediaQuery.of(context).size.width;
  showGeneralDialog(
    barrierLabel: "animationDialog",
    barrierDismissible: false,
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
        child: FittedBox(
          child: Container(
            width: screenWidth * 0.6,
            padding: EdgeInsets.only(bottom: screenHeight * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: ColorShades.backGroundBlack,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Lottie.asset(
                    "assets/animations/login_success.json",
                    height: screenHeight * 0.25,
                    controller: animationController,
                    onLoaded: (composition) {
                      animationController.duration = composition.duration;
                      animationController.forward();
                    },
                    repeat: false,
                    errorBuilder: (context, e, s) => const SizedBox.shrink(),
                  ),
                ]),
          ),
        ),
      );
    },
  );
}