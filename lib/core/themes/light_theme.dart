// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/themes/bottom_sheet_theme.dart';
import 'package:law_app/core/themes/button_theme.dart';
import 'package:law_app/core/themes/input_decoration_theme.dart';

ThemeData get lightTheme {
  return ThemeData.from(
    colorScheme: colorScheme,
    textTheme: textTheme,
    useMaterial3: true,
  ).copyWith(
    filledButtonTheme: filledButtonTheme,
    outlinedButtonTheme: outlinedButtonTheme,
    textButtonTheme: textButtonTheme,
    segmentedButtonTheme: segmentedButtonTheme,
    inputDecorationTheme: inputDecorationTheme,
    bottomSheetTheme: bottomSheetTheme,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
