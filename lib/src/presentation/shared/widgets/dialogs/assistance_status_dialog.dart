// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rive/rive.dart';

// Project imports:
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';

class AssistanceStatusDialog extends StatelessWidget {
  final bool isDone;

  const AssistanceStatusDialog({super.key, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.fromLTRB(32, 56, 32, 24),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned(
            top: -130,
            child: SizedBox(
              width: 250,
              height: 250,
              child: RiveAnimation.asset(
                AssetPath.getRive(
                  isDone ? 'checkmark_icon.riv' : 'error_icon.riv',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 68, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tipe Data dan Attribute',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Asistensi 1',
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge!.copyWith(
                    color: Palette.purple2,
                  ),
                ),
                Text(
                  isDone ? 'Hadir' : 'Tidak Hadir',
                  textAlign: TextAlign.center,
                  style: textTheme.titleSmall!.copyWith(
                    color: isDone ? Palette.success : Palette.error,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Wd. Ananda Lesmono',
                  textAlign: TextAlign.center,
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'H071211074',
                  textAlign: TextAlign.center,
                  style: textTheme.labelLarge,
                ),
                Text(
                  '10/09/2023',
                  textAlign: TextAlign.center,
                  style: textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
