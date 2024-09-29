// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/number_extension.dart';
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/features/student/meeting/pages/student_meeting_detail_page.dart';
import 'package:asco/src/presentation/features/student/meeting/providers/student_attendances_provider.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';

class StudentMeetingHistoryPage extends StatelessWidget {
  final String practicumId;

  const StudentMeetingHistoryPage({super.key, required this.practicumId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Riwayat Pertemuan',
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final attendances = ref.watch(StudentAttendancesProvider(practicumId));

          ref.listen(StudentAttendancesProvider(practicumId), (_, state) {
            state.whenOrNull(error: context.responseError);
          });

          return attendances.when(
            loading: () => const LoadingIndicator(),
            error: (_, __) => const SizedBox(),
            data: (attendances) {
              if (attendances == null) return const SizedBox();

              if (attendances.isEmpty) {
                return const CustomInformation(
                  title: 'Riwayat pertemuan kosong',
                  subtitle: 'Belum ada pertemuan yang kamu lalui',
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) {
                  final attendance = attendances[index];

                  return InkWellContainer(
                    radius: 99,
                    color: Palette.background,
                    padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                    onTap: () => navigatorKey.currentState!.pushNamed(
                      studentMeetingDetailRoute,
                      arguments: StudentMeetingDetailPageArgs(
                        id: attendance.meeting!.id!,
                        attendance: attendance,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleBorderContainer(
                          size: 60,
                          withBorder: false,
                          fillColor: MapHelper.attendanceColorMap[attendance.status],
                          child: Text(
                            '#${attendance.meeting?.number}',
                            style: textTheme.titleMedium!.copyWith(
                              color: Palette.background,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${attendance.meeting?.lesson}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.titleSmall!.copyWith(
                                  color: Palette.purple2,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                '${MapHelper.readableAttendanceMap[attendance.status]}',
                                style: textTheme.bodySmall!.copyWith(
                                  color: MapHelper.attendanceColorMap[attendance.status],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                attendance.status == 'ATTEND'
                                    ? 'Waktu absensi ${attendance.time?.to24TimeFormat()}, ${attendance.meeting?.date?.toDateTimeFormat('d/M/yyyy')}'
                                    : attendance.note != null && attendance.note!.isNotEmpty
                                        ? attendance.note!
                                        : 'Tidak ada keterangan',
                                style: textTheme.labelSmall!.copyWith(
                                  color: Palette.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemCount: attendances.length,
              );
            },
          );
        },
      ),
    );
  }
}
