// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/enums/attendance_type.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/shared/widgets/cards/attendance_card.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_badge.dart';
import 'package:asco/src/presentation/shared/widgets/custom_icon_button.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class ControlCardDetailPage extends StatelessWidget {
  const ControlCardDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Kartu Kontrol',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                const SizedBox(height: 160),
                Container(
                  height: 120,
                  color: Palette.purple2,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      RotatedBox(
                        quarterTurns: -2,
                        child: SvgAsset(
                          AssetPath.getVector('bg_attribute.svg'),
                          height: 120,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          children: [
                            CustomIconButton(
                              'github_filled.svg',
                              color: Palette.background,
                              tooltip: 'Github',
                              onPressed: () => FunctionHelper.openUrl(
                                'https://github.com/fajri-rasid1st',
                              ),
                            ),
                            CustomIconButton(
                              'instagram_filled.svg',
                              tooltip: 'Instagram',
                              onPressed: () => FunctionHelper.openUrl(
                                'https://instagram.com/fajri_rasid1st',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  top: 60,
                  left: 20,
                  child: CircleNetworkImage(
                    imageUrl: 'https://placehold.co/300x300/png',
                    size: 100,
                    withBorder: true,
                    borderWidth: 2,
                    borderColor: Palette.background,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Muhammad Sulthan Nazhim Latenri Tatta S.H',
                    style: textTheme.titleLarge!.copyWith(
                      color: Palette.purple2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'H071211074',
                    style: textTheme.bodyMedium!.copyWith(
                      color: Palette.purple3,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 6,
                      bottom: 16,
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        CustomBadge(
                          text: 'Pemrograman Mobile A',
                        ),
                        CustomBadge(
                          text: 'Group #1',
                          color: Palette.error,
                        ),
                      ],
                    ),
                  ),
                  ...List<Padding>.generate(
                    10,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: index == 9 ? 0 : 10,
                      ),
                      child: const AttendanceCard(
                        attendanceType: AttendanceType.assistance,
                        locked: true,
                      ),
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
