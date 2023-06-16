import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/style.dart';

animationDialog(BuildContext context,
    {required AnimationController animationController, String jsonFileName = "login_success"}) {
  final double screenHeight = MediaQuery.of(context).size.height;
  final double screenWidth = MediaQuery.of(context).size.width;
  showGeneralDialog(
    barrierLabel: "animationDialog",
    barrierDismissible: false,
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return Container(
        width: screenWidth * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: ColorShades.backGroundBlack,
        ),
        child: Lottie.asset(
          "assets/animations/$jsonFileName.json",
          height: screenHeight * 0.25,
          controller: animationController,
          onLoaded: (composition) {
            animationController.duration = composition.duration;
            animationController.forward();
          },
          repeat: false,
          errorBuilder: (context, e, s) => const SizedBox.shrink(),
        ),
      );
    },
  );
}
