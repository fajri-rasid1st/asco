// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/leaderboard_rank_type.dart';
import 'package:asco/core/enums/leaderboard_type.dart';
import 'package:asco/core/enums/user_badge_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/classrooms/classroom.dart';
import 'package:asco/src/data/models/scores/score_recap.dart';
import 'package:asco/src/presentation/features/common/menu/providers/leaderboard_provider.dart';
import 'package:asco/src/presentation/shared/features/score/pages/score_recap_detail_page.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/custom_badge.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class LeaderboardPage extends StatefulWidget {
  final Classroom classroom;

  const LeaderboardPage({super.key, required this.classroom});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late final PageController pageController;
  late final List<Leaderboard> leaderboards;

  @override
  void initState() {
    pageController = PageController();

    leaderboards = [
      Leaderboard(
        pageController: pageController,
        type: LeaderboardType.practicum,
        classroom: widget.classroom,
      ),
      Leaderboard(
        pageController: pageController,
        type: LeaderboardType.labExam,
        classroom: widget.classroom,
      ),
    ];

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A5BE0),
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          SizedBox(
            width: AppSize.getAppWidth(context),
            height: AppSize.getAppHeight(context),
          ),
          SvgAsset(
            AssetPath.getVector('exclude.svg'),
          ),
          Positioned.fill(
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: leaderboards,
            ),
          ),
        ],
      ),
    );
  }
}

final isLabExamLeaderboardProvider = StateProvider.autoDispose<bool>((ref) => false);

class Leaderboard extends ConsumerWidget {
  final PageController pageController;
  final LeaderboardType type;
  final Classroom classroom;

