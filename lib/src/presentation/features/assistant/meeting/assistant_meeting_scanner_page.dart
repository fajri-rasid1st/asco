// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/src/presentation/shared/widgets/qr_code_scanner.dart';

final showErrorModalProvider = StateProvider.autoDispose<bool>((ref) => false);

class AssistantMeetingScannerPage extends ConsumerStatefulWidget {
  const AssistantMeetingScannerPage({super.key});

  @override
  ConsumerState<AssistantMeetingScannerPage> createState() => _AssistantMeetingScannerPageState();
}

class _AssistantMeetingScannerPageState extends ConsumerState<AssistantMeetingScannerPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<Offset> animation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: AppSize.getAppWidth(context),
            height: AppSize.getAppHeight(context),
            child: QrCodeScanner(
              onQrScanned: (value) => debugPrint(value),
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              if (ref.watch(showErrorModalProvider)) {
                return Positioned(
                  bottom: 0,
                  child: SlideTransition(
                    position: animation,
                    // child: FailureModal(
                    //   onClose: hideErrorModal,
                    // ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Future<void> showConfirmModalBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      builder: (context) => BottomSheet(
        onClosing: () {},
        enableDrag: false,
        builder: (context) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [],
          ),
        ),
      ),
    );
  }

  void showErrorModal() {
    ref.read(showErrorModalProvider.notifier).state = true;

    animationController.forward();
  }

  void hideErrorModal() {
    ref.read(showErrorModalProvider.notifier).state = true;

    animationController.reverse();
  }
}
