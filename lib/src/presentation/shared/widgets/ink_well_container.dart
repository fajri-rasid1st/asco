// Flutter imports:
import 'package:flutter/material.dart';

class InkWellContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final Clip clipBehavior;
  final VoidCallback? onTap;
  final Widget? child;

  const InkWellContainer({
    super.key,
    this.width,
    this.height,
    this.color,
    this.margin,
    this.padding,
    this.radius = 0,
    this.border,
    this.boxShadow,
    this.clipBehavior = Clip.none,
    this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color,
        border: border,
        boxShadow: boxShadow,
      ),
      child: Material(
        clipBehavior: clipBehavior,
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: child,
          ),
        ),
      ),
    );
  }
}
