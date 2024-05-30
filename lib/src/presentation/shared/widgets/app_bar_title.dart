// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgAsset(
          assetName: AssetPath.getVector('logo2.svg'),
        ),
        const SizedBox(width: 4),
        RichText(
          text: TextSpan(
            text: 'as',
            style: textTheme.headlineSmall?.copyWith(
              color: Palette.purple2,
              fontSize: 26,
            ),
            children: [
              TextSpan(
                text: 'co',
                style: textTheme.headlineSmall?.copyWith(
                  color: Palette.purple3,
                  fontSize: 26,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
