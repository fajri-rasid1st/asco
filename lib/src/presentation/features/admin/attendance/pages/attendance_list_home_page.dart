// Dart imports:
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:excel/excel.dart';
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
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/attendances/attendance_meeting.dart';
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/presentation/features/admin/attendance/providers/attendance_meetings_provider.dart';
import 'package:asco/src/presentation/shared/features/meeting/providers/meeting_attendances_provider.dart';
import 'package:asco/src/presentation/shared/widgets/cards/attendance_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
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
          final attendanceMeetings = ref.watch(AttendanceMeetingsProvider(practicum.id!));

          ref.listen(AttendanceMeetingsProvider(practicum.id!), (_, state) {
            state.whenOrNull(error: context.responseError);
          });

          return attendanceMeetings.when(
            loading: () => const LoadingIndicator(),
            error: (_, __) => const SizedBox(),
            data: (attendanceMeetings) {
              if (attendanceMeetings == null) return const SizedBox();

              if (attendanceMeetings.isEmpty) {
                return const CustomInformation(
                  title: 'Data absensi kosong',
                  subtitle: 'Belum ada data absensi yang dapat ditampilkan',
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    FilledButton.icon(
                      onPressed: () => exportAttendanceToExcel(context, ref, attendanceMeetings),
                      icon: SvgAsset(
                        AssetPath.getIcon('file_excel_outlined.svg'),
                      ),
                      label: const Text('Export ke Excel'),
                    ).fullWidth(),
                    const SizedBox(height: 16),
                    ...List<Padding>.generate(
                      attendanceMeetings.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          bottom: index == attendanceMeetings.length - 1 ? 0 : 10,
                        ),
                        child: AttendanceCard(
                          attendanceType: AttendanceType.meeting,
                          meetingStatus: {
                            'Hadir': attendanceMeetings[index].attend!,
                            'Alpa': attendanceMeetings[index].absent!,
                            'Sakit': attendanceMeetings[index].sick!,
                            'Izin': attendanceMeetings[index].permission!,
                          },
                          meeting: Meeting(
                            number: attendanceMeetings[index].number,
                            lesson: attendanceMeetings[index].lesson,
                            date: attendanceMeetings[index].date,
                          ),
                          onTap: () => navigatorKey.currentState!.pushNamed(
                            attendanceDetailRoute,
                            arguments: attendanceMeetings[index],
                          ),
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

  Future<void> exportAttendanceToExcel(
    BuildContext context,
    WidgetRef ref,
    List<AttendanceMeeting> attendanceMeetings,
  ) async {
    try {
      context.showLoadingDialog();

      final excel = Excel.createExcel();

      for (var i = 0; i < attendanceMeetings.length; i++) {
        final attendances = await ref.watch(
          MeetingAttendancesProvider(attendanceMeetings[i].id!).future,
        );

        if (attendances == null) return;

        if (attendances.isNotEmpty) {
          ExcelHelper.insertAttendanceToExcel(
            excel: excel,
            sheetNumber: attendanceMeetings[i].number!,
            attendances: attendances,
          );

          if (i != attendanceMeetings.length - 1) {
            excel.copy(
              'Pertemuan ${attendanceMeetings[i].number}',
              'Pertemuan ${attendanceMeetings[i].number! + 1}',
            );
          }
        } else {
          excel.delete('Pertemuan ${attendanceMeetings[i].number}');
        }
      }

      final excelBytes = excel.save();

      if (excelBytes == null) return;

      final isSaved = await FileService.saveFileFromBytes(
        Uint8List.fromList(excelBytes),
        name: 'Kehadiran ${practicum.course}.xlsx',
      );

      if (!context.mounted) return;

      if (isSaved) {
        context.showSnackBar(
          title: 'Berhasil',
          message: 'Data kehadiran praktikum berhasil diekspor pada folder Download.',
        );
      } else {
        context.showSnackBar(
          title: 'Terjadi Kesalahan',
          message: 'Data kehadiran praktikum gagal diekspor.',
          type: SnackBarType.error,
        );
      }

      navigatorKey.currentState!.pop();
    } catch (e) {
      context.showSnackBar(
        title: 'Terjadi Kesalahan',
        message: 'Data kehadiran praktikum gagal diekspor.',
        type: SnackBarType.error,
      );

      navigatorKey.currentState!.pop();
    }
  }
}
