// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/extensions/button_extension.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/features/admin/user/pages/user_form_page.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_badge.dart';

class UserDetailPage extends StatelessWidget {
  const UserDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detail Pengguna',
        action: IconButton(
          onPressed: () => navigatorKey.currentState!.pushNamed(
            userFormRoute,
            arguments: const UserFormPageArgs(action: 'Edit'),
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
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleNetworkImage(
                    imageUrl: 'https://placehold.co/300x300/png',
                    size: 128,
                    withBorder: true,
                    borderWidth: 4,
                    borderColor: Palette.background,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Muh. Alip Setya Prakasa',
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'H071191042',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium!.copyWith(
                      color: Palette.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '2019',
                    style: textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  CustomBadge(
                    text: 'Praktikan',
                    verticalPadding: 6,
                    horizontalPadding: 12,
                    textStyle: textTheme.bodySmall!.copyWith(
                      color: Palette.background,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Palette.errorText,
                side: const BorderSide(color: Palette.errorText),
              ),
              child: const Text('Reset Password'),
            ).fullWidth(),
          ],
        ),
      ),
    );
  }
}
