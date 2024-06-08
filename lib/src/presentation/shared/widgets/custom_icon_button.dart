// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class CustomIconButton extends StatelessWidget {
  final String iconName;
  final double? size;
  final Color? color;
  final double splashRadius;
  final String tooltip;
  final VoidCallback? onPressed;

  const CustomIconButton(
    this.iconName, {
    super.key,
    this.size,
    this.color,
    this.splashRadius = 4.0,
    this.tooltip = '',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Tooltip(
            message: tooltip,
            child: Padding(
              padding: EdgeInsets.all(splashRadius),
              child: SvgAsset(
                AssetPath.getIcon(iconName),
                color: color,
                width: size,
                height: size,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
