// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';

enum SnackBarType {
  error(errorColor),
  success(successColor),
  warning(warningColor),
  info(infoColor);

  final Color color;

  const SnackBarType(this.color);
}
