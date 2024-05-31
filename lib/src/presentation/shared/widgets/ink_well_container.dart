// Flutter imports:
import 'package:flutter/material.dart';

class InkWellContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final Widget? child;

  const InkWellContainer({
    super.key,
    this.width,
    this.height,
    this.color,
    this.margin,
    this.padding,
    this.radius,
    this.border,
    this.boxShadow,
    this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 0),
        color: color,
        border: border,
        boxShadow: boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius ?? 0),
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: child,
          ),
        ),
      ),
    );
  }
}
