// Flutter imports:
import 'package:flutter/material.dart';

// Main colors
const primaryColor = Color(0xFF730034);
const secondaryColor = Color(0xFFF4EBEF);
const tertiaryColor = Color(0xFFC799AE);
const accentColor = Color(0xFFF1D443);

// Text colors
const primaryTextColor = Color(0xFF160706);
const secondaryTextColor = Color(0xFFC8C4C4);
const accentTextColor = Color(0xFFF9E47A);

// Background colors
const backgroundColor = Color(0xFFFCFAFB);
const scaffoldBackgroundColor = Color(0xFFFFFFFF);

// System colors
const errorColor = Color(0xFFDC2626);
const successColor = Color(0xFF16A34A);
const infoColor = Color(0xFF1D4ED8);
const warningColor = Color(0xFFEAB308);

// Gradient colors
class GradientColors {
  static const List<Color> redPastel = [
    Color(0xFFA2355A),
    Color(0xFF730034),
  ];
}

// General palette
const Color black = Color(0xFF01000D);
const Color blackPurple = Color(0xFF120825);
const Color white = Color(0xFFFFFFFF);
const Color red = Color(0xFFE44B70);
const Color yellow = Color(0xFFFFD37F);

// Grey palette
const Color grey = Color(0xFFF2F6FE);
const Color grey10 = Color(0xFFEDF2FB);
const Color grey50 = Color(0xFF9CA7BB);
const Color greyDark = Color(0xFF6884B6);
const Color disable = Color(0xFFA8B2C3);

// Purple palette
const Color purple100 = Color(0xFF1E0059);
const Color purple80 = Color(0xFF3E2484);
const Color purple70 = Color(0xFF6C4BC6);
const Color purple60 = Color(0xFF744BE4);
const Color purple50 = Color(0xFF9088E6);
const Color purple40 = Color(0xFF8172F4);
const Color purple30 = Color(0xFF938AE5);
const Color purple20 = Color(0xFFBBAEF2);
const Color purple10 = Color(0xFFF1ECFF);

// Orange palette
const Color orange60 = Color(0xFFDA8535);
const Color orange20 = Color(0xFFFFB37F);
const Color orange10 = Color(0xFFFFEFE2);

// Violet palette
const Color violet60 = Color(0xFFE24EE8);
const Color violet50 = Color(0xFFE44BC2);
const Color violet30 = Color(0xFFF2B5F5);
const Color violet10 = Color(0xFFFEEEFF);

// Salmon palette
const Color salmon40 = Color(0xFFDD8585);
const Color salmon20 = Color(0xFFF2AEAE);

// Plum palette
const Color plum80 = Color(0xFF842469);
const Color plum70 = Color(0xFFE44B94);
const Color plum60 = Color(0xFFDD85AF);
const Color plum40 = Color(0xFFDD85AF);
const Color plum20 = Color(0xFFF2AECF);

// Azure palette
const Color azure60 = Color(0xFF6573EF);
const Color azure40 = Color(0xFF85A8DD);
const Color azure20 = Color(0xFFAED1F2);

// Tosca palette
const Color tosca40 = Color(0xFF85D8DD);
const Color tosca20 = Color(0xFFAEF2DE);

// Color scheme
final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: primaryColor,
  primary: primaryColor,
  onPrimary: secondaryColor,
  secondary: secondaryColor,
  onSecondary: primaryColor,
  background: backgroundColor,
  onBackground: primaryTextColor,
  error: errorColor,
  onError: scaffoldBackgroundColor,
);
