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
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/presentation/features/admin/assistance_group/pages/assistance_group_form_page.dart';
import 'package:asco/src/presentation/features/admin/assistance_group/providers/assistance_group_actions_provider.dart';
import 'package:asco/src/presentation/features/admin/assistance_group/providers/assistance_group_detail_provider.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';
import 'package:asco/src/presentation/shared/widgets/practicum_badge_image.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class AssistanceGroupDetailPage extends ConsumerWidget {
  final AssistanceGroupDetailPageArgs args;

  const AssistanceGroupDetailPage({super.key, required this.args});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(AssistanceGroupDetailProvider(args.id));

    ref.listen(AssistanceGroupDetailProvider(args.id), (_, state) {
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

    ref.listen(assistanceGroupActionsProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data.message != null) ref.invalidate(assistanceGroupDetailProvider);
        },
      );
    });

    return group.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (group) {
        if (group == null) return const Scaffold();

        return Scaffold(
          appBar: CustomAppBar(
            title: 'Grup Asistensi ${group.number}',
            action: IconButton(
              onPressed: () => navigatorKey.currentState!.pushNamed(
                assistanceGroupFormRoute,
                arguments: AssistanceGroupFormPageArgs(
                  practicumId: args.practicum.id!,
                  group: group,
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
                              badgeUrl: '${args.practicum.badgePath}',
                              width: 48,
                              height: 52,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Grup Asistensi #${group.number}',
                                    style: textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${group.studentsCount} Peserta',
                                    style: textTheme.bodySmall!.copyWith(
                                      color: Palette.secondaryText,
                                    ),
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
                const SectionHeader(title: 'Asisten'),
                UserCard(
                  user: group.assistant!,
                  badgeType: UserBadgeType.text,
                ),
                const SectionHeader(title: 'Peserta'),
                ...List<Padding>.generate(
                  group.students!.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      bottom: index == group.students!.length - 1 ? 0 : 10,
                    ),
                    child: UserCard(
                      user: group.students![index],
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

class AssistanceGroupDetailPageArgs {
  final String id;
  final Practicum practicum;

  const AssistanceGroupDetailPageArgs({
    required this.id,
    required this.practicum,
  });
}
