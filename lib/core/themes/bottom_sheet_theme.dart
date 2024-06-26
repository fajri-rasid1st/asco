// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';

const bottomSheetTheme = BottomSheetThemeData(
  elevation: 4,
  modalElevation: 4,
  backgroundColor: Palette.scaffoldBackground,
  surfaceTintColor: Palette.scaffoldBackground,
  modalBackgroundColor: Palette.scaffoldBackground,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(20),
    ),
  ),
);
