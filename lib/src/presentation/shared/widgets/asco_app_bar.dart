// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class AscoAppBar extends StatelessWidget {
  const AscoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgAsset(
          AssetPath.getVector('logo.svg'),
        ),
        const SizedBox(width: 4),
        RichText(
          text: TextSpan(
            text: 'as',
            style: textTheme.headlineSmall!.copyWith(
              color: Palette.purple2,
              fontSize: 26,
            ),
            children: [
              TextSpan(
                text: 'co',
                style: textTheme.headlineSmall!.copyWith(
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
