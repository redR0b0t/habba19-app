import 'dart:ui';

import 'package:flutter/material.dart';

class CustomColors {

  const CustomColors();
//  static const Color iconInactiveColor = Color(0xff7F0E2D);
  static const Color iconInactiveColor = const  Color(0xff14213d);
  static const Color iconActiveColor = const Color(0xFFF9BB60);
//  static const Color iconActiveColor =  Color(0xFFf7418c);
  static const Color loginGradientStart = const Color(0xFFfbab66);
  static const Color loginGradientEnd = const Color(0xFFf7418c);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

  TextStyle titleStyle = TextStyle(color: Colors.black, fontSize: 30);
  TextStyle textStyle = TextStyle(
    color: Colors.black,
  );