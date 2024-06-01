// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsetsGeometry childPadding;
  final Color? backgroundColor;
  final VoidCallback? onPressedPrimaryAction;

  const CustomDialog({
    super.key,
    required this.title,
    required this.child,
    this.childPadding = const EdgeInsets.fromLTRB(20, 8, 20, 24),
    this.backgroundColor,
    this.onPressedPrimaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor,
      surfaceTintColor: backgroundColor,
      insetPadding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 32,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => navigatorKey.currentState!.pop(),
                    icon: SvgAsset(
                      AssetPath.getIcon('close_outlined.svg'),
                      color: Palette.primaryText,
                    ),
                    tooltip: 'Kembali',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: const CircleBorder(),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium!.copyWith(
                        color: Palette.purple2,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onPressedPrimaryAction,
                    icon: SvgAsset(
                      AssetPath.getIcon('check_outlined.svg'),
                      color: Palette.primary,
                      width: 26,
                    ),
                    tooltip: 'Submit',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: childPadding,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
