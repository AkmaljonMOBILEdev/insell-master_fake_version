import 'dart:math';

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static Color appColorBlackBg = Colors.black54.withOpacity(0.8);
  static Color appColorBlackBgHover = Colors.black54.withOpacity(0.9);

  static Color appColorGrey300 = Colors.grey.shade300;
  static Color appColorGrey400 = Colors.grey.shade400;
  static Color appColorGrey700 = Colors.grey.shade700;

  static Color appColorGreen300 = Colors.green.shade300;
  static Color appColorGreen400 = Colors.green.shade400;
  static Color appColorGreen700 = Colors.green.shade700;

  static Color appColorRed300 = Colors.red.shade300;
  static Color appColorRed400 = Colors.red.shade400;

  static Color appColorWhite = Colors.white;


}

List<Color> randomColors = List.generate(
  100,
      (index) => Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0),
);
