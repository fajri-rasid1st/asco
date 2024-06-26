// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';

class CircleBorderContainer extends StatelessWidget {
  final double size;
  final bool withBorder;
  final double borderWidth;
  final Color? borderColor;
  final Color? fillColor;
  final VoidCallback? onTap;
  final Widget? child;

  const CircleBorderContainer({
    super.key,
    required this.size,
    this.withBorder = true,
    this.borderWidth = 1.0,
    this.borderColor,
    this.fillColor,
    this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fillColor ?? Palette.secondaryBackground,
        border: withBorder
            ? Border.all(
                width: borderWidth,
                color: borderColor ?? Palette.border,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(size / 2),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
