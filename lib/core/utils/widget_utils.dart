// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

/// A collection of widget utility functions that are reusable for this app
class WidgetUtils {
  /// Create a custom [MaterialBanner] widget.
  static MaterialBanner createMaterialBanner({
    required String message,
    required BannerType type,
    bool autoClose = true,
    Duration autoCloseDuration = const Duration(milliseconds: 3500),
    bool showOkButton = false,
  }) {
    return MaterialBanner(
      elevation: 0,
      dividerColor: Colors.transparent,
      backgroundColor: type.backgroundColor,
      leadingPadding: const EdgeInsetsDirectional.only(end: 10),
      content: Text(
        message,
        style: TextStyle(
          color: type.foregroundColor,
        ),
      ),
      leading: SvgAsset(
        assetPath: AssetPath.getIcon(type.leadingIconName),
        color: type.foregroundColor,
        width: 20,
      ),
      actions: showOkButton
          ? [
              TextButton(
                onPressed: () => scaffoldMessengerKey.currentState!.hideCurrentMaterialBanner(),
                child: Text(
                  'Ok',
                  style: TextStyle(
                    color: type.foregroundColor,
                  ),
                ),
              ),
            ]
          : [
              const SizedBox(),
            ],
      onVisible: autoClose
          ? () {
              Future.delayed(autoCloseDuration, () {
                scaffoldMessengerKey.currentState!.hideCurrentMaterialBanner();
              });
            }
          : null,
    );
  }
}
