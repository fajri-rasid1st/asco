// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';

enum SnackBarType {
  error(Palette.error),
  success(Palette.success),
  warning(Palette.warning),
  info(Palette.info);

  final Color color;

  const SnackBarType(this.color);
}
