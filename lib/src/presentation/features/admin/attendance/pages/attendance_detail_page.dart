// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/user_badge_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/data/models/attendances/attendance_meeting.dart';
import 'package:asco/src/presentation/shared/features/meeting/providers/meeting_attendances_provider.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';

class AttendanceDetailPage extends ConsumerWidget {
  final AttendanceMeeting attendanceMeeting;

  const AttendanceDetailPage({super.key, required this.attendanceMeeting});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendances = ref.watch(MeetingAttendancesProvider(attendanceMeeting.id!));

    ref.listen(MeetingAttendancesProvider(attendanceMeeting.id!), (_, state) {
      state.whenOrNull(error: context.responseError);
    });

    return attendances.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (attendances) {
        if (attendances == null) return const Scaffold();

        if (attendances.isEmpty) {
          return CustomInformation(
            title: 'Data kehadiran kosong',
            subtitle: 'Belum ada data kehadiran pada pertemuan ${attendanceMeeting.number}',
            withScaffold: true,
          );
        }

        return Scaffold(
          appBar: CustomAppBar(
            title: 'Absensi - Pertemuan ${attendanceMeeting.number}',
          ),
          body: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List<Flexible>.generate(
                      MapHelper.readableAttendanceColorMap.length - 2,
                      (index) {
                        final label = MapHelper.readableAttendanceColorMap.keys.toList()[index];
                        final color = MapHelper.readableAttendanceColorMap.values.toList()[index];

                        return Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleBorderContainer(
                                size: 16,
                                withBorder: false,
                                fillColor: color,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  label,
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: index == attendances.length - 1 ? 0 : 10,
                      ),
                      child: UserCard(
                        user: attendances[index].student!,
                        badgeType: UserBadgeType.text,
                        trailing: CircleBorderContainer(
                          size: 28,
                          withBorder: false,
                          fillColor: MapHelper.attendanceColorMap[attendances[index].status],
                        ),
                      ),
                    ),
                    childCount: attendances.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
