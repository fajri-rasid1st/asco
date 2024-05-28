// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class CustomSnackBar extends StatelessWidget {
  final String title;
  final String message;
  final SnackBarType type;

  const CustomSnackBar({
    super.key,
    required this.title,
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final width = AppSize.getAppWidth(context);
    final height = AppSize.getAppHeight(context);

    final hsl = HSLColor.fromColor(type.color);
    final hslDark = hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0));

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
            width * 0.06,
            height * 0.022,
            width * 0.05,
            height * 0.022,
          ),
          decoration: BoxDecoration(
            color: type.color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Spacer(),
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleLarge!.copyWith(
                              color: backgroundColor,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => scaffoldMessengerKey.currentState?.hideCurrentSnackBar(),
                          child: SvgAsset(
                            assetName: AssetPath.getIcon('error_outlined.svg'),
                            height: height * 0.020,
                            color: hslDark.toColor(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium!.copyWith(
                        color: scaffoldBackgroundColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
            ),
            child: SvgAsset(
              assetName: AssetPath.getVector('bubbles.svg'),
              height: height * 0.05,
              color: hslDark.toColor(),
            ),
          ),
        ),
        Positioned(
          top: -height * 0.02,
          left: width * 0.03,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgAsset(
                assetName: AssetPath.getVector('message_bubble.svg'),
                height: height * 0.06,
                color: hslDark.toColor(),
              ),
              Positioned(
                top: height * 0.015,
                child: SvgAsset(
                  assetName: AssetPath.getIcon(getIconName(type)),
                  height: height * 0.024,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  String getIconName(SnackBarType type) {
    if (type == SnackBarType.error) return 'error_outlined.svg';

    if (type == SnackBarType.warning) return 'warning_outlined.svg';

    if (type == SnackBarType.info) return 'warning_outlined.svg';

    return 'success_outlined.svg';
  }
}
