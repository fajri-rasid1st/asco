// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final Widget child;
  final String? tooltip;
  final VoidCallback? onPressed;

  const CustomFloatingActionButton({
    super.key,
    required this.child,
    this.tooltip,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 4,
      foregroundColor: Palette.background,
      backgroundColor: Palette.purple1,
      shape: const CircleBorder(
        side: BorderSide(
          width: 2,
          color: Palette.purple3,
        ),
      ),
      onPressed: onPressed,
      tooltip: tooltip,
      child: child,
    );
  }
}
