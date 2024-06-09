// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/pages/select_classroom_page.dart';
import 'package:asco/src/presentation/shared/pages/select_practicum_page.dart';
import 'package:asco/src/presentation/shared/widgets/asco_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final adminMenuList = [
      AdminMenu(
        title: 'Data Pengguna',
        icon: Icons.person_rounded,
        onTap: () => navigatorKey.currentState!.pushNamed(userListHomeRoute),
      ),
      AdminMenu(
        title: 'Data Praktikum',
        icon: Icons.data_object_rounded,
        onTap: () => navigatorKey.currentState!.pushNamed(practicumListHomeRoute),
      ),
      AdminMenu(
        title: 'Data Kelas & Pertemuan',
        icon: Icons.meeting_room_rounded,
        onTap: () => navigatorKey.currentState!.pushNamed(
          selectPracticumRoute,
          arguments: const SelectPracticumPageArgs(showClassroomAndMeetingButtons: true),
        ),
      ),
      AdminMenu(
        title: 'Data Absensi',
        icon: Icons.menu_book_rounded,
        onTap: () => navigatorKey.currentState!.pushNamed(
          selectPracticumRoute,
          arguments: SelectPracticumPageArgs(
            onItemTapped: () => navigatorKey.currentState!.pushNamed(
              selectClassroomRoute,
              arguments: SelectClassroomPageArgs(
                title: 'Pemrograman Mobile',
                onItemTapped: () => navigatorKey.currentState!.pushNamed(attendanceListHomePage),
              ),
            ),
          ),
        ),
      ),
      AdminMenu(
        title: 'Rekap Nilai',
        icon: Icons.format_list_numbered_rounded,
        onTap: () => navigatorKey.currentState!.pushNamed(
          selectPracticumRoute,
          arguments: SelectPracticumPageArgs(
            onItemTapped: () => navigatorKey.currentState!.pushNamed(scoreListHomePage),
          ),
        ),
      ),
      AdminMenu(
        title: 'Grup Asistensi',
        icon: Icons.group_rounded,
        onTap: () {},
      ),
      AdminMenu(
        title: 'Kartu Kontrol',
        icon: Icons.featured_play_list_rounded,
        onTap: () {},
      ),
      AdminMenu(
        title: 'Tata Tertib Lab',
        icon: Icons.info_rounded,
        onTap: () {},
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const AscoAppBar(),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Palette.background,
                ),
                child: Row(
                  children: [
                    SvgAsset(
                      AssetPath.getVector('logo.svg'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Admin',
                            style: textTheme.bodySmall?.copyWith(
                              color: Palette.purple3,
                            ),
                          ),
                          Text(
                            'Koordinator Lab',
                            style: textTheme.titleMedium?.copyWith(
                              color: Palette.purple2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: () => context.showConfirmDialog(
                        title: 'Log Out?',
                        message: 'Dengan ini seluruh sesi Anda akan berakhir.',
                        primaryButtonText: 'Log Out',
                        onPressedPrimaryButton: () {
                          navigatorKey.currentState!.pushNamedAndRemoveUntil(
                            onBoardingRoute,
                            (route) => false,
                          );
                        },
                      ),
                      icon: const Icon(Icons.exit_to_app_rounded),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: adminMenuList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.25,
                ),
                itemBuilder: (context, index) {
                  return AdminMenuCard(
                    menu: adminMenuList[index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminMenuCard extends StatelessWidget {
  final AdminMenu menu;

  const AdminMenuCard({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      color: Palette.background,
      radius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      border: Border.all(
        width: 1,
        color: Palette.purple2,
      ),
      boxShadow: const [
        BoxShadow(
          offset: Offset(3, 2),
          color: Palette.purple2,
        ),
      ],
      onTap: menu.onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Palette.purple3,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              menu.icon,
              color: Palette.background,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            menu.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Palette.purple2,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class AdminMenu {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  AdminMenu({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
