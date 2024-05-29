// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';

final textTheme = const TextTheme(
  displayLarge: TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w600,
  ),
  displayMedium: TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w600,
  ),
  displaySmall: TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w600,
  ),
  headlineLarge: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
  ),
  headlineMedium: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
  ),
  headlineSmall: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  ),
  titleLarge: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
  ),
  titleMedium: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  ),
  titleSmall: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  ),
  bodyLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
  bodyMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  bodySmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  ),
  labelLarge: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: .1,
  ),
  labelSmall: TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
  ),
).apply(
  fontFamily: 'Poppins',
  bodyColor: Palette.primaryText,
  displayColor: Palette.primaryText,
);
