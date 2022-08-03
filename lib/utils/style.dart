import 'package:flutter/material.dart';

class ColorShades {
  static const Color backGroundBlack = Color(0xFF212121);
  static const Color backGroundGrey = Color(0xFF2B2B2B);
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
        colors: <Color>[
          Color(0xFF0D324D), Color(0xFF7F5A83)
        ],
      );
}

class BoxDecorations {
  BoxDecoration get detailPageBoxDecoration => const BoxDecoration(
      color: Color(0xff303030),
      borderRadius: BorderRadius.all(Radius.circular(10.0)));
}
