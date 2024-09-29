// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/action_type.dart';
import 'package:asco/core/enums/user_badge_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/number_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/features/admin/classroom/providers/classroom_actions_provider.dart';
import 'package:asco/src/presentation/features/admin/classroom/providers/classroom_detail_provider.dart';
import 'package:asco/src/presentation/shared/pages/select_users_page.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';
import 'package:asco/src/presentation/shared/widgets/practicum_badge_image.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class ClassroomDetailPage extends ConsumerWidget {
  final ClassroomDetailPageArgs args;

  const ClassroomDetailPage({super.key, required this.args});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classroom = ref.watch(ClassroomDetailProvider(args.id));

    ref.listen(ClassroomDetailProvider(args.id), (_, state) {
      state.whenOrNull(error: context.responseError);
    });

    ref.listen(classroomActionsProvider, (_, state) {
      state.when(
        loading: () => context.showLoadingDialog(),
        error: (error, stackTrace) {
          navigatorKey.currentState!.pop();

          context.responseError(error, stackTrace);
        },
        data: (data) {
          if (data.action == ActionType.delete) {
            navigatorKey.currentState!.pop();
          }

          if (data.message != null) {
            navigatorKey.currentState!.pop();

            ref.invalidate(classroomDetailProvider);

            context.showSnackBar(
              title: 'Berhasil',
              message: data.message!,
            );
          }
        },
      );
    });

    return classroom.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (classroom) {
        if (classroom == null) return const Scaffold();

        return Scaffold(
          appBar: CustomAppBar(
            title: '${args.practicum.course} ${classroom.name}',
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Palette.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        child: SvgAsset(
                          AssetPath.getVector('bg_attribute_3.svg'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PracticumBadgeImage(
                              badgeUrl: '${args.practicum.badgePath}',
                              width: 58,
                              height: 63,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Kelas ${classroom.name}',
                              style: textTheme.headlineSmall!.copyWith(
                                color: Palette.purple2,
                              ),
                            ),
                            Text(
                              '${args.practicum.course}',
                              style: textTheme.bodyLarge!.copyWith(
                                color: Palette.purple3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Setiap ${MapHelper.readableDayMap[classroom.meetingDay]}, Pukul ${classroom.startTime?.to24TimeFormat()} - ${classroom.endTime?.to24TimeFormat()}',
                              style: textTheme.bodySmall!.copyWith(
                                color: Palette.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SectionHeader(
                  title: 'Peserta',
                  showDivider: true,
                  showActionButton: true,
                  onPressedActionButton: () async {
                    final removedUsers = [...?classroom.students];

                    final result = await navigatorKey.currentState!.pushNamed(
                      selectUsersRoute,
                      arguments: SelectUsersPageArgs(
                        title: 'Pilih Peserta Kelas ${classroom.name}',
                        role: 'STUDENT',
                        removedUsers: removedUsers,
                      ),
                    );

                    if (result != null && (result as List<Profile>).isNotEmpty) {
                      assignStudents(ref, result);
                    }
                  },
                ),
                if (classroom.students!.isEmpty)
                  const CustomInformation(
                    title: 'Peserta kelas kosong',
                    subtitle: 'Tambahkan peserta dengan menekan tombol "Tambah"',
                  )
                else
                  ...List<Padding>.generate(
                    classroom.students!.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: index == classroom.students!.length - 1 ? 0 : 10,
                      ),
                      child: UserCard(
                        user: classroom.students![index],
                        badgeType: UserBadgeType.text,
                        showDeleteButton: true,
                        onPressedDeleteButton: () => context.showConfirmDialog(
                          title: 'Keluarkan Peserta?',
                          message: 'Anda yakin ingin mengeluarkan peserta ini?',
                          primaryButtonText: 'Keluarkan',
                          onPressedPrimaryButton: () {
                            removeStudent(ref, classroom.students![index]);
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void assignStudents(WidgetRef ref, List<Profile> students) {
    ref.read(classroomActionsProvider.notifier).addStudentsToClassroom(
          args.id,
          students: students.map((e) => e.username!).toList(),
        );
  }

  void removeStudent(WidgetRef ref, Profile student) {
    ref.read(classroomActionsProvider.notifier).removeStudentFromClassroom(
          args.id,
          username: student.username!,
        );
  }
}

class ClassroomDetailPageArgs {
  final String id;
  final Practicum practicum;

  const ClassroomDetailPageArgs({
    required this.id,
    required this.practicum,
  });
}
