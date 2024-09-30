// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/features/common/initial/providers/credential_provider.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class DrawerMenuContent extends StatelessWidget {
  final bool isMainMenu;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const DrawerMenuContent({
    super.key,
    required this.isMainMenu,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      DrawerMenuItem(
        title: 'Beranda',
        selectedIcon: AssetPath.getIcon('home_filled.svg'),
        unselectedIcon: AssetPath.getIcon('home_outlined.svg'),
      ),
      DrawerMenuItem(
        title: 'Pertemuan',
        selectedIcon: AssetPath.getIcon('class_filled.svg'),
        unselectedIcon: AssetPath.getIcon('class_outlined.svg'),
      ),
      DrawerMenuItem(
        title: 'Asistensi',
        selectedIcon: AssetPath.getIcon('assistance_filled.svg'),
        unselectedIcon: AssetPath.getIcon('assistance_outlined.svg'),
      ),
      DrawerMenuItem(
        title: 'Leaderboard',
        selectedIcon: AssetPath.getIcon('leaderboard_filled.svg'),
        unselectedIcon: AssetPath.getIcon('leaderboard_outlined.svg'),
      ),
      DrawerMenuItem(
        title: 'Extras',
        selectedIcon: AssetPath.getIcon('extras_filled.svg'),
        unselectedIcon: AssetPath.getIcon('extras_outlined.svg'),
      ),
      DrawerMenuItem(
        title: 'People',
        selectedIcon: AssetPath.getIcon('people_filled.svg'),
        unselectedIcon: AssetPath.getIcon('people_outlined.svg'),
      ),
      DrawerMenuItem(
        title: 'Keluar',
        selectedIcon: AssetPath.getIcon('logout_outlined.svg'),
        unselectedIcon: AssetPath.getIcon('logout_outlined.svg'),
      ),
    ];

    return Container(
      width: AppSize.getAppWidth(context) * .7,
      color: Palette.black2,
      child: Column(
        children: [
          UserProfileListTile(onTap: () => onSelected(-2)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 0, 8),
                  child: Text(
                    "JELAJAH",
                    style: textTheme.bodySmall!.copyWith(
                      color: Palette.purple4,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 0, 4),
                  child: Divider(
                    color: Palette.divider.withOpacity(.3),
                    height: 1,
                  ),
                ),
                DrawerMenuListTile(
                  item: menuItems[0],
                  isSelected: selectedIndex == -1,
                  onTap: () => onSelected(-1),
                ),
                if (isMainMenu)
                  ...List<DrawerMenuListTile>.generate(
                    5,
                    (index) => DrawerMenuListTile(
                      item: menuItems[index + 1],
                      isSelected: selectedIndex == index,
                      onTap: () => onSelected(index),
                    ),
                  ),
                if (!isMainMenu)
                  DrawerMenuListTile(
                    item: menuItems[menuItems.length - 1],
                    isSelected: selectedIndex == menuItems.length - 1,
                    onTap: () => onSelected(menuItems.length - 1),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserProfileListTile extends StatelessWidget {
  final VoidCallback onTap;

  const UserProfileListTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 36, 20),
      child: GestureDetector(
        onTap: onTap,
        child: Consumer(
          builder: (context, ref, child) {
            final profile = ref.watch(credentialProvider);

            ref.listen(credentialProvider, (_, state) {
              state.whenOrNull(error: context.responseError);
            });

            return profile.when(
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
              data: (profile) {
                if (profile == null) return const SizedBox();

                return Row(
                  children: [
                    CircleNetworkImage(
                      imageUrl: profile.profilePicturePath,
                      size: 40,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${profile.fullname}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleSmall!.copyWith(
                              color: Palette.background,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${profile.username}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall!.copyWith(
                              color: Palette.purple4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class DrawerMenuListTile extends StatelessWidget {
  final DrawerMenuItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const DrawerMenuListTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          width: isSelected ? AppSize.getAppWidth(context) * .7 : 0,
          height: 56,
          left: 0,
          duration: kThemeAnimationDuration,
          child: Container(
            decoration: const BoxDecoration(
              color: Palette.purple3,
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(8),
              ),
            ),
          ),
        ),
        ListTile(
          horizontalTitleGap: 14,
          leading: SvgAsset(
            isSelected ? item.selectedIcon : item.unselectedIcon,
            color: Palette.background,
            width: 22,
          ),
          title: Text(
            item.title,
            style: textTheme.labelLarge!.copyWith(
              color: Palette.background,
            ),
          ),
          onTap: onTap,
        ),
      ],
    );
  }
}

class DrawerMenuItem {
  final String title;
  final String selectedIcon;
  final String unselectedIcon;

  DrawerMenuItem({
    required this.title,
    required this.selectedIcon,
    required this.unselectedIcon,
  });
}
