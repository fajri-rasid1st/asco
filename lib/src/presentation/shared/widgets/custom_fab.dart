// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final String? tooltip;
  final VoidCallback? onPressed;
  final Widget child;

  const CustomFloatingActionButton({
    super.key,
    this.tooltip,
    this.onPressed,
    required this.child,
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
