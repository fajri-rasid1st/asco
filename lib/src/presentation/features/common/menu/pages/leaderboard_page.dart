// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/enums/leaderboard_rank_type.dart';
import 'package:asco/core/enums/leaderboard_type.dart';
import 'package:asco/core/enums/user_badge_type.dart';
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/custom_badge.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> with AutomaticKeepAliveClientMixin {
  late final PageController pageController;
  late final List<Widget> pages;

  @override
  void initState() {
    pageController = PageController();

    pages = [
      Leaderboard(
        pageController: pageController,
        type: LeaderboardType.practicum,
      ),
      Leaderboard(
        pageController: pageController,
        type: LeaderboardType.labExam,
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
    super.build(context);

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
              children: pages,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class Leaderboard extends StatelessWidget {
  final PageController pageController;
  final LeaderboardType type;

  const Leaderboard({
    super.key,
    required this.pageController,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
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
                  onTap: () => pageController.animateToPage(
                    type == LeaderboardType.practicum ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  ),
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
            if (roleId == 1)
              LeaderboardContainer(
                padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
                onTap: () => navigatorKey.currentState!.pushNamed(
                  scoreRecapDetailRoute,
                  arguments: 'Wd. Ananda Lesmono',
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
                        '#4',
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
                            'Kamu telah memperoleh nilai 90.',
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
              )
            else
              LeaderboardContainer(
                padding: const EdgeInsets.all(16),
                onTap: () => navigatorKey.currentState!.pushNamed(scoreRecapListHomeRoute),
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
                  clipper: CustomClipPathSilver(),
                  height: 110,
                  color: const Color(0xFF9088E6),
                ),
                LeaderboardRank(
                  rank: 1,
                  rankType: LeaderboardRankType.gold,
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
                7,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    bottom: index == 6 ? kBottomNavigationBarHeight : 10,
                  ),
                  child: UserCard(
                    user: CredentialSaver.credential!,
                    badgeType: UserBadgeType.text,
                    badgeText: 'Nilai: 80.0',
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
  final CustomClipper<Path> clipper;
  final double height;
  final Color? color;
  final LinearGradient? gradient;

  const LeaderboardRank({
    super.key,
    required this.rank,
    required this.rankType,
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
              const CircleNetworkImage(
                imageUrl: 'https://placehold.co/100x100/png',
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
            'Rafly',
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
            text: '98.0',
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
