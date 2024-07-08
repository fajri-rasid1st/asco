// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/features/common/initial/providers/is_login_provider.dart';
import 'package:asco/src/presentation/features/common/initial/providers/log_out_provider.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';

class Wrapper extends ConsumerWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(isLoginProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kAuthorizationExpired) {
            ref.read(logOutProvider.notifier).logOut();
          } else {
            context.showSnackBar(
              title: 'Terjadi Kesalahan',
              message: '$error',
              type: SnackBarType.error,
            );
          }
        },
        data: (data) => navigatePage(data.$1, data.$2),
      );
    });

    ref.listen(logOutProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) => context.showSnackBar(
          title: 'Terjadi Kesalahan',
          message: '$error',
          type: SnackBarType.error,
        ),
        data: (data) {
          if (data != null) {
            navigatorKey.currentState!.pushReplacementNamed(onBoardingRoute).whenComplete(() {
              context.showSnackBar(
                title: 'Sesi Telah Habis',
                message: 'Harap lakukan login kembali',
                type: SnackBarType.error,
              );
            });
          }
        },
      );
    });

    return const LoadingIndicator(withScaffold: true);
  }

  void navigatePage(bool? isLogin, Profile? credential) {
    if (isLogin == null) return;

    if (isLogin) {
      if (credential != null) {
        navigatorKey.currentState!.pushReplacementNamed(
          MapHelper.getRoleId(credential.role) == 0 ? adminHomeRoute : homeRoute,
        );
      }
    } else {
      navigatorKey.currentState!.pushReplacementNamed(onBoardingRoute);
    }
  }
}
