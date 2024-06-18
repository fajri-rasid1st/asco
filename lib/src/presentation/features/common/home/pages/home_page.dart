// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/asco_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/drawer_menu/drawer_menu_widget.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';
import 'package:asco/src/presentation/shared/widgets/practicum_badge_image.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

final selectedMenuProvider = StateProvider.autoDispose<int>((ref) => -1);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedMenuProvider);

    ref.listen(
      selectedMenuProvider,
      (previous, next) {
        if (next == -2) {
          ref.read(selectedMenuProvider.notifier).state = -1;

          // Navigate to profile page
        }

        if (next == 6) {
          ref.read(selectedMenuProvider.notifier).state = -1;

          context.showConfirmDialog(
            title: 'Log Out?',
            message: 'Dengan ini seluruh sesi Anda akan berakhir.',
            primaryButtonText: 'Log Out',
            onPressedPrimaryButton: () {
              navigatorKey.currentState!.pushNamedAndRemoveUntil(
                onBoardingRoute,
                (route) => false,
              );
            },
          );
        }
      },
    );

    return DrawerMenuWidget(
      isMainMenu: false,
      showNavigationBar: false,
      selectedIndex: selectedIndex,
      onSelected: (index) => ref.read(selectedMenuProvider.notifier).state = index,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const AscoAppBar(),
                const SizedBox(height: 24),
                ...List<Padding>.generate(
                  3,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      bottom: index == 2 ? 0 : 12,
                    ),
                    child: const CourseCard(
                      title: 'Pemrograman Mobile A',
                      time: 'Setiap hari Rabu, Pukul 10.10 - 12.40',
                      badgeUrl: 'https://placehold.co/138x150/png',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final String time;
  final String badgeUrl;

  const CourseCard({
    super.key,
    required this.title,
    required this.time,
    required this.badgeUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 16,
      clipBehavior: Clip.antiAlias,
      onTap: () => navigatorKey.currentState!.pushNamedAndRemoveUntil(
        mainMenuRoute,
        (route) => false,
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 180,
            color: Palette.purple3,
          ),
          Positioned(
            right: 0,
            child: SizedBox(
              width: 200,
              height: 180,
              child: SvgAsset(
                AssetPath.getVector('bg_attribute_2.svg'),
                color: Palette.black1.withOpacity(.1),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: SizedBox(
              width: 180,
              height: 180,
              child: SvgAsset(
                AssetPath.getVector('bg_attribute_2.svg'),
                color: Palette.black1.withOpacity(.1),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          title,
                          style: textTheme.titleLarge!.copyWith(
                            color: Palette.background,
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                          ),
                        ),
                      ),
                      const Spacer(),
                      PracticumBadgeImage(
                        badgeUrl: badgeUrl,
                        width: 44,
                        height: 48,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: textTheme.bodySmall!.copyWith(
                      color: Palette.background,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: List<Transform>.generate(
                      4,
                      (index) => Transform.translate(
                        offset: Offset((-18 * index).toDouble(), 0),
                        child: index == 3
                            ? Container(
                                width: 28,
                                height: 28,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Palette.background,
                                ),
                                child: Center(
                                  child: Text(
                                    '+24',
                                    style: textTheme.labelSmall!.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                            : const CircleNetworkImage(
                                imageUrl: 'https://placehold.co/150x150/png',
                                size: 32,
                                withBorder: true,
                                borderColor: Palette.background,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
