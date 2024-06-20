// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';

enum SnackBarType {
  error(Palette.error, 'error_outlined.svg'),
  success(Palette.success, 'success_outlined.svg'),
  warning(Palette.warning, 'warning_outlined.svg'),
  info(Palette.info, 'warning_outlined.svg');

  final Color color;
  final String iconName;

  const SnackBarType(this.color, this.iconName);
}
