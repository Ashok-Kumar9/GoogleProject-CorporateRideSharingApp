import 'package:flutter/material.dart';

class ColorShades {
  // google colors
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleRed = Color(0xFFDB4437);
  static const Color googleYellow = Color(0xFFF4B400);
  static const Color googleGreen = Color(0xFF0F9D58);

  static const Color backGroundBlack = Color(0xFF212121);
  static const Color backGroundGrey = Color(0xFF2B2B2B);
  static const Color lightGrey = Color(0xFF333333);
  static const Color grey = Colors.grey;
  static const Color white = Color(0xffffffff);
  static const Color blue = Color(0xff288fee);
  static const Color greenDark = Color(0xff065F62);
}

extension CustomTextTheme on TextTheme {
  TextStyle get h1 => const TextStyle(
      fontSize: 32.0, fontWeight: FontWeight.w900, color: Color(0xffEEEEEE));

  TextStyle get h2 => const TextStyle(
      fontSize: 24.0, fontWeight: FontWeight.w900, color: Color(0xffEEEEEE));

  TextStyle get h3 => const TextStyle(
      fontSize: 20.0, fontWeight: FontWeight.w900, color: Color(0xffEEEEEE));

  TextStyle get h4 => const TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w500, color: Color(0xffEEEEEE));

  TextStyle get h5 => const TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w500, color: Color(0xffEEEEEE));

  TextStyle get h6 => const TextStyle(
      fontSize: 12.0, fontWeight: FontWeight.w500, color: Color(0xffEEEEEE));

  TextStyle get h7 => const TextStyle(
      fontSize: 10.0, fontWeight: FontWeight.normal, color: Color(0xffEEEEEE));

  TextStyle get h8 => const TextStyle(
      fontSize: 8.0, fontWeight: FontWeight.w500, color: Color(0xffEEEEEE));
}

class Gradients {
  LinearGradient get referEarnContainerGradient => const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: <Color>[ColorShades.lightGrey, ColorShades.grey],
      );
}

class BoxDecorations {
  BoxDecoration get textFieldBox => const BoxDecoration(
      color: ColorShades.lightGrey,
      borderRadius: BorderRadius.all(Radius.circular(10.0)));
}
