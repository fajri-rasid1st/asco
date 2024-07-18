// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/string_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/features/common/initial/providers/log_out_provider.dart';
import 'package:asco/src/presentation/shared/pages/select_practicum_page.dart';
import 'package:asco/src/presentation/shared/widgets/asco_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class AdminHomePage extends ConsumerWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminMenuCards = [
      AdminMenuCard(
        title: 'Data Pengguna',
        icon: Icons.person_rounded,
        onTap: () => navigatorKey.currentState!.pushNamed(userListHomeRoute),
      ),
      AdminMenuCard(
        title: 'Data Praktikum',
        icon: Icons.data_object_rounded,
        onTap: () => navigatorKey.currentState!.pushNamed(practicumListHomeRoute),
      ),
      AdminMenuCard(
        title: 'Data Kelas & Pertemuan',
        icon: Icons.meeting_room_rounded,
        onTap: () => navigatorKey.currentState!.pushNamed(
          selectPracticumRoute,
          arguments: const SelectPracticumPageArgs(showClassroomAndMeetingButtons: true),
        ),
      ),
      AdminMenuCard(
        title: 'Data Absensi',
        icon: Icons.menu_book_rounded,
        onTap: () => navigatorKey.currentState!.pushNamed(
          selectPracticumRoute,
          arguments: SelectPracticumPageArgs(
            onItemTapped: (_) => navigatorKey.currentState!.pushNamed(
              selectClassroomRoute,
              // arguments: SelectClassroomPageArgs(
              //   title: 'Pemrograman Mobile',
              //   onItemTapped: () => navigatorKey.currentState!.pushNamed(attendanceListHomeRoute),
              // ),
            ),
          ),
        ),
      ),
      AdminMenuCard(
        title: 'Rekap Nilai',
        icon: Icons.format_list_numbered_rounded,
        onTap: () => navigatorKey.currentState!.pushNamed(
          selectPracticumRoute,
          arguments: SelectPracticumPageArgs(
            onItemTapped: (_) => navigatorKey.currentState!.pushNamed(scoreRecapListHomeRoute),
          ),
        ),
      ),
      AdminMenuCard(
        title: 'Grup Asistensi',
        icon: Icons.group_rounded,
        onTap: () => navigatorKey.currentState!.pushNamed(
          selectPracticumRoute,
          arguments: SelectPracticumPageArgs(
            onItemTapped: (practicum) => navigatorKey.currentState!.pushNamed(
              assistanceGroupListHomeRoute,
              arguments: practicum,
            ),
          ),
        ),
      ),
      AdminMenuCard(
        title: 'Kartu Kontrol',
        icon: Icons.featured_play_list_rounded,
        onTap: () => navigatorKey.currentState!.pushNamed(
          selectPracticumRoute,
          arguments: SelectPracticumPageArgs(
            onItemTapped: (practicum) => navigatorKey.currentState!.pushNamed(
              controlCardListHomeRoute,
              arguments: practicum,
            ),
          ),
        ),
      ),
      AdminMenuCard(
        title: 'Tata Tertib Lab',
        icon: Icons.info_rounded,
        onTap: () => navigatorKey.currentState!.pushNamed(labRulesRoute),
      ),
    ];

    ref.listen(logOutProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) => context.showSnackBar(
          title: 'Terjadi Kesalahan',
          message: '$error',
          type: SnackBarType.error,
        ),
        data: (data) {
          if (data != null) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
              onBoardingRoute,
              (route) => false,
            );
          }
        },
      );
    });

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
                            '${CredentialSaver.credential?.role?.toCapitalize()}',
                            style: textTheme.bodySmall!.copyWith(
                              color: Palette.purple3,
                            ),
                          ),
                          Text(
                            'Koordinator Lab',
                            style: textTheme.titleMedium!.copyWith(
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
                        onPressedPrimaryButton: () => ref.read(logOutProvider.notifier).logOut(),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.25,
                ),
                itemBuilder: (context, index) => adminMenuCards[index],
                itemCount: adminMenuCards.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminMenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const AdminMenuCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 12,
      color: Palette.background,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      border: Border.all(
        color: Palette.purple2,
      ),
      boxShadow: const [
        BoxShadow(
          offset: Offset(3, 2),
          color: Palette.purple2,
        ),
      ],
      onTap: onTap,
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
              icon,
              color: Palette.background,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium!.copyWith(
              color: Palette.purple2,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
