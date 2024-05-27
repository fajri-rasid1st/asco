// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/themes/button_theme.dart';
import 'package:asco/core/themes/dialog_theme.dart';
import 'package:asco/core/themes/input_decoration_theme.dart';

ThemeData get lightTheme {
  return ThemeData.from(
    colorScheme: colorScheme,
    textTheme: textTheme,
    useMaterial3: true,
  ).copyWith(
    filledButtonTheme: filledButtonTheme,
    outlinedButtonTheme: outlinedButtonTheme,
    textButtonTheme: textButtonTheme,
    dialogTheme: dialogTheme,
    inputDecorationTheme: inputDecorationTheme,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    hintColor: hintColor,
    dividerColor: dividerColor,
    cardColor: backgroundColor,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
