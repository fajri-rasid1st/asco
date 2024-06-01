// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/features/home/widgets/course_card.dart';
import 'package:asco/src/presentation/features/menu/widgets/drawer_menu_widget.dart';
import 'package:asco/src/presentation/shared/widgets/asco_app_bar.dart';

class HomePage extends StatefulWidget {
  final int roleId;

  const HomePage({super.key, required this.roleId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ValueNotifier<int> selectedIndex;

  @override
  void initState() {
    super.initState();

    selectedIndex = ValueNotifier(-1);
  }

  @override
  void dispose() {
    super.dispose();

    selectedIndex.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedIndex,
      builder: (context, selectedIndex, child) {
        return DrawerMenuWidget(
          isMainMenu: false,
          showNavigationBar: false,
          selectedIndex: selectedIndex,
          onSelected: (index) => this.selectedIndex.value = index,
          child: Builder(
            builder: (context) {
              if (selectedIndex == -2) {
                // Navigate to profile page, according to roleId
              }

              if (selectedIndex == 6) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  this.selectedIndex.value = 0;

                  context.showConfirmDialog(
                    title: 'Log Out?',
                    message: 'Dengan ini seluruh sesi Anda akan berakhir.',
                    primaryButtonText: 'Log Out',
                    onPressedPrimaryButton: () {
                      navigatorKey.currentState!.pushNamedAndRemoveUntil(
                        onBoardingRoute,
                        (route) => false,
                      );
                    },
                  );
                });
              }

              return Scaffold(
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const AscoAppBar(),
                        const SizedBox(height: 24),
                        ...List<Padding>.generate(
                          3,
                          (index) => Padding(
                            padding: EdgeInsets.only(
                              bottom: index == 2 ? 0 : 12,
                            ),
                            child: CourseCard(
                              badgePath: AssetPath.getVector('badge_android.svg'),
                              title: setTitleText('Pemrograman Mobile', 'A'),
                              time: setTimeText('Rabu', '10.10 - 12.40'),
                              backgroundColor: Palette.purple3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String setTitleText(String? text1, String? text2) {
    return '${text1 ?? ''} ${text2 ?? ''}';
  }

  String setTimeText(String? day, String? time) {
    return 'Setiap hari ${day ?? ''}, Pukul ${time ?? ''}';
  }
}
