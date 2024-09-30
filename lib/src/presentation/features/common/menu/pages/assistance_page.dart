// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/attendance_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/datetime_extension.dart';
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/dummies_data.dart';
import 'package:asco/src/data/models/classrooms/classroom.dart';
import 'package:asco/src/presentation/features/common/menu/providers/classroom_meetings_provider.dart';
import 'package:asco/src/presentation/features/common/menu/providers/student_control_cards_provider.dart';
import 'package:asco/src/presentation/shared/widgets/asco_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/cards/attendance_card.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/custom_icon_button.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/github_repository_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class AssistancePage extends StatelessWidget {
  final Classroom classroom;

  const AssistancePage({super.key, required this.classroom});

  @override
  Widget build(BuildContext context) {
    final roleId = MapHelper.roleMap[CredentialSaver.credential?.role];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const AscoAppBar(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: Palette.purple2,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.antiAlias,
                      children: [
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: RotatedBox(
                            quarterTurns: -2,
                            child: SvgAsset(
                              AssetPath.getVector('bg_attribute.svg'),
                              width: AppSize.getAppWidth(context) / 3,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 28,
                            horizontal: 16,
                          ),
                          child: Text(
                            'Grup Asistensi 1',
                            style: textTheme.headlineSmall!.copyWith(
                              color: Palette.background,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: Palette.background,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          child: SvgAsset(
                            AssetPath.getVector('bg_attribute_3.svg'),
                            width: AppSize.getAppWidth(context) / 3,
                          ),
                        ),
                        ListTile(
                          horizontalTitleGap: 10,
                          minVerticalPadding: 24,
                          contentPadding: const EdgeInsets.only(
                            left: 16,
                            right: 12,
                          ),
                          leading: const CircleNetworkImage(
                            imageUrl: null,
                            size: 56,
                            withBorder: true,
                            borderColor: Palette.purple3,
                            borderWidth: 1.5,
                          ),
                          title: Text(
                            'Asisten',
                            style: textTheme.bodySmall!.copyWith(
                              color: Palette.purple3,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'Rafly Ramadhani Putra',
                            style: textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: roleId == 1
                              ? CustomIconButton(
                                  'github_filled.svg',
                                  color: Palette.purple2,
                                  size: 24,
                                  tooltip: 'Github',
                                  onPressed: () => FunctionHelper.openUrl(
                                    'https://github.com/fajri-rasid1st',
                                  ),
                                )
                              : InkWellContainer(
                                  radius: 99,
                                  color: Palette.purple2,
                                  padding: const EdgeInsets.all(2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
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
                                        'edit_outlined.svg',
                                        size: 20,
                                        tooltip: 'Edit',
                                        onPressed: () => showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => const GithubRepositoryDialog(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SectionTitle(
              text: 'Praktikan',
              trailingText: 'Lihat Detail',
              onPressedTrailingText: () => navigatorKey.currentState!.pushNamed(
                practitionerListRoute,
                arguments: 'Grup Asistensi 1',
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List<Padding>.generate(
                  studentDummies.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      right: index == studentDummies.length - 1 ? 0 : 10,
                    ),
                    child: SizedBox(
                      width: 64,
                      child: Column(
                        children: [
                          CircleNetworkImage(
                            imageUrl: studentDummies[index].profilePicturePath,
                            size: 56,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${studentDummies[index].nickname}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (roleId == 1)
              Consumer(
                builder: (context, ref, child) {
                  final cards = ref.watch(StudentControlCardsProvider(classroom.practicum!.id!));

                  ref.listen(StudentControlCardsProvider(classroom.practicum!.id!), (_, state) {
                    state.whenOrNull(error: context.responseError);
                  });

                  return cards.when(
                    loading: () => const LoadingIndicator(),
                    error: (_, __) => const SizedBox(),
                    data: (cards) {
                      if (cards == null) return const SizedBox();

                      if (cards.isEmpty) {
                        return const CustomInformation(
                          title: 'Kartu kontrol masih kosong',
                          subtitle: 'Anda belum memiliki kartu kontrol',
                        );
                      }

                      return Column(
                        children: [
                          SectionTitle(
                            text: 'Kartu Kontrol',
                            trailingText: '${cards.length} Materi',
                          ),
                          ...List<Padding>.generate(
                            cards.length,
                            (index) {
                              final card = cards[index];
                              final bottom = index == cards.length - 1 ? 56.0 : 10.0;

                              return Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, bottom),
                                child: AttendanceCard(
                                  attendanceType: AttendanceType.assistance,
                                  assistanceStatus: [
                                    card.firstAssistanceStatus!,
                                    card.secondAssistanceStatus!,
                                  ],
                                  meeting: card.meeting!,
                                  locked: card.meeting!.date! > DateTime.now().secondsSinceEpoch,
                                  onTap: () => navigatorKey.currentState!.pushNamed(
                                    studentAssistanceDetailRoute,
                                    arguments: card.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            else
              Consumer(
                builder: (context, ref, child) {
                  final meetings = ref.watch(ClassroomMeetingsProvider(classroom.id!));

                  ref.listen(ClassroomMeetingsProvider(classroom.id!), (_, state) {
                    state.whenOrNull(error: context.responseError);
                  });

                  return meetings.when(
                    loading: () => const LoadingIndicator(),
                    error: (_, __) => const SizedBox(),
                    data: (meetings) {
                      if (meetings == null) return const SizedBox();

                      if (meetings.isEmpty) {
                        return const CustomInformation(
                          title: 'Pertemuan masih kosong',
                          subtitle: 'Belum terdapat pertemuan pada praktikum ini',
                        );
                      }

                      return Column(
                        children: [
                          SectionTitle(
                            text: 'Kartu Kontrol',
                            trailingText: '${meetings.length} Materi',
                          ),
                          ...List<Padding>.generate(
                            meetings.length,
                            (index) {
                              final meeting = meetings[index];
                              final bottom = index == meetings.length - 1 ? 56.0 : 10.0;

                              return Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, bottom),
                                child: AttendanceCard(
                                  attendanceType: AttendanceType.meeting,
                                  meetingStatus: const {
                                    'Selesai': 0,
                                    'Belum': 5,
                                  },
                                  meeting: meeting,
                                  locked: meeting.date! > DateTime.now().secondsSinceEpoch,
                                  onTap: () => navigatorKey.currentState!.pushNamed(
                                    assistantAssistanceDetailRoute,
                                    arguments: meeting.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  final String trailingText;
  final VoidCallback? onPressedTrailingText;

  const SectionTitle({
    super.key,
    required this.text,
    required this.trailingText,
    this.onPressedTrailingText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onPressedTrailingText,
            child: Text(
              trailingText,
              style: textTheme.bodySmall!.copyWith(
                color: Palette.purple3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
