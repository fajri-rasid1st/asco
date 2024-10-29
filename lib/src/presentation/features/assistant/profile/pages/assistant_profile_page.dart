// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/presentation/features/common/initial/providers/credential_provider.dart';
import 'package:asco/src/presentation/shared/features/practicum/providers/practicums_provider.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/custom_icon_button.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';
import 'package:asco/src/presentation/shared/widgets/practicum_badge_image.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class AssistantProfilePage extends ConsumerWidget {
  const AssistantProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(credentialProvider);

    ref.listen(credentialProvider, (_, state) {
      state.whenOrNull(error: context.responseError);
    });

    return profile.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (profile) {
        if (profile == null) return const Scaffold();

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    const SizedBox(height: 160 + kToolbarHeight),
                    Container(
                      height: 120 + kToolbarHeight,
                      color: Palette.purple2,
                    ),
                    Positioned(
                      top: kToolbarHeight,
                      right: 0,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          RotatedBox(
                            quarterTurns: -2,
                            child: SvgAsset(
                              AssetPath.getVector('bg_attribute.svg'),
                              height: 120,
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 10,
                            child: Row(
                              children: [
                                CustomIconButton(
                                  'github_filled.svg',
                                  color: Palette.background,
                                  tooltip: 'Github',
                                  onPressed: () => context.openUrl(
                                    name: 'Github',
                                    url: 'https://github.com/${profile.githubUsername}',
                                  ),
                                ),
                                const SizedBox(width: 2),
                                CustomIconButton(
                                  'instagram_filled.svg',
                                  tooltip: 'Instagram',
                                  onPressed: () => context.openUrl(
                                    name: 'Instagram',
                                    url: 'https://instagram.com/${profile.instagramUsername}',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 20,
                      right: 10,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 28),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Data Diri',
                                  style: textTheme.headlineSmall!.copyWith(
                                    color: Palette.background,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              CustomIconButton(
                                'edit_outlined.svg',
                                tooltip: 'Edit Profil',
                                onPressed: () => navigatorKey.currentState!.pushNamed(editProfileRoute),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60 + kToolbarHeight,
                      left: 20,
                      child: CircleNetworkImage(
                        imageUrl: profile.profilePicturePath,
                        size: 100,
                        withBorder: true,
                        borderWidth: 2,
                        borderColor: Palette.background,
                        showPreviewWhenPressed: true,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${profile.fullname}',
                        style: textTheme.titleLarge!.copyWith(
                          color: Palette.purple2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${profile.nickname}',
                        style: textTheme.bodyMedium!.copyWith(
                          color: Palette.purple3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Consumer(
                        builder: (context, ref, child) {
                          final practicums = ref.watch(practicumsProvider);

                          ref.listen(practicumsProvider, (_, state) {
                            state.whenOrNull(error: context.responseError);
                          });

                          return practicums.when(
                            loading: () => const LoadingIndicator(),
                            error: (_, __) => const SizedBox(),
                            data: (practicums) {
                              if (practicums == null) return const SizedBox();

                              return GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 1.1,
                                ),
                                itemBuilder: (context, index) => AssistantBadgeCard(
                                  practicum: practicums[index],
                                ),
                                itemCount: practicums.length,
                              );
                            },
                          );
                        },
                      ),
                    ],
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

class AssistantBadgeCard extends StatelessWidget {
  final Practicum practicum;

  const AssistantBadgeCard({super.key, required this.practicum});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Palette.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Palette.purple2,
        ),
        boxShadow: const [
          BoxShadow(
            offset: Offset(3, 2),
            color: Palette.purple2,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
              ),
              child: SvgAsset(
                AssetPath.getVector('bg_attribute_3.svg'),
                height: 48,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PracticumBadgeImage(
                    badgeUrl: '${practicum.badgePath}',
                    width: 48,
                    height: 52,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Asisten',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${practicum.course}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall!.copyWith(
                      color: Palette.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
