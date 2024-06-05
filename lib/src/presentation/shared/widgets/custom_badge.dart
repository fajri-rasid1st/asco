// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';

class CustomBadge extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color? color;
  final double? verticalPadding;
  final double? horizontalPadding;

  const CustomBadge({
    super.key,
    required this.text,
    this.textStyle,
    this.color,
    this.verticalPadding,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding ?? 4,
        horizontal: horizontalPadding ?? 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        color: color ?? Palette.primary,
      ),
      child: Text(
        text,
        style: textStyle ??
            textTheme.labelSmall?.copyWith(
              color: Palette.background,
              height: 1,
            ),
      ),
    );
  }
}
