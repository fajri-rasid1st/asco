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
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/keys.dart';
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
          if ('$error' == kUnauthorized || '$error' == kAuthorizationExpired) {
            ref.read(logOutProvider.notifier).logOut();
          }

          context.showSnackBar(
            title: 'Terjadi Kesalahan',
            message: '$error',
            type: SnackBarType.error,
          );
        },
        data: (data) => navigatePage(data),
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
          if (data != null) navigatorKey.currentState!.pushReplacementNamed(onBoardingRoute);
        },
      );
    });

    return const LoadingIndicator(withScaffold: true);
  }

  void navigatePage(bool? isLogin) {
    if (isLogin == null) return;

    if (isLogin) {
      navigatorKey.currentState!.pushReplacementNamed(
        MapHelper.roleMap[CredentialSaver.credential?.role] == 0 ? adminHomeRoute : homeRoute,
      );
    } else {
      navigatorKey.currentState!.pushReplacementNamed(onBoardingRoute);
    }
  }
}
