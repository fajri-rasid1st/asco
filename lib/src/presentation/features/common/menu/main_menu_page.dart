// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/menus/meeting_home_page.dart';
import 'package:asco/src/presentation/shared/widgets/drawer_menu/drawer_menu_widget.dart';

final selectedMainMenuProvider = StateProvider.autoDispose<int>((ref) => 0);

class MainMenuPage extends ConsumerWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const roleId = 1;

    final pages = [
      const MeetingHomePage(roleId: roleId),
      const Scaffold(
        body: Center(
          child: Text('Asistensi'),
        ),
      ),
      const Scaffold(
        body: Center(
          child: Text('Leaderboard'),
        ),
      ),
      const Scaffold(
        body: Center(
          child: Text('Extras'),
        ),
      ),
      const Scaffold(
        body: Center(
          child: Text('People'),
        ),
      ),
    ];

    final selectedIndex = ref.watch(selectedMainMenuProvider);

    return DrawerMenuWidget(
      selectedIndex: selectedIndex,
      showNavigationBar: selectedIndex == -2 ? false : true,
      onSelected: (index) => ref.read(selectedMainMenuProvider.notifier).state = index,
      child: Builder(
        builder: (context) {
          if (selectedIndex == -2) {
            // Navigate to profile page, according to roleId
            return const Scaffold();
          }

          if (selectedIndex == -1) {
            // Navigate to home page
            WidgetsBinding.instance.addPostFrameCallback((_) {
              navigatorKey.currentState!.pushNamedAndRemoveUntil(
                homeRoute,
                (route) => false,
              );
            });

            return const Scaffold();
          }

          return IndexedStack(
            index: selectedIndex,
            children: pages,
          );
        },
      ),
    );
  }
}
