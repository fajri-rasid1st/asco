// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/attendance_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/datetime_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/shared/features/control_card/providers/control_cards_provider.dart';
import 'package:asco/src/presentation/shared/widgets/cards/attendance_card.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_badge.dart';
import 'package:asco/src/presentation/shared/widgets/custom_icon_button.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class ControlCardDetailPage extends StatelessWidget {
  final ControlCardDetailPageArgs args;

  const ControlCardDetailPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Kartu Kontrol',
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final data = ref.watch(ControlCardsProvider(args.practicum.id!, args.student));

          ref.listen(ControlCardsProvider(args.practicum.id!, args.student), (_, state) {
            state.whenOrNull(error: context.responseError);
          });

          return data.when(
            loading: () => const LoadingIndicator(),
            error: (_, __) => const SizedBox(),
            data: (data) {
              final cards = data.cards;
              final student = data.student;

              if (cards == null || student == null) return const SizedBox();

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        const SizedBox(height: 160),
                        Container(
                          height: 120,
                          color: Palette.purple2,
                        ),
                        Positioned(
                          top: 0,
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
                                        url: 'https://github.com/${student.githubUsername}',
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    CustomIconButton(
                                      'instagram_filled.svg',
                                      tooltip: 'Instagram',
                                      onPressed: () => context.openUrl(
                                        name: 'Instagram',
                                        url: 'https://instagram.com/${student.instagramUsername}',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 60,
                          left: 20,
                          child: CircleNetworkImage(
                            imageUrl: student.profilePicturePath,
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
                            '${student.fullname}',
                            style: textTheme.titleLarge!.copyWith(
                              color: Palette.purple2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${student.username}',
                            style: textTheme.bodyMedium!.copyWith(
                              color: Palette.purple3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 6,
                              bottom: 16,
                            ),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                CustomBadge(
                                  text: '${args.practicum.course}',
                                ),
                                CustomBadge(
                                  text: 'Group #${args.groupNumber}',
                                  color: Palette.error,
                                ),
                              ],
                            ),
                          ),
                          ...List<Padding>.generate(
                            cards.length,
                            (index) {
                              final card = cards[index];

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: index == cards.length - 1 ? 0 : 10,
                                ),
                                child: AttendanceCard(
                                  attendanceType: AttendanceType.assistance,
                                  assistanceStatus: [
                                    card.firstAssistanceStatus!,
                                    card.secondAssistanceStatus!,
                                  ],
                                  meeting: card.meeting!,
                                  locked: card.meeting!.date! > DateTime.now().secondsSinceEpoch,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ControlCardDetailPageArgs {
  final Profile student;
  final Practicum practicum;
  final int groupNumber;

  const ControlCardDetailPageArgs({
    required this.student,
    required this.practicum,
    required this.groupNumber,
  });
}
