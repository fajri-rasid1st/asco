// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';

class CustomBadge extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color? color;

  const CustomBadge({
    super.key,
    required this.text,
    this.textStyle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
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
