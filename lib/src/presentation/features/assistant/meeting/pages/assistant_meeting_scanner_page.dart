// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

// Project imports:
import 'package:asco/core/enums/attendance_type.dart';
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/extensions/button_extension.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/datetime_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/attendances/attendance.dart';
import 'package:asco/src/data/models/attendances/attendance_post.dart';
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/features/assistant/meeting/providers/update_attendance_scanner_provider.dart';
import 'package:asco/src/presentation/providers/manual_providers/qr_scanner_provider.dart';
import 'package:asco/src/presentation/shared/features/meeting/providers/meeting_attendances_provider.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/attendance_status_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/qr_code_scanner.dart';

class AssistantMeetingScannerPage extends ConsumerWidget {
  final AssistantMeetingScannerPageArgs args;

  const AssistantMeetingScannerPage({super.key, required this.args});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrScannerNotifier = ref.watch(qrScannerProvider);

    ref.listen(updateAttendanceScannerProvider, (_, state) {
      state.whenOrNull(
        loading: () => context.showLoadingDialog(),
        error: (error, stackTrace) {
          if (!qrScannerNotifier.autoConfirm) {
            navigatorKey.currentState!.pop();
          }

          navigatorKey.currentState!.pop();
          context.responseError(error, stackTrace);
        },
        data: (data) {
          if (data != null) {
            if (!qrScannerNotifier.autoConfirm) {
              navigatorKey.currentState!.pop();
            }

            navigatorKey.currentState!.pop();
            ref.invalidate(meetingAttendancesProvider);

            final attendance = args.attendances.where((e) => e.student!.id == data);

            if (attendance.isNotEmpty) {
              showAttendanceStatusDialog(context, ref, attendance.first.student!);
            }
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: Palette.purple2,
      body: SafeArea(
        child: QrCodeScanner(
          onQrScanned: (value) {
            if (ModalRoute.of(context)?.isCurrent != true) {
              navigatorKey.currentState!.pop();
            }

            final attendance = args.attendances.where((e) => e.student!.id == value);

            if (attendance.isNotEmpty) {
              if (qrScannerNotifier.autoConfirm) {
                submit(context, ref, attendance.first.student!.id!);
              } else {
                showConfirmModalBottomSheet(context, ref, attendance.first.student!);
              }
            } else {
              showErrorModalBottomSheet(context, ref);
            }

            ref.read(qrScannerProvider.notifier).isPaused = true;
          },
        ),
      ),
    );
  }

  void submit(BuildContext context, WidgetRef ref, String studentId) {
    if (DateTime.now().secondsSinceEpoch < args.meeting.date! + 86400) {
      final attendance = AttendancePost(
        status: 'ATTEND',
        studentId: studentId,
      );

      ref.read(updateAttendanceScannerProvider.notifier).updateAttendanceScanner(
            args.meeting.id!,
            attendance,
          );
    } else {
      context.showSnackBar(
        title: 'Pertemuan Telah Selesai',
        message: 'Kamu sudah tidak bisa mengabsen peserta pada pertemuan ini.',
        type: SnackBarType.error,
      );

      if (!ref.watch(qrScannerProvider).autoConfirm) {
        navigatorKey.currentState!.pop();
      }
    }
  }

  Future<void> showConfirmModalBottomSheet(
    BuildContext context,
    WidgetRef ref,
    Profile student,
  ) async {
    return showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      builder: (context) => BottomSheet(
        onClosing: () {},
        enableDrag: false,
        builder: (context) => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${args.meeting.lesson}',
                style: textTheme.bodyMedium!.copyWith(
                  color: Palette.purple3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Pertemuan ${args.meeting.number}',
                style: textTheme.titleLarge!.copyWith(
                  color: Palette.purple2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 48,
                horizontalTitleGap: 14,
                leading: CircleNetworkImage(
                  imageUrl: student.profilePicturePath,
                  size: 48,
                ),
                title: Text(
                  '${student.fullname}',
                  style: textTheme.titleMedium!.copyWith(
                    color: Palette.disabledText,
                  ),
                ),
                subtitle: Text(
                  '${student.username}',
                  style: textTheme.bodySmall!.copyWith(
                    color: Palette.disabledText,
                  ),
                ),
              ),
              FilledButton(
                onPressed: () => submit(context, ref, student.id!),
                child: const Text('Konfirmasi'),
              ).fullWidth(),
            ],
          ),
        ),
      ),
    ).whenComplete(() => ref.read(qrScannerProvider.notifier).reset());
  }

  Future<void> showAttendanceStatusDialog(
    BuildContext context,
    WidgetRef ref,
    Profile student,
  ) async {
    Timer? timer = Timer(
      const Duration(seconds: 3),
      () => navigatorKey.currentState!.pop(),
    );

    showDialog(
      context: context,
      builder: (context) => AttendanceStatusDialog(
        student: student,
        meeting: args.meeting,
        attendanceType: AttendanceType.meeting,
        isAttend: true,
      ),
    ).then((_) {
      timer?.cancel();
      timer = null;
    }).whenComplete(() => ref.read(qrScannerProvider.notifier).reset());
  }

  Future<void> showErrorModalBottomSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    return showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      builder: (context) => BottomSheet(
        onClosing: () {},
        enableDrag: false,
        builder: (context) => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: AlignmentDirectional.topCenter,
            children: [
              Positioned(
                top: -150,
                child: SizedBox(
                  width: 250,
                  height: 250,
                  child: RiveAnimation.asset(
                    AssetPath.getRive('error_icon.riv'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 44),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Peserta Tidak Ditemukan!',
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge!.copyWith(
                        color: Palette.purple2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Peserta tidak ditemukan. Silahkan coba lagi.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall!.copyWith(
                        color: Palette.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(() => ref.read(qrScannerProvider.notifier).reset());
  }
}

class AssistantMeetingScannerPageArgs {
  final Meeting meeting;
  final List<Attendance> attendances;

  const AssistantMeetingScannerPageArgs({
    required this.meeting,
    required this.attendances,
  });
}
