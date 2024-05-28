// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:after_layout/after_layout.dart';

// Project imports:
import 'package:asco/core/configs/app_configs.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with AfterLayoutMixin<SplashPage> {
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    Timer(const Duration(seconds: 4), () async {
      await navigatorKey.currentState!.pushReplacementNamed(onBoardingRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top],
      ),
      child: Scaffold(
        backgroundColor: purple2,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SvgAsset(
                assetName: AssetPath.getVector('bg_attribute.svg'),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: RotatedBox(
                quarterTurns: -2,
                child: SvgAsset(
                  assetName: AssetPath.getVector('bg_attribute.svg'),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgAsset(
                    assetName: AssetPath.getVector('logo1.svg'),
                  ),
                  Text(
                    AppConfigs.title,
                    style: const TextStyle(
                      color: backgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 44,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
