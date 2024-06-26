// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/custom_icon_button.dart';
import 'package:asco/src/presentation/shared/widgets/practicum_badge_image.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class AssistantProfilePage extends StatelessWidget {
  const AssistantProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                const SizedBox(height: 160 + kToolbarHeight),
                Container(
                  height: 120 + kToolbarHeight,
                  color: Palette.purple2,
                ),
                Positioned(
                  top: kToolbarHeight,
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
                      Positioned(
                        bottom: 8,
                        right: 10,
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
                            const SizedBox(width: 2),
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
                Positioned(
                  left: 20,
                  right: 10,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 28),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'ID Card',
                              style: textTheme.headlineSmall!.copyWith(
                                color: Palette.background,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CustomIconButton(
                            'edit_outlined.svg',
                            tooltip: 'Edit Profil',
                            onPressed: () => navigatorKey.currentState!.pushNamed(editProfileRoute),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  top: 60 + kToolbarHeight,
                  left: 20,
                  child: CircleNetworkImage(
                    imageUrl: 'https://placehold.co/300x300/png',
                    size: 100,
                    withBorder: true,
                    borderWidth: 2,
                    borderColor: Palette.background,
                    showPreviewWhenPressed: true,
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
                    'Eurico Devon Bura Pakilaran',
                    style: textTheme.titleLarge!.copyWith(
                      color: Palette.purple2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Devonian',
                    style: textTheme.bodyMedium!.copyWith(
                      color: Palette.purple3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, index) => const AssistantBadgeCard(),
                    itemCount: 2,
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

class AssistantBadgeCard extends StatelessWidget {
  const AssistantBadgeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Palette.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Palette.purple2,
        ),
        boxShadow: const [
          BoxShadow(
            offset: Offset(3, 2),
            color: Palette.purple2,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
              ),
              child: SvgAsset(
                AssetPath.getVector('bg_attribute_3.svg'),
                height: 48,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const PracticumBadgeImage(
                  badgeUrl: 'https://placehold.co/138x150/png',
                  width: 48,
                  height: 52,
                ),
                const SizedBox(height: 8),
                Text(
                  'Asisten',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Algoritma dan Pemrograman Dasar',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall!.copyWith(
                    color: Palette.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
