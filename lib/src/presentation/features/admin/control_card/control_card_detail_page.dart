// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/enums/attendance_type.dart';
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/shared/widgets/cards/attendance_card.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_badge.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class ControlCardDetailPage extends StatelessWidget {
  const ControlCardDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Kartu Kontrol',
      ),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) {
          return [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  SizedBox(
                    height: 300,
                    width: AppSize.getAppWidth(context),
                  ),
                  Container(
                    height: 150,
                    color: Palette.purple2,
                  ),
                  Positioned(
                    bottom: 150,
                    right: 0,
                    child: RotatedBox(
                      quarterTurns: -2,
                      child: SvgAsset(
                        AssetPath.getVector('bg_attribute.svg'),
                        height: 150,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 150,
                    right: 0,
                    child: SvgAsset(
                      AssetPath.getVector('bg_attribute_3.svg'),
                      height: 100,
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    child: SizedBox(
                      width: AppSize.getAppWidth(context),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleNetworkImage(
                                  imageUrl: 'https://placehold.co/300x300/png',
                                  size: 100,
                                  withBorder: true,
                                  borderWidth: 2,
                                  borderColor: Palette.scaffoldBackground,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Muhammad Sulthan Nazim Latenri Tatta S.H.',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.titleLarge?.copyWith(
                                    color: Palette.purple2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'H071211074',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Palette.purple3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.fromLTRB(20, 6, 20, 0),
                            child: Row(
                              children: [
                                CustomBadge(
                                  text: 'Pemrograman Mobile A',
                                ),
                                SizedBox(width: 8),
                                CustomBadge(
                                  text: 'Group #1',
                                  color: Palette.error,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 10,
                  (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == 9 ? 0 : 10,
                      ),
                      child: const AttendanceCard(
                        assistanceStatus: [true, false],
                        attendanceType: AttendanceType.assistance,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
