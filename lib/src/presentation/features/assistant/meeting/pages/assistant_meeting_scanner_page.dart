// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

// Project imports:
import 'package:asco/core/extensions/button_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/providers/manual_providers/qr_scanner_provider.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/qr_code_scanner.dart';

class AssistantMeetingScannerPage extends ConsumerWidget {
  const AssistantMeetingScannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrScannerNotifier = ref.watch(qrScannerProvider);

    return Scaffold(
      backgroundColor: Palette.purple2,
      body: SafeArea(
        child: QrCodeScanner(
          onQrScanned: (value) {
            if (ModalRoute.of(context)?.isCurrent != true) {
              navigatorKey.currentState!.pop();
            }

            if (!qrScannerNotifier.autoConfirm && !qrScannerNotifier.isError) {
              showConfirmModalBottomSheet(context, ref);
            } else if (qrScannerNotifier.isError) {
              showErrorModalBottomSheet(context, ref);
            } else {
              showAttendanceStatusDialog(context, ref);
            }

            ref.read(qrScannerProvider.notifier).isPaused = true;
          },
        ),
      ),
    );
  }

  Future<void> showConfirmModalBottomSheet(BuildContext context, WidgetRef ref) async {
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
                'Pemrograman Mobile A',
                style: textTheme.bodyMedium!.copyWith(
                  color: Palette.purple3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Pertemuan 1',
                style: textTheme.titleLarge!.copyWith(
                  color: Palette.purple2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 48,
                horizontalTitleGap: 14,
                leading: const CircleNetworkImage(
                  imageUrl: 'https://placehold.co/100x100/png',
                  size: 48,
                ),
                title: Text(
                  'Eurico Devon Bura Pakilaran',
                  style: textTheme.titleMedium!.copyWith(
                    color: Palette.disabledText,
                  ),
                ),
                subtitle: Text(
                  'H071191051',
                  style: textTheme.bodySmall!.copyWith(
                    color: Palette.disabledText,
                  ),
                ),
              ),
              FilledButton(
                onPressed: () => navigatorKey.currentState!.pop(),
                child: const Text('Konfirmasi'),
              ).fullWidth(),
            ],
          ),
        ),
      ),
    ).whenComplete(() => ref.read(qrScannerProvider.notifier).reset());
  }

  Future<void> showErrorModalBottomSheet(BuildContext context, WidgetRef ref) async {
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
                      'NIM Tidak Ditemukan!',
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge!.copyWith(
                        color: Palette.purple2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'NIM tidak ada dalam database. Silahkan coba lagi.',
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

  Future<void> showAttendanceStatusDialog(BuildContext context, WidgetRef ref) async {
    // Timer? timer = Timer(
    //   const Duration(seconds: 3),
    //   () => navigatorKey.currentState!.pop(),
    // );

    // // showDialog(
    // //   context: context,
    // //   builder: (context) => const AttendanceStatusDialog(
    // //     attendanceType: AttendanceType.meeting,
    // //     isAttend: true,
    // //   ),
    // // ).then((_) {
    // //   timer?.cancel();
    // //   timer = null;
    // // }).whenComplete(() => ref.read(qrScannerProvider.notifier).reset());
  }
}
