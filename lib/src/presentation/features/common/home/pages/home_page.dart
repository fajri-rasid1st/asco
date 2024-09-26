// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/number_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/classrooms/classroom.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/presentation/features/common/home/providers/student_classrooms_provider.dart';
import 'package:asco/src/presentation/features/common/initial/providers/log_out_provider.dart';
import 'package:asco/src/presentation/shared/features/practicum/providers/practicums_provider.dart';
import 'package:asco/src/presentation/shared/pages/select_classroom_page.dart';
import 'package:asco/src/presentation/shared/widgets/asco_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
import 'package:asco/src/presentation/shared/widgets/drawer_menu/drawer_menu_widget.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';
import 'package:asco/src/presentation/shared/widgets/practicum_badge_image.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

final selectedMenuProvider = StateProvider.autoDispose<int>((ref) => -1);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleId = MapHelper.getRoleId(CredentialSaver.credential?.role);
    final selectedIndex = ref.watch(selectedMenuProvider);

    ref.listen(
      selectedMenuProvider,
      (previous, next) {
        if (next == -2) {
          ref.read(selectedMenuProvider.notifier).state = -1;

          navigatorKey.currentState!.pushNamed(
            roleId == 1 ? studentProfileRoute : assistantProfileRoute,
          );
        }

        if (next == 6) {
          ref.read(selectedMenuProvider.notifier).state = -1;

          context.showConfirmDialog(
            title: 'Log Out?',
            message: 'Dengan ini seluruh sesi Anda akan berakhir.',
            primaryButtonText: 'Log Out',
            onPressedPrimaryButton: () => ref.read(logOutProvider.notifier).logOut(),
          );
        }
      },
    );

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

    return DrawerMenuWidget(
      isMainMenu: false,
      showNavigationBar: false,
      selectedIndex: selectedIndex,
      onSelected: (index) => ref.read(selectedMenuProvider.notifier).state = index,
      child: Scaffold(
        body: SafeArea(
          child: Consumer(
            builder: (context, ref, child) {
              if (roleId == 1) {
                final classrooms = ref.watch(studentClassroomsProvider);

                ref.listen(studentClassroomsProvider, (_, state) {
                  state.whenOrNull(error: context.responseError);
                });

                return classrooms.when(
                  loading: () => const LoadingIndicator(),
                  error: (_, __) => const SizedBox(),
                  data: (classrooms) {
                    if (classrooms == null) return const SizedBox();

                    if (classrooms.isEmpty) {
                      return const CustomInformation(
                        title: 'Kelas masih kosong',
                        subtitle: 'Kamu belum terdaftar pada kelas manapun',
                      );
                    }

                    return ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        child!,
                        ...List<Padding>.generate(
                          classrooms.length,
                          (index) => Padding(
                            padding: EdgeInsets.only(
                              bottom: index == classrooms.length - 1 ? 0 : 12,
                            ),
                            child: CourseCard(
                              classroom: classrooms[index],
                              roleId: roleId,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                final practicums = ref.watch(practicumsProvider);

                ref.listen(practicumsProvider, (_, state) {
                  state.whenOrNull(error: context.responseError);
                });

                return practicums.when(
                  loading: () => const LoadingIndicator(),
                  error: (_, __) => const SizedBox(),
                  data: (practicums) {
                    if (practicums == null) return const SizedBox();

                    if (practicums.isEmpty) {
                      return const CustomInformation(
                        title: 'Praktikum masih kosong',
                        subtitle: 'Kamu belum terdaftar pada praktikum manapun',
                      );
                    }

                    return ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        child!,
                        ...List<Padding>.generate(
                          practicums.length,
                          (index) => Padding(
                            padding: EdgeInsets.only(
                              bottom: index == practicums.length - 1 ? 0 : 12,
                            ),
                            child: CourseCard(
                              practicum: practicums[index],
                              roleId: roleId,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: const Column(
              children: [
                AscoAppBar(),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Practicum? practicum;
  final Classroom? classroom;
  final int? roleId;

  const CourseCard({
    super.key,
    this.practicum,
    this.classroom,
    this.roleId,
  });

  @override
  Widget build(BuildContext context) {
    if (roleId == 1) {
      assert(classroom != null);
    } else {
      assert(practicum != null);
    }

    final totalStudents = classroom?.studentsCount ?? 0;

    return InkWellContainer(
      radius: 16,
      clipBehavior: Clip.antiAlias,
      onTap: () => roleId == 1
          ? navigatorKey.currentState!.pushNamedAndRemoveUntil(
              mainMenuRoute,
              (route) => false,
              arguments: classroom,
            )
          : navigatorKey.currentState!.pushNamed(
              selectClassroomRoute,
              arguments: SelectClassroomPageArgs(
                practicum: practicum!,
                onItemTapped: (classroom) => navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  mainMenuRoute,
                  (route) => false,
                  arguments: classroom.copyWith(practicum: practicum),
                ),
              ),
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
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              roleId == 1
                                  ? '${classroom?.practicum?.course} ${classroom?.name}'
                                  : '${practicum?.course}',
                              style: textTheme.titleLarge!.copyWith(
                                color: Palette.background,
                                fontWeight: FontWeight.w600,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              roleId == 1
                                  ? 'Setiap hari ${MapHelper.getReadableDay(classroom?.meetingDay)}, Pukul ${classroom?.startTime?.to24TimeFormat()} - ${classroom?.endTime?.to24TimeFormat()}'
                                  : '${practicum?.classroomsLength} Kelas ● ${practicum?.meetingsLength} Pertemuan',
                              style: textTheme.bodySmall!.copyWith(
                                color: Palette.background,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      PracticumBadgeImage(
                        badgeUrl: roleId == 1
                            ? '${classroom?.practicum?.badgePath}'
                            : '${practicum?.badgePath}',
                        width: 44,
                        height: 48,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: List<Transform>.generate(
                      totalStudents >= 4 ? 4 : totalStudents,
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
                                    '+${totalStudents - 3}',
                                    style: textTheme.labelSmall!.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                            : const CircleNetworkImage(
                                imageUrl: null,
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
