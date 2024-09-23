// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/classrooms/classroom.dart';
import 'package:asco/src/presentation/features/common/menu/pages/assistance_page.dart';
import 'package:asco/src/presentation/features/common/menu/pages/extras_page.dart';
import 'package:asco/src/presentation/features/common/menu/pages/leaderboard_page.dart';
import 'package:asco/src/presentation/features/common/menu/pages/meeting_page.dart';
import 'package:asco/src/presentation/features/common/menu/pages/people_page.dart';
import 'package:asco/src/presentation/shared/widgets/drawer_menu/drawer_menu_widget.dart';

final selectedMainMenuProvider = StateProvider.autoDispose<int>((ref) => 0);

class MainMenuPage extends ConsumerStatefulWidget {
  final Classroom classroom;

  const MainMenuPage({super.key, required this.classroom});

  @override
  ConsumerState<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends ConsumerState<MainMenuPage> {
  late final PageController pageController;
  late final List<Widget> pages;

  @override
  void initState() {
    pageController = PageController();

    pages = [
      MeetingPage(classroom: widget.classroom),
      const AssistancePage(),
      const LeaderboardPage(),
      const ExtrasPage(),
      const PeoplePage(),
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
    final selectedIndex = ref.watch(selectedMainMenuProvider);

    ref.listen(
      selectedMainMenuProvider,
      (previous, next) {
        if (next == -2) {
          ref.read(selectedMainMenuProvider.notifier).state = previous ?? 0;

          navigatorKey.currentState!.pushNamed(
            MapHelper.getRoleId(CredentialSaver.credential?.role) == 1
                ? studentProfileRoute
                : assistantProfileRoute,
          );
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
