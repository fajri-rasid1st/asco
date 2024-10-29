// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/datetime_extension.dart';
import 'package:asco/core/extensions/number_extension.dart';
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/services/file_service.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/assistances/assistance.dart';
import 'package:asco/src/presentation/features/student/assistance/providers/student_control_card_detail_provider.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_badge.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';
import 'package:asco/src/presentation/shared/widgets/section_title.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class StudentAssistanceDetailPage extends ConsumerWidget {
  final String id;

  const StudentAssistanceDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final card = ref.watch(StudentControlCardDetailProvider(id));

    ref.listen(StudentControlCardDetailProvider(id), (_, state) {
      state.whenOrNull(error: context.responseError);
    });

    return card.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (card) {
        if (card == null) return const Scaffold();

        return Scaffold(
          appBar: CustomAppBar(
            title: 'Pertemuan ${card.meeting?.number}',
          ),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
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
                        Positioned.fill(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  '${card.meeting?.lesson}',
                                  style: textTheme.headlineSmall!.copyWith(
                                    color: Palette.background,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => context.openFile(
                            name: 'Soal Praktikum',
                            path: card.meeting?.assignmentPath,
                          ),
                          icon: const Icon(Icons.menu_book_rounded),
                          label: const Text('Lihat Soal Praktikum'),
                          style: FilledButton.styleFrom(
                            foregroundColor: Palette.purple2,
                            backgroundColor: Palette.background,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: card.meeting?.assignmentPath != null && card.meeting!.assignmentPath!.isNotEmpty
                            ? () => saveAssignment(
                                  context,
                                  assignmentPath: card.meeting!.assignmentPath!,
                                  filename: 'soal_praktikum_pertemuan_${card.meeting?.number}',
                                )
                            : () => context.showSnackBar(
                                  title: 'File Tidak Ada',
                                  message: 'File soal praktikum belum dimasukkan.',
                                  type: SnackBarType.info,
                                ),
                        icon: const Icon(
                          Icons.file_download_outlined,
                          color: Palette.purple2,
                        ),
                        tooltip: 'Download Soal Praktikum',
                        style: IconButton.styleFrom(
                          foregroundColor: Palette.purple2,
                          backgroundColor: Palette.background,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                  const SectionTitle(text: 'Batas Waktu Asistensi'),
                  LinearPercentIndicator(
                    percent: calculateAssistanceDeadline(
                      card.meeting!.date!,
                      card.meeting!.assistanceDeadline!,
                      DateTime.now().secondsSinceEpoch,
                    ),
                    animation: true,
                    animationDuration: 1000,
                    curve: Curves.easeOut,
                    padding: EdgeInsets.zero,
                    lineHeight: 24,
                    barRadius: const Radius.circular(12),
                    backgroundColor: Palette.background,
                    linearGradient: const LinearGradient(
                      colors: [
                        Palette.purple3,
                        Palette.purple2,
                      ],
                    ),
                    clipLinearGradient: true,
                    widgetIndicator: Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.only(top: 14, right: 45),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Palette.background,
                      ),
                      child: const Icon(
                        Icons.schedule_rounded,
                        color: Palette.purple2,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Deadline: ${card.meeting!.assistanceDeadline!.toDateTimeFormat('d MMMM yyyy')}',
                      style: textTheme.labelSmall!.copyWith(
                        color: Palette.pink1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SectionTitle(text: 'Absen Asistensi'),
                  AttendanceAssistanceCard(
                    number: 1,
                    deadlineDate: card.meeting!.assistanceDeadline!,
                    assistance: card.firstAssistance!,
                  ),
                  const SizedBox(height: 16),
                  AttendanceAssistanceCard(
                    number: 2,
                    deadlineDate: card.meeting!.assistanceDeadline!,
                    assistance: card.secondAssistance!,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> saveAssignment(
    BuildContext context, {
    required String assignmentPath,
    required String filename,
  }) async {
    context.showLoadingDialog();

    final isSaved = await FileService.saveFileFromUrl(
      assignmentPath,
      name: '$filename.${assignmentPath.split('.').last}',
    );

    if (!context.mounted) return;

    if (isSaved) {
      context.showSnackBar(
        title: 'Berhasil',
        message: 'File soal praktikum telah disimpan di folder Download.',
        type: SnackBarType.success,
      );
    } else {
      context.showSnackBar(
        title: 'Terjadi Kesalahan',
        message: 'File soal praktikum gagal di-download.',
        type: SnackBarType.error,
      );
    }

    navigatorKey.currentState!.pop();
  }

  double calculateAssistanceDeadline(
    int meetingDate,
    int deadlineDate,
    int currentDate,
  ) {
    final totalDuration = (meetingDate - deadlineDate).abs();
    final elapsedTime = currentDate - meetingDate;
    final percentage = elapsedTime / totalDuration;

    return percentage.clamp(0.1, 1.0);
  }
}

class AttendanceAssistanceCard extends StatelessWidget {
  final int number;
  final int deadlineDate;
  final Assistance assistance;

  const AttendanceAssistanceCard({
    super.key,
    required this.number,
    required this.deadlineDate,
    required this.assistance,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Palette.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Asistensi $number',
                        style: textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        assistance.date == 0 ? 'Belum Asistensi' : assistance.date!.toDateTimeFormat('d MMMM yyyy'),
                        style: textTheme.bodySmall!.copyWith(
                          color: Palette.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                CustomBadge(
                  color: assistanceLabelColor.withOpacity(.2),
                  text: assistanceLabelText,
                  textStyle: textTheme.labelSmall!.copyWith(
                    color: assistanceLabelColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: AppSize.getAppWidth(context) - 56,
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          decoration: const BoxDecoration(
            color: Palette.purple2,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Catatan',
                style: textTheme.bodyMedium!.copyWith(
                  color: Palette.background,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                assistance.note!.isEmpty ? 'Tidak ada catatan' : assistance.note!,
                style: textTheme.bodySmall!.copyWith(
                  color: Palette.scaffoldBackground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool get isLate => deadlineDate <= DateTime.now().secondsSinceEpoch;

  String get assistanceLabelText => assistance.status!
      ? isLate
          ? 'Terlambat'
          : 'Tepat Waktu'
      : 'Belum Asistensi';

  Color get assistanceLabelColor => assistance.status!
      ? isLate
          ? Palette.pink2
          : Palette.purple3
      : Palette.disabledText;
}
