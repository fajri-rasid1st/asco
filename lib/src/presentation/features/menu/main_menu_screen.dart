// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/features/menu/widgets/drawer_menu_widget.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  late final ValueNotifier<int> selectedIndex;

  @override
  void initState() {
    super.initState();

    selectedIndex = ValueNotifier(0);
  }

  @override
  void dispose() {
    super.dispose();

    selectedIndex.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const Scaffold(
        body: Center(
          child: Text('Pertemuan'),
        ),
      ),
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

    return ValueListenableBuilder(
      valueListenable: selectedIndex,
      builder: (context, selectedIndex, child) {
        return DrawerMenuWidget(
          selectedIndex: selectedIndex,
          showNavigationBar: selectedIndex == -2 ? false : true,
          onSelected: (index) => this.selectedIndex.value = index,
          child: Builder(
            builder: (context) {
              if (selectedIndex == -2) {
                // Navigate to profile page, according to roleId
                return const Scaffold();
              }

              if (selectedIndex == -1) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  navigatorKey.currentState!.pushNamedAndRemoveUntil(
                    homeRoute,
                    arguments: 1,
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
      },
    );
  }
}
