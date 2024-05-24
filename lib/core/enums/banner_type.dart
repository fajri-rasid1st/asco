// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/styles/color_scheme.dart';

enum BannerType {
  error('times-circle-line.svg', errorColor, scaffoldBackgroundColor),
  success('check-circle-line.svg', successColor, scaffoldBackgroundColor),
  info('exclamation-circle-line.svg', infoColor, scaffoldBackgroundColor),
  warning('exclamation-circle-line.svg', warningColor, scaffoldBackgroundColor);

  final String leadingIconName;
  final Color backgroundColor;
  final Color foregroundColor;

  const BannerType(
    this.leadingIconName,
    this.backgroundColor,
    this.foregroundColor,
  );
}
