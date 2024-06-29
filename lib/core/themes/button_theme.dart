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
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);

final outlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    foregroundColor: Palette.primary,
    disabledForegroundColor: Palette.disabledText,
    side: const BorderSide(
      color: Palette.primary,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);

final textButtonTheme = TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: Palette.primary,
    disabledForegroundColor: Palette.disabledText,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);

final iconButtonTheme = IconButtonThemeData(
  style: IconButton.styleFrom(
    foregroundColor: Palette.background,
    disabledForegroundColor: Palette.disabledText,
    backgroundColor: Palette.primary,
    disabledBackgroundColor: Palette.disabled,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
