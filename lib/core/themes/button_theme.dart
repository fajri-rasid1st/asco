// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';

final filledButtonTheme = FilledButtonThemeData(
  style: FilledButton.styleFrom(
    backgroundColor: Palette.primary,
    foregroundColor: Palette.background,
    disabledBackgroundColor: Palette.disabled,
    disabledForegroundColor: Palette.disabledText,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);

final outlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    foregroundColor: Palette.primary,
    disabledForegroundColor: Palette.disabledText,
    side: const BorderSide(color: Palette.primary),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);

final textButtonTheme = TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: Palette.primary,
    disabledForegroundColor: Palette.disabledText,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);
