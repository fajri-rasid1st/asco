// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/extensions/button_extension.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/data/models/profiles/profile_post.dart';
import 'package:asco/src/presentation/features/admin/user/providers/user_actions_provider.dart';
import 'package:asco/src/presentation/features/admin/user/providers/user_detail_provider.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_badge.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';

class UserDetailPage extends ConsumerWidget {
  final String username;

  const UserDetailPage({super.key, required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(UserDetailProvider(username));

    ref.listen(UserDetailProvider(username), (_, state) {
      state.whenOrNull(error: context.responseError);
    });

    ref.listen(userActionsProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data.message != null) ref.invalidate(userDetailProvider);
        },
      );
    });

    return user.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (user) {
        if (user == null) return const Scaffold();

        return Scaffold(
          appBar: CustomAppBar(
            title: 'Detail Pengguna',
            action: IconButton(
              onPressed: () => navigatorKey.currentState!.pushNamed(
                userFormRoute,
                arguments: user,
              ),
              icon: const Icon(Icons.edit_rounded),
              iconSize: 20,
              tooltip: 'Edit',
              style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: const CircleBorder(),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleNetworkImage(
                  imageUrl: user.profilePicturePath,
                  size: 128,
                  withBorder: true,
                  borderWidth: 2,
                  borderColor: Palette.background,
                  showPreviewWhenPressed: true,
                ),
                const SizedBox(height: 12),
                Text(
                  '${user.fullname}',
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${user.username}',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium!.copyWith(
                    color: Palette.secondaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${user.classOf}',
                  style: textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                CustomBadge(
                  text: '${MapHelper.getReadableRole(user.role)}',
                  verticalPadding: 6,
                  horizontalPadding: 12,
                  textStyle: textTheme.bodySmall!.copyWith(
                    color: Palette.background,
                    height: 1,
                  ),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () => context.showConfirmDialog(
                    title: 'Reset Password?',
                    message: 'Password akan diubah sesuai dengan username pengguna.',
                    primaryButtonText: 'Reset',
                    onPressedPrimaryButton: () => resetPassword(ref, user),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Palette.errorText,
                    side: const BorderSide(
                      color: Palette.errorText,
                    ),
                  ),
                  child: const Text('Reset Password'),
                ).fullWidth(),
              ],
            ),
          ),
        );
      },
    );
  }

  void resetPassword(WidgetRef ref, Profile user) async {
    final resettedUser = ProfilePost(
      username: user.username!,
      fullname: user.fullname!,
      classOf: user.classOf!,
      role: user.role!,
      password: user.username!,
    );

    ref.read(userActionsProvider.notifier).editUser(user.username!, resettedUser);
  }
}
