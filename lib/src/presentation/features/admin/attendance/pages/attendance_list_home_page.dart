// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/attendance_type.dart';
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/extensions/button_extension.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/helpers/excel_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/services/file_service.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/presentation/features/admin/attendance/providers/attendance_meetings_provider.dart';
import 'package:asco/src/presentation/shared/widgets/cards/attendance_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class AttendanceListHomePage extends StatelessWidget {
  final Practicum practicum;

  const AttendanceListHomePage({super.key, required this.practicum});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '${practicum.course}',
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final meetings = ref.watch(AttendanceMeetingsProvider(practicum.id!));

          ref.listen(AttendanceMeetingsProvider(practicum.id!), (_, state) {
            state.whenOrNull(
              error: (error, _) {
                if ('$error' == kNoInternetConnection) {
                  context.showNoConnectionSnackBar();
                } else {
                  context.showSnackBar(
                    title: 'Terjadi Kesalahan',
                    message: '$error',
                    type: SnackBarType.error,
                  );
                }
              },
            );
          });

          return meetings.when(
            loading: () => const LoadingIndicator(),
            error: (_, __) => const SizedBox(),
            data: (meetings) {
              if (meetings == null) return const SizedBox();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    FilledButton.icon(
                      onPressed: () => exportToExcel(context),
                      icon: SvgAsset(
                        AssetPath.getIcon('file_excel_outlined.svg'),
                      ),
                      label: const Text('Export ke Excel'),
                    ).fullWidth(),
                    const SizedBox(height: 16),
                    ...List<Padding>.generate(
                      meetings.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          bottom: index == meetings.length - 1 ? 0 : 10,
                        ),
                        child: AttendanceCard(
                          meeting: Meeting(
                            number: meetings[index].number,
                            lesson: meetings[index].lesson,
                            date: meetings[index].meetingDate,
                          ),
                          attendanceType: AttendanceType.meeting,
                          meetingStatus: {
                            'Hadir': meetings[index].attend!,
                            'Alpa': meetings[index].absent!,
                            'Sakit': meetings[index].sick!,
                            'Izin': meetings[index].permission!,
                          },
                          onTap: () => navigatorKey.currentState!.pushNamed(attendanceDetailRoute),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> exportToExcel(BuildContext context) async {
    final excelBytes = ExcelHelper.createAttendanceData(
      data: [
        {
          'username': 'H071211074',
          'fullname': 'Wd. Ananda Lesmono',
          'attendanceStatus': ['present', 'sick'],
        },
        {
          'username': 'H071211051',
          'fullname': 'Febi Fiantika',
          'attendanceStatus': ['absent', 'excused'],
        },
      ],
      totalAttendances: 2,
    );

    if (excelBytes != null) {
      if (await FileService.saveFileFromRawBytes(
        excelBytes,
        name: 'Kehadiran_Pemrograman_Mobile_A.xlsx',
      )) {
        if (!context.mounted) return;

        context.showSnackBar(
          title: 'Berhasil',
          message: 'Data kehadiran kelas berhasil diekspor pada folder Download.',
        );

        return;
      }
    }

    if (!context.mounted) return;

    context.showSnackBar(
      title: 'Terjadi Kesalahan',
      message: 'Data kehadiran kelas gagal diekspor.',
      type: SnackBarType.error,
    );
  }
}
