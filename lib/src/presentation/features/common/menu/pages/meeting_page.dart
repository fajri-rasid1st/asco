// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/configs/api_configs.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/number_extension.dart';
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/classrooms/classroom.dart';
import 'package:asco/src/presentation/features/assistant/meeting/pages/assistant_meeting_detail_page.dart';
import 'package:asco/src/presentation/features/common/menu/providers/classroom_meetings_provider.dart';
import 'package:asco/src/presentation/features/student/meeting/pages/student_meeting_detail_page.dart';
import 'package:asco/src/presentation/providers/manual_providers/ascending_provider.dart';
import 'package:asco/src/presentation/shared/widgets/asco_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/cards/meeting_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_icon_button.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';
import 'package:asco/src/presentation/shared/widgets/practicum_badge_image.dart';

class MeetingPage extends StatelessWidget {
  final Classroom classroom;

  const MeetingPage({super.key, required this.classroom});

  @override
  Widget build(BuildContext context) {
    final roleId = MapHelper.roleMap[CredentialSaver.credential?.role];

    final meetingMenuCards = [
      MeetingMenuCard(
        title: 'Tata Tertib',
        strokeColor: Palette.purple3,
        fillColor: Palette.purple4,
        icon: Icons.list_alt_outlined,
        onTap: () => context.openFile(
          name: 'Tata Tertib',
          path: null,
        ),
      ),
      MeetingMenuCard(
        title: 'Kontrak Kuliah',
        strokeColor: Palette.salmon1,
        fillColor: Palette.salmon2,
        icon: Icons.description_outlined,
        onTap: () => context.openFile(
          name: 'Kontrak Kuliah',
          path: '${ApiConfigs.baseFileUrl}/${classroom.practicum?.courseContractPath}',
        ),
      ),
      if (roleId == 1)
        MeetingMenuCard(
          title: 'Riwayat Pertemuan',
          strokeColor: Palette.azure1,
          fillColor: Palette.azure2,
          icon: Icons.history_outlined,
          onTap: () => navigatorKey.currentState!.pushNamed(
            studentMeetingHistoryRoute,
            arguments: classroom.practicum?.id,
          ),
        )
      else
        MeetingMenuCard(
          title: 'Jadwal Pemateri',
          strokeColor: Palette.azure1,
          fillColor: Palette.azure2,
          icon: Icons.calendar_today_outlined,
          onTap: () => navigatorKey.currentState!.pushNamed(
            assistantMeetingScheduleRoute,
            arguments: classroom.practicum?.id,
          ),
        ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const AscoAppBar(),
            const SizedBox(height: 24),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  bottom: -8,
                  child: Container(
                    width: AppSize.getAppWidth(context) - 80,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Palette.purple2,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Palette.purple3,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${classroom.practicum?.course} ${classroom.name}',
                                style: textTheme.titleLarge!.copyWith(
                                  color: Palette.background,
                                  fontWeight: FontWeight.w600,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Setiap hari ${MapHelper.readableDayMap[classroom.meetingDay]}, Pukul ${classroom.startTime?.to24TimeFormat()} - ${classroom.endTime?.to24TimeFormat()}',
                                style: textTheme.bodySmall!.copyWith(
                                  color: Palette.scaffoldBackground,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        PracticumBadgeImage(
                          badgeUrl: '${classroom.practicum?.badgePath}',
                          width: 44,
                          height: 48,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 14,
                childAspectRatio: 16 / 7,
              ),
              itemBuilder: (context, index) => meetingMenuCards[index],
              itemCount: meetingMenuCards.length,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Pertemuan',
                    style: textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Consumer(
                  builder: (context, ref, child) {
                    return CustomIconButton(
                      'arrow_sort_outlined.svg',
                      color: Palette.primaryText,
                      size: 20,
                      tooltip: 'Urutkan',
                      onPressed: () => sortMeetings(ref),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 6),
            Consumer(
              builder: (context, ref, child) {
                final asc = ref.watch(ascendingProvider);

                final meetings = ref.watch(
                  ClassroomMeetingsProvider(
                    classroom.id!,
                    asc: asc,
                  ),
                );

                ref.listen(
                  ClassroomMeetingsProvider(
                    classroom.id!,
                    asc: asc,
                  ),
                  (_, state) => state.whenOrNull(error: context.responseError),
                );

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
                      children: List<Padding>.generate(
                        meetings.length,
                        (index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: index == meetings.length - 1 ? 56 : 10,
                          ),
                          child: MeetingCard(
                            meeting: meetings[index],
                            onTap: () => navigatorKey.currentState!.pushNamed(
                              roleId == 1 ? studentMeetingDetailRoute : assistantMeetingDetailRoute,
                              arguments: roleId == 1
                                  ? StudentMeetingDetailPageArgs(
                                      id: meetings[index].id!,
                                    )
                                  : AssistantMeetingDetailPageArgs(
                                      meeting: meetings[index],
                                      classroom: classroom,
                                    ),
                            ),
                          ),
                        ),
                      ),
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

  void sortMeetings(WidgetRef ref) {
    ref.read(ascendingProvider.notifier).update((state) => !state);
  }
}

class MeetingMenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color strokeColor;
  final Color fillColor;
  final VoidCallback onTap;

  const MeetingMenuCard({
    super.key,
    required this.title,
    required this.icon,
    required this.strokeColor,
    required this.fillColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 12,
      color: Palette.background,
      padding: const EdgeInsets.all(10),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 2,
                color: strokeColor,
              ),
            ),
            child: Icon(
              icon,
              color: Palette.background,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall!.copyWith(
                color: strokeColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