  const Leaderboard({
    super.key,
    required this.pageController,
    required this.type,
    required this.classroom,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLabExam = ref.watch(isLabExamLeaderboardProvider);
    final scores = ref.watch(
      LeaderboardProvider(
        classroom.practicum!.id!,
        isLabExam: isLabExam,
      ),
    );

    ref.listen(
      LeaderboardProvider(
        classroom.practicum!.id!,
        isLabExam: isLabExam,
      ),
      (_, state) => state.whenOrNull(error: context.responseError),
    );

    return scores.when(
      loading: () => const LoadingIndicator(),
      error: (_, __) => const SizedBox(),
      data: (scores) {
        if (scores == null) return const SizedBox();

        if (scores.isEmpty) {
          return const CustomInformation(
            title: 'Leaderboard belum tersedia',
            subtitle: 'Saat ini, daftar peringkat praktikan masih kosong',
          );
        }

        final subScores = scores.sublist(3);

        return SingleChildScrollView(
          padding: const EdgeInsets.only(top: 70),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        type == LeaderboardType.practicum ? 'Leaderboard' : 'Ujian Lab',
                        style: textTheme.headlineSmall!.copyWith(
                          color: Palette.background,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        pageController.animateToPage(
                          type == LeaderboardType.practicum ? 1 : 0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );

                        ref.read(isLabExamLeaderboardProvider.notifier).update((state) => !state);
                      },
                      child: InkWellContainer(
                        radius: 99,
                        color: Palette.purple2,
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        child: Row(
                          children: [
                            SvgAsset(
                              AssetPath.getIcon('swap_outlined.svg'),
                              width: 12,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              type == LeaderboardType.practicum ? 'Praktikum' : 'Ujian Lab',
                              style: textTheme.bodyMedium!.copyWith(
                                color: Palette.background,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (type == LeaderboardType.practicum) ...[
                const SizedBox(height: 12),
                if (MapHelper.roleMap[CredentialSaver.credential?.role] == 1)
                  Builder(
                    builder: (context) {
                      final myScore = scores.firstWhere(
                          (e) => e.student?.username == CredentialSaver.credential?.username);
                      final myRank = scores.indexOf(myScore) + 1;

                      return LeaderboardContainer(
                        padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
                        onTap: () => navigatorKey.currentState!.pushNamed(
                          scoreRecapDetailRoute,
                          arguments: ScoreRecapDetailPageArgs(
                            practicumId: classroom.practicum!.id!,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF9A57),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '#$myRank',
                                style: textTheme.titleLarge!.copyWith(
                                  color: Palette.background,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kamu telah memperoleh nilai ${myScore.finalScore?.toStringAsFixed(1)}',
                                    style: textTheme.titleSmall!.copyWith(
                                      color: Palette.background,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Klik untuk melihat detail',
                                    style: textTheme.bodySmall!.copyWith(
                                      color: const Color(0xFF724A34),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                else
                  LeaderboardContainer(
                    padding: const EdgeInsets.all(16),
                    onTap: () => navigatorKey.currentState!.pushNamed(
                      scoreRecapListHomeRoute,
                      arguments: classroom.practicum,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgAsset(
                          AssetPath.getIcon('leaderboard_filled.svg'),
                          color: Palette.background,
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text(
                            'Cek Data Nilai Praktikan',
                            style: textTheme.titleMedium!.copyWith(
                              color: Palette.background,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    LeaderboardRank(
                      rank: 2,
                      rankType: LeaderboardRankType.silver,
                      score: scores[1],
                      leaderboardType: type,
                      clipper: CustomClipPathSilver(),
                      height: 110,
                      color: const Color(0xFF9088E6),
                    ),
                    LeaderboardRank(
                      rank: 1,
                      rankType: LeaderboardRankType.gold,
                      score: scores[0],
                      leaderboardType: type,
                      clipper: CustomClipPathGold(),
                      height: 160,
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF9289E5),
                          Color(0xFFC0BCF0),
                        ],
                      ),
                    ),
                    LeaderboardRank(
                      rank: 3,
                      rankType: LeaderboardRankType.bronze,
                      score: scores[2],
                      leaderboardType: type,
                      clipper: CustomClipPathBronze(),
                      height: 80,
                      color: const Color(0xFF9088E6),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Palette.secondaryBackground,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: List<Padding>.generate(
                    subScores.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: index == subScores.length - 1 ? kBottomNavigationBarHeight : 10,
                      ),
                      child: UserCard(
                        user: subScores[index].student!,
                        badgeType: UserBadgeType.text,
                        badgeText: type == LeaderboardType.practicum
                            ? subScores[index].finalScore!.toStringAsFixed(1)
                            : subScores[index].labExamScore!.toStringAsFixed(1),
                        trailing: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            '${index + 4}',
                            style: textTheme.titleLarge!.copyWith(
                              color: Palette.purple2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class LeaderboardContainer extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Widget? child;

  const LeaderboardContainer({
    super.key,
    this.padding,
    this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 12,
      color: Palette.orange2,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: padding,
      onTap: onTap,
      child: child,
    );
  }
}

class LeaderboardRank extends StatelessWidget {
  final int rank;
  final LeaderboardRankType rankType;
  final ScoreRecap score;
  final LeaderboardType leaderboardType;
  final CustomClipper<Path> clipper;
  final double height;
  final Color? color;
  final LinearGradient? gradient;

  const LeaderboardRank({
    super.key,
    required this.rank,
    required this.rankType,
    required this.score,
    required this.leaderboardType,
    required this.clipper,
    required this.height,
    this.color,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topRight,
            children: [
              CircleNetworkImage(
                imageUrl: score.student?.profilePicturePath,
                size: 60,
                withBorder: true,
                borderColor: Palette.background,
                borderWidth: 2,
              ),
              SvgAsset(
                AssetPath.getVector(rankType.svgName),
                width: 24,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${score.student?.nickname}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium!.copyWith(
              color: Palette.background,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          CustomBadge(
            verticalPadding: 6,
            horizontalPadding: 12,
            color: const Color(0xFF938AE5),
            text: leaderboardType == LeaderboardType.practicum
                ? score.finalScore!.toStringAsFixed(1)
                : score.labExamScore!.toStringAsFixed(1),
            textStyle: textTheme.bodySmall!.copyWith(
              color: Palette.background,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          ClipPath(
            clipper: clipper,
            child: Container(
              height: 25,
              color: const Color(0xFFAEA7EA),
            ),
          ),
          Container(
            height: height,
            decoration: BoxDecoration(
              color: color,
              gradient: gradient,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: textTheme.displayMedium!.copyWith(
                  color: Palette.background,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomClipPathBronze extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - 10, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CustomClipPathSilver extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(size.width - 90, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CustomClipPathGold extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width - 10, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(size.width - 90, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
