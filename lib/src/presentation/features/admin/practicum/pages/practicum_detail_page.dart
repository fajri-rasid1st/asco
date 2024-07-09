// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/enums/user_badge_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/features/admin/practicum/pages/practicum_form_page.dart';
import 'package:asco/src/presentation/features/admin/practicum/providers/practicum_detail_provider.dart';
import 'package:asco/src/presentation/shared/widgets/cards/classroom_card.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';
import 'package:asco/src/presentation/shared/widgets/practicum_badge_image.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class PracticumDetailPage extends ConsumerWidget {
  final String id;

  const PracticumDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final practicum = ref.watch(PracticumDetailProvider(id));

    ref.listen(PracticumDetailProvider(id), (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNoConnectionSnackBar();
          } else {
            context.showSnackBar(
              title: 'Terjadi Kesalahan',
              message: '$error',
              type: SnackBarType.error,
            );
          }
        },
      );
    });

    return practicum.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (practicum) {
        if (practicum == null) return const Scaffold();

        return Scaffold(
          appBar: CustomAppBar(
            title: 'Detail Praktikum',
            action: IconButton(
              onPressed: () => navigatorKey.currentState!.pushNamed(
                practicumFirstFormRoute,
                arguments: PracticumFormPageArgs(
                  title: 'Edit',
                  practicum: practicum,
                ),
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
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Palette.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      SvgAsset(
                        AssetPath.getVector('bg_attribute_3.svg'),
                        height: 44,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            PracticumBadgeImage(
                              badgeUrl: '${practicum.badgePath}',
                              width: 48,
                              height: 52,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mata Kuliah',
                                    style: textTheme.bodySmall!.copyWith(
                                      color: Palette.secondaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${practicum.course}',
                                    style: textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SectionHeader(title: 'Kelas'),
                ...List<Padding>.generate(
                  4,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      bottom: index == 3 ? 0 : 10,
                    ),
                    child: const ClassroomCard(),
                  ),
                ),
                const SectionHeader(title: 'Asisten'),
                ...List<Padding>.generate(
                  4,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      bottom: index == 3 ? 0 : 10,
                    ),
                    child: UserCard(
                      user: CredentialSaver.credential!,
                      badgeType: UserBadgeType.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
