// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';

class AssistanceStatusIcon extends StatelessWidget {
  final bool? isAttend;
  final VoidCallback? onTap;

  const AssistanceStatusIcon({
    super.key,
    this.isAttend,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = switch (isAttend) {
      true => Palette.purple2,
      false => Palette.pink2,
      null => null,
    };

    final fillColor = switch (isAttend) {
      true => Palette.success,
      false => Palette.error,
      null => null,
    };

    final icon = switch (isAttend) {
      true => Icons.check_rounded,
      false => Icons.close_rounded,
      null => null,
    };

    return CircleBorderContainer(
      size: 26,
      borderColor: borderColor,
      fillColor: fillColor,
      onTap: onTap,
      child: Icon(
        icon,
        color: Palette.background,
        size: isAttend == null ? null : 16,
      ),
    );
  }
}
