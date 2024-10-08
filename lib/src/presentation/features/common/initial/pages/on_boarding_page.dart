// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/features/common/initial/providers/login_provider.dart';
import 'package:asco/src/presentation/shared/widgets/asco_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/login_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class OnBoardingPage extends ConsumerWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(loginProvider, (_, state) {
      state.when(
        loading: () => context.showLoadingDialog(),
        error: (error, _) {
          navigatorKey.currentState!.pop();

          if ('$error' == kNoInternetConnection) {
            context.showNoConnectionSnackBar();
          } else {
            context.showSnackBar(
              title: 'Login Gagal',
              message: '$error',
              type: SnackBarType.error,
            );
          }
        },
        data: (data) {
          if (data.$1 != null && data.$2 != null) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
              MapHelper.roleMap[data.$2!.role] == 0 ? adminHomeRoute : homeRoute,
              (route) => false,
            );
          }
        },
      );
    });

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: RiveAnimation.asset(
              AssetPath.getRive('anim_bg.riv'),
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: const SizedBox(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AscoAppBar(),
                  const Spacer(),
                  RichText(
                    text: TextSpan(
                      text: 'Sistem\nKelola',
                      style: textTheme.displaySmall!.copyWith(
                        fontSize: 40,
                        height: 1.1,
                      ),
                      children: [
                        TextSpan(
                          text: '\nPraktikum &\nAsistensi',
                          style: textTheme.displaySmall!.copyWith(
                            color: Palette.purple3,
                            fontSize: 40,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Membantu pengelolaan data praktikum dan asistensi Laboratorium Sistem Informasi Universitas Hasanuddin.',
                  ),
                  const Spacer(flex: 2),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Palette.purple3.withOpacity(.2),
                          blurRadius: 6,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: FilledButton.icon(
                      icon: SvgAsset(
                        AssetPath.getIcon('arrow_forward_outlined.svg'),
                        width: 20,
                      ),
                      label: const Text('Lanjutkan'),
                      style: FilledButton.styleFrom(
                        foregroundColor: Palette.primaryText,
                        backgroundColor: Palette.background,
                        padding: const EdgeInsets.symmetric(horizontal: 48),
                      ),
                      onPressed: () => showLoginDialog(context),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tekan "Lanjutkan" untuk Login. Aplikasi ini khusus untuk Asisten dan Praktikan.',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Object?> showLoginDialog(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierLabel: 'login',
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: anim1,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
      pageBuilder: (_, __, ___) => const LoginDialog(),
    );
  }
}
