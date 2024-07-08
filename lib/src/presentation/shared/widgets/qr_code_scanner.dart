// Dart imports:
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/providers/manual_providers/qr_scanner_provider.dart';
import 'package:asco/src/presentation/shared/widgets/asco_app_bar.dart';

class QrCodeScanner extends ConsumerStatefulWidget {
  final ValueChanged<String> onQrScanned;

  const QrCodeScanner({super.key, required this.onQrScanned});

  @override
  ConsumerState<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends ConsumerState<QrCodeScanner> with SingleTickerProviderStateMixin {
  late final GlobalKey qrKey;
  late final ValueNotifier<bool> flashOn;

  late final AnimationController animationController;
  late final Animation<double> animation;

  QRViewController? qrViewController;

  @override
  void reassemble() {
    if (Platform.isAndroid) {
      qrViewController!.pauseCamera();
    } else if (Platform.isIOS) {
      qrViewController!.resumeCamera();
    }

    super.reassemble();
  }

  @override
  void initState() {
    qrKey = GlobalKey(debugLabel: 'QR');
    flashOn = ValueNotifier(false);

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(animationController);

    super.initState();
  }

  @override
  void dispose() {
    flashOn.dispose();
    animationController.dispose();
    qrViewController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final qrScannerNotifier = ref.watch(qrScannerProvider);

    if (qrViewController != null) {
      if (qrScannerNotifier.isPaused) {
        qrViewController!.pauseCamera();
      } else {
        qrViewController!.resumeCamera();
      }
    }

    return LayoutBuilder(
      builder: (context, constraint) {
        final size = constraint.maxWidth - 72;

        return Stack(
          children: [
            QRView(
              key: qrKey,
              onQRViewCreated: onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderWidth: 12,
                borderLength: 36,
                borderRadius: 16,
                borderColor: Palette.purple3,
                overlayColor: Palette.purple2.withOpacity(.6),
                cutOutSize: size,
              ),
            ),
            Center(
              child: Container(
                width: size - 12,
                height: size - 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: size,
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedOpacity(
                          opacity: animation.value > .2 && animation.value < .8 ? 1 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: SizedBox(
                            width: size - 8,
                            height: 24,
                            child: Transform.translate(
                              offset: Offset(0, (size - 4) * (animation.value - .5)),
                              child: Column(
                                children: [
                                  if (animation.status == AnimationStatus.forward)
                                    Container(
                                      height: 20,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Palette.purple3.withOpacity(0),
                                            Palette.purple3.withOpacity(.1),
                                            Palette.purple3.withOpacity(.3),
                                            Palette.purple3.withOpacity(.5),
                                          ],
                                        ),
                                      ),
                                    ),
                                  Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Palette.purple3,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  if (animation.status == AnimationStatus.reverse)
                                    Container(
                                      height: 20,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Palette.purple3.withOpacity(0),
                                            Palette.purple3.withOpacity(.1),
                                            Palette.purple3.withOpacity(.3),
                                            Palette.purple3.withOpacity(.5),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Positioned(
              width: constraint.maxWidth,
              top: 20,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Powered by',
                          style: textTheme.bodySmall!.copyWith(
                            color: Palette.background,
                          ),
                        ),
                        const AscoAppBar(),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Auto Confirm',
                          style: textTheme.bodySmall!.copyWith(
                            color: Palette.background,
                          ),
                        ),
                        Switch(
                          value: qrScannerNotifier.autoConfirm,
                          activeTrackColor: Palette.purple2,
                          inactiveTrackColor: Colors.grey[400],
                          thumbColor: WidgetStateProperty.resolveWith((states) {
                            return Palette.background;
                          }),
                          trackOutlineColor: WidgetStateProperty.resolveWith((states) {
                            return Colors.transparent;
                          }),
                          trackOutlineWidth: WidgetStateProperty.resolveWith((states) {
                            return 0;
                          }),
                          onChanged: (value) {
                            ref.read(qrScannerProvider.notifier).autoConfirm = value;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (qrViewController != null)
              Positioned(
                width: constraint.maxWidth,
                bottom: (constraint.maxHeight / 2) - (size / 2) - 120,
                child: ValueListenableBuilder(
                  valueListenable: flashOn,
                  builder: (context, isActive, child) {
                    return FloatingActionButton(
                      elevation: 0,
                      foregroundColor: Palette.background,
                      backgroundColor: Palette.purple2,
                      shape: const CircleBorder(
                        side: BorderSide(
                          width: 2,
                          color: Palette.background,
                        ),
                      ),
                      onPressed: () {
                        qrViewController!.toggleFlash();
                        flashOn.value = !isActive;
                      },
                      tooltip: 'Flash',
                      child: Icon(
                        isActive ? Icons.flash_on_outlined : Icons.flash_off_outlined,
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() => qrViewController = controller);

    controller.scannedDataStream.listen((data) {
      if (data.code != null) widget.onQrScanned(data.code!);
    });
  }
}
