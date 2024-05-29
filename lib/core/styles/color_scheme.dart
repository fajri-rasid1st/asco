// Flutter imports:
import 'package:flutter/material.dart';

// Color scheme
final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: Palette.purple2,
  primary: Palette.primary,
  onPrimary: Palette.background,
  secondary: Palette.secondary,
  onSecondary: Palette.background,
  background: Palette.background,
  onBackground: Palette.purple1,
  error: Palette.errorText,
  onError: Palette.background,
);

class Palette {
  // Purple palette
  static const purple1 = Color(0xFF1E0059);
  static const purple2 = Color(0xFF3E2484);
  static const purple3 = Color(0xFF744BE4);
  static const purple4 = Color(0xFFBBAEF2);
  static const purple5 = Color(0xFFF1ECFF);

  // Violet palette
  static const violet1 = Color(0xFFE24EE8);
  static const violet2 = Color(0xFFC655CC);
  static const violet3 = Color(0xFFE395E7);
  static const violet4 = Color(0xFFF3B8F6);
  static const violet5 = Color(0xFFFEEEFF);

  // Orange palette
  static const orange1 = Color(0xFFDA8535);
  static const orange2 = Color(0xFFFFB37F);
  static const orange3 = Color(0xFFFFEFE2);

  // Plum palette
  static const plum1 = Color(0xFF842469);
  static const plum2 = Color(0xFFB577A3);
  static const plum3 = Color(0xFFF2AECF);

  // Salmon palette
  static const salmon1 = Color(0xFFDD8585);
  static const salmon2 = Color(0xFFF2AEAE);

  // Azure palette
  static const azure1 = Color(0xFF85A8DD);
  static const azure2 = Color(0xFFAED1F2);

  // Pink palette
  static const pink1 = Color(0xFFE74764);
  static const pink2 = Color(0xFFD35380);

  // Main colors
  static const primary = Color(0xFF744BE4);
  static const secondary = Color(0xFFBBAEF2);

  // Text colors
  static const primaryText = Color(0xFF2B2638);
  static const secondaryText = Color(0xFF9CA7BB);
  static const errorText = Color(0xFFE44B70);
  static const disabledText = Color(0xFF6884B6);

  // Background colors
  static const background = Color(0xFFFFFFFF);
  static const secondaryBackground = Color(0xFFEDF2FB);
  static const scaffoldBackground = Color(0xFFF2F6FE);

  // Component colors
  static const border = Color(0xFF85A2D6);
  static const disabled = Color(0xFFF1F5F9);
  static const hint = Color(0xFFC8CED7);
  static const divider = Color(0xFFD6DCE5);
  static const error = Color(0xFFFA78A6);
  static const success = Color(0xFF744BE4);
  static const info = Color(0xFF788DFA);
  static const warning = Color(0xFFFAC678);
}
