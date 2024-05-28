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
  final VoidCallback? onPressedPrimaryAction;

  const CustomDialog({
    super.key,
    required this.title,
    required this.child,
    this.childPadding = const EdgeInsets.fromLTRB(20, 8, 20, 24),
    this.onPressedPrimaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 36,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => navigatorKey.currentState!.pop(),
                    icon: SvgAsset(
                      assetName: AssetPath.getIcon('close_outlined.svg'),
                      color: primaryTextColor,
                    ),
                    tooltip: 'Close',
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium!.copyWith(
                        color: purple2,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onPressedPrimaryAction,
                    icon: SvgAsset(
                      assetName: AssetPath.getIcon('check_outlined.svg'),
                      color: primaryColor,
                      width: 26,
                    ),
                    tooltip: 'Submit',
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
