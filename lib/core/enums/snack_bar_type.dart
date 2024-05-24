// Flutter imports:
import 'package:flutter/material.dart';

enum SnackBarType {
  error(Color(0xFF000000), Color(0xFF000000)),
  success(Color(0xFF000000), Color(0xFF000000)),
  warning(Color(0xFF000000), Color(0xFF000000)),
  info(Color(0xFF000000), Color(0xFF000000));

  final Color backgroundColor;
  final Color foregroundColor;

  const SnackBarType(
    this.backgroundColor,
    this.foregroundColor,
  );
}
