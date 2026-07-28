import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String _fontFamily = 'Inter';

  // Display
  static const displayLg = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    height: 1.25, // 40/32
    letterSpacing: -0.6,
    fontWeight: FontWeight.w700,
  );

  // Headlines
  static const headlineLg = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    height: 1.33, // 32/24
    letterSpacing: -0.2,
    fontWeight: FontWeight.w600,
  );

  static const headlineLgMobile = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    height: 1.4, // 28/20
    fontWeight: FontWeight.w600,
  );

  static const headlineMd = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    height: 1.4, // 28/20
    fontWeight: FontWeight.w600,
  );

  // Body
  static const bodyLg = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    height: 1.5, // 24/16
    fontWeight: FontWeight.w400,
  );

  static const bodyMd = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    height: 1.43, // 20/14
    fontWeight: FontWeight.w400,
  );

  // Labels
  static const labelLg = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    height: 1.43, // 20/14
    fontWeight: FontWeight.w600,
  );

  static const labelSm = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    height: 1.33, // 16/12
    letterSpacing: 0.1,
    fontWeight: FontWeight.w500,
  );
}
