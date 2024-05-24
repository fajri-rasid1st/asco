// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/styles/color_scheme.dart';

const bottomSheetTheme = BottomSheetThemeData(
  surfaceTintColor: scaffoldBackgroundColor,
  backgroundColor: scaffoldBackgroundColor,
  modalBackgroundColor: scaffoldBackgroundColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(20),
    ),
  ),
);
