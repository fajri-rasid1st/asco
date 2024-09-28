// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/number_extension.dart';
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/core/services/file_service.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/data/models/attendances/attendance.dart';
import 'package:asco/src/presentation/features/student/meeting/providers/student_meeting_detail_provider.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';
import 'package:asco/src/presentation/shared/widgets/mentor_list_tile.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class StudentMeetingDetailPage extends ConsumerWidget {
  final StudentMeetingDetailPageArgs args;

  const StudentMeetingDetailPage({super.key, required this.args});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(StudentMeetingDetailProvider(args.id));

    ref.listen(StudentMeetingDetailProvider(args.id), (_, state) {
      state.whenOrNull(error: context.responseError);
    });

    return data.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (data) {
        final meeting = data.meeting;
        final score = data.score;

        if (meeting == null || score == null) return const Scaffold();

        // Is meeting already complete or not
        final completed = meeting.date! < DateTime.now().millisecondsSinceEpoch ~/ 1000;

        // Get quiz score in current meeting from list of quiz scores
        final quizzes = score.quizScores!.where((e) => e.meetingNumber == meeting.number);
        final quizScore = quizzes.isNotEmpty ? quizzes.first.quizScore! : 0.0;

        // Get response score in current meeting from list of response scores
        final responses = score.responseScores!.where((e) => e.meetingNumber == meeting.number);
        final responseScore = responses.isNotEmpty ? responses.first.responseScore! : 0.0;

        return Scaffold(
          appBar: CustomAppBar(
            title: 'Pertemuan ${meeting.number}',
          ),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Container(
                    color: Palette.purple2,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        RotatedBox(
                          quarterTurns: -2,
                          child: SvgAsset(
                            AssetPath.getVector('bg_attribute.svg'),
                            width: AppSize.getAppWidth(context) / 2,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                              child: Text(
                                '${meeting.lesson}',
                                style: textTheme.headlineSmall!.copyWith(
                                  color: Palette.background,
                                ),
                              ),
                            ),
                            MentorListTile(
                              name: '${meeting.assistant?.fullname}',
                              role: 'Pemateri',
                              imageUrl: meeting.assistant?.profilePicturePath,
                            ),
                            MentorListTile(
                              name: '${meeting.coAssistant?.fullname}',
                              role: 'Pendamping',
                              imageUrl: meeting.coAssistant?.profilePicturePath,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverAppBar(
                  elevation: 0,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  toolbarHeight: 6,
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Palette.violet2,
                          Palette.violet4,
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => context.openFile(
                            name: 'Modul',
                            path: meeting.modulePath,
                          ),
                          icon: const Icon(Icons.menu_book_rounded),
                          label: const Text('Lihat Modul'),
                          style: FilledButton.styleFrom(
                            foregroundColor: Palette.purple2,
                            backgroundColor: Palette.background,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: meeting.modulePath != null && meeting.modulePath!.isEmpty
                            ? () async {
                                if (await FileService.saveFileFromUrl(meeting.modulePath!)) {
                                  if (!context.mounted) return;

                                  context.showSnackBar(
                                    title: 'Berhasil',
                                    message: 'File modul telah disimpan di folder Download.',
                                    type: SnackBarType.success,
                                  );
                                } else {
                                  if (!context.mounted) return;

                                  context.showSnackBar(
                                    title: 'Terjadi Kesalahan',
                                    message: 'File modul gagal di-download.',
                                    type: SnackBarType.error,
                                  );
                                }
                              }
                            : () {
                                context.showSnackBar(
                                  title: 'File Tidak Ada',
                                  message: 'File modul belum dimasukkan.',
                                  type: SnackBarType.info,
                                );
                              },
                        icon: const Icon(
                          Icons.file_download_outlined,
                          color: Palette.purple2,
                        ),
                        tooltip: 'Download Modul',
                        style: IconButton.styleFrom(
                          foregroundColor: Palette.purple2,
                          backgroundColor: Palette.background,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    decoration: BoxDecoration(
                      color: Palette.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle(text: 'Status Pertemuan'),
                        MeetingStatusInfo(completed: completed),
                        if (args.attendance != null) ...[
                          const SectionTitle(text: 'Status Absensi'),
                          AttendanceStatusInfo(attendance: args.attendance!),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ScoreIndicator(
                        title: 'Nilai Quiz',
                        score: quizScore,
                      ),
                      const SizedBox(width: 16),
                      ScoreIndicator(
                        title: 'Nilai Respon',
                        score: responseScore,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
        bottom: 6,
      ),
      child: Text(
        text,
        style: textTheme.titleMedium!.copyWith(
          color: Palette.purple2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class MeetingStatusInfo extends StatelessWidget {
  final bool completed;

  const MeetingStatusInfo({super.key, required this.completed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: completed ? Palette.purple4 : Palette.disabled,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          completed ? 'Selesai' : 'Belum Dimulai',
          style: textTheme.labelLarge!.copyWith(
            color: completed ? Palette.purple2 : Palette.disabledText,
          ),
        ),
      ),
    );
  }
}

class AttendanceStatusInfo extends StatelessWidget {
  final Attendance attendance;

  const AttendanceStatusInfo({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Palette.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Palette.purple2,
        ),
        boxShadow: const [
          BoxShadow(
            offset: Offset(3, 4),
            color: Palette.purple2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${MapHelper.getReadableAttendanceStatus(attendance.status)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleMedium!.copyWith(
                color: MapHelper.getAttendanceStatusColor(attendance.status),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              attendance.status == 'ATTEND'
                  ? 'Waktu absensi ${attendance.time?.to24TimeFormat()}'
                  : attendance.note != null && attendance.note!.isNotEmpty
                      ? attendance.note!
                      : 'Tidak ada keterangan',
              style: textTheme.bodySmall!.copyWith(
                color: Palette.secondaryText,
              ),
            ),
            if (attendance.extraPoint != null && attendance.extraPoint != 0) ...[
              const SizedBox(height: 2),
              Text(
                'Extra poin +${attendance.extraPoint}',
                style: textTheme.bodySmall!.copyWith(
                  color: Palette.secondaryText,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ScoreIndicator extends StatelessWidget {
  final String title;
  final double score;

  const ScoreIndicator({
    super.key,
    required this.title,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        decoration: BoxDecoration(
          color: Palette.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            SectionTitle(text: title),
            const SizedBox(height: 4),
            Stack(
              alignment: Alignment.topRight,
              children: [
                CircularPercentIndicator(
                  percent: score / 100,
                  animation: true,
                  animationDuration: 1000,
                  curve: Curves.easeOut,
                  radius: 55,
                  lineWidth: 10,
                  progressColor: Palette.purple3,
                  backgroundColor: Colors.transparent,
                  circularStrokeCap: CircularStrokeCap.round,
                  center: Container(
                    margin: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Palette.purple2,
                    ),
                    child: Center(
                      child: Text(
                        score.toStringAsFixed(1),
                        style: textTheme.headlineSmall!.copyWith(
                          color: Palette.background,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StudentMeetingDetailPageArgs {
  final String id;
  final Attendance? attendance;

  const StudentMeetingDetailPageArgs({
    required this.id,
    this.attendance,
  });
}
