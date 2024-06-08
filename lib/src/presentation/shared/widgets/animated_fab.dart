// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';

class AnimatedFloatingActionButton extends StatelessWidget {
  final AnimationController animationController;
  final String? tooltip;
  final VoidCallback? onPressed;
  final Widget? child;

  const AnimatedFloatingActionButton({
    super.key,
    required this.animationController,
    this.tooltip,
    this.onPressed,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animationController,
      alignment: Alignment.bottomCenter,
      child: FloatingActionButton(
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
      ),
    );
  }
}
