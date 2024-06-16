// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/menus/assistance_page.dart';
import 'package:asco/src/presentation/shared/menus/extras_page.dart';
import 'package:asco/src/presentation/shared/menus/leaderboard_page.dart';
import 'package:asco/src/presentation/shared/menus/meeting_page.dart';
import 'package:asco/src/presentation/shared/menus/people_page.dart';
import 'package:asco/src/presentation/shared/widgets/drawer_menu/drawer_menu_widget.dart';

final selectedMainMenuProvider = StateProvider.autoDispose<int>((ref) => 0);

class MainMenuPage extends ConsumerStatefulWidget {
  const MainMenuPage({super.key});

  @override
  ConsumerState<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends ConsumerState<MainMenuPage> {
  late final List<Widget> pages;
  late final PageController pageController;

  @override
  void initState() {
    super.initState();

    pages = [
      const MeetingPage(),
      const AssistancePage(),
      const LeaderboardPage(),
      const ExtrasPage(),
      const PeoplePage(),
    ];
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();

    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedMainMenuProvider);

    ref.listen(
      selectedMainMenuProvider,
      (previous, next) {
        if (next == -2) {
          ref.read(selectedMainMenuProvider.notifier).state = previous ?? 0;

          // Navigate to profile page
        }

        if (next == -1) {
          navigatorKey.currentState!.pushNamedAndRemoveUntil(
            homeRoute,
            (route) => false,
          );
        }
      },
    );

    return DrawerMenuWidget(
      selectedIndex: selectedIndex,
      showNavigationBar: selectedIndex != -2 ? true : false,
      onSelected: (index) {
        if (index >= 0) pageController.jumpToPage(index);

        ref.read(selectedMainMenuProvider.notifier).state = index;
      },
      child: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
      ),
    );
  }
}
