// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/providers/manual_providers/search_provider.dart';
import 'package:asco/src/presentation/shared/widgets/animated_fab.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/search_field.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class ScoreRecapListHomePage extends ConsumerStatefulWidget {
  const ScoreRecapListHomePage({super.key});

  @override
  ConsumerState<ScoreRecapListHomePage> createState() => _ScoreRecapListHomePageState();
}

class _ScoreRecapListHomePageState extends ConsumerState<ScoreRecapListHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController fabAnimationController;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    fabAnimationController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
    )..forward();

    scrollController = ScrollController()..addListener(() {});
  }

  @override
  void dispose() {
    super.dispose();

    fabAnimationController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(queryProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Rekap Nilai - Pemrograman Mobile',
        action: IconButton(
          onPressed: () => context.showSortingDialog(
            items: ['Nilai', 'NIM', 'Nama Lengkap'],
            values: ['score', 'username', 'fullname'],
            onSubmitted: (value) {},
          ),
          icon: const Icon(Icons.filter_list_rounded),
          tooltip: 'Urutkan',
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
          ),
        ),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) => FunctionHelper.handleFabVisibilityOnScroll(
          fabAnimationController,
          notification,
        ),
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              backgroundColor: Palette.scaffoldBackground,
              surfaceTintColor: Palette.scaffoldBackground,
              flexibleSpace: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: SearchField(
                  text: query,
                  hintText: 'Cari nama atau NIM',
                  onChanged: (value) => ref.read(queryProvider.notifier).state = value,
                ),
              ),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(20),
                child: SizedBox(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: EdgeInsets.only(
                      bottom: index == 9 ? 0 : 10,
                    ),
                    child: UserCard(
                      badgeText: 'Kelas A',
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(
                          '100',
                          style: textTheme.titleLarge!.copyWith(
                            color: Palette.purple2,
                          ),
                        ),
                      ),
                      onTap: () => navigatorKey.currentState!.pushNamed(
                        scoreRecapDetailRoute,
                        arguments: 'Wd. Ananda Lesmono',
                      ),
                    ),
                  ),
                  childCount: 10,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedFloatingActionButton(
        animationController: fabAnimationController,
        onPressed: () {},
        tooltip: 'Export ke Excel',
        child: SvgAsset(
          AssetPath.getIcon('file_excel_outlined.svg'),
          width: 26,
        ),
      ),
    );
  }
}
