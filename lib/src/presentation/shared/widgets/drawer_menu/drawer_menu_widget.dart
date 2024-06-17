// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/src/presentation/shared/widgets/drawer_menu/drawer_menu_content.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class DrawerMenuWidget extends StatefulWidget {
  final bool isMainMenu;
  final bool showNavigationBar;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Widget child;

  const DrawerMenuWidget({
    super.key,
    this.isMainMenu = true,
    this.showNavigationBar = true,
    required this.selectedIndex,
    required this.onSelected,
    required this.child,
  });

  @override
  State<DrawerMenuWidget> createState() => _DrawerMenuWidgetState();
}

class _DrawerMenuWidgetState extends State<DrawerMenuWidget> with SingleTickerProviderStateMixin {
  late final ValueNotifier<bool> isDrawerClosed;
  late final AnimationController animationController;
  late final Animation<double> animation;
  late final Animation<double> scaleAnimation;
  late final Animation<double> radiusAnimation;

  bool isDragging = false;

  @override
  void initState() {
    super.initState();

    isDrawerClosed = ValueNotifier(true);

    animationController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
    )..addListener(() => setState(() {}));

    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    radiusAnimation = Tween<double>(begin: 0, end: 16).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    isDrawerClosed.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDrawerClosed,
      builder: (context, closed, child) {
        return Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          backgroundColor: Palette.black2,
          body: SafeArea(
            child: PopScope(
              canPop: false,
              onPopInvoked: (didPop) {
                if (didPop) return;

                if (!closed) {
                  animationController.reverse();
                  isDrawerClosed.value = true;
                } else {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                }
              },
              child: GestureDetector(
                onHorizontalDragStart: (details) => isDragging = true,
                onHorizontalDragUpdate: (details) {
                  if (!isDragging && closed) return;

                  const delta = 1;

                  if (details.delta.dx < -delta) {
                    animationController.reverse();
                    isDrawerClosed.value = true;
                  } else if (details.delta.dx > delta) {
                    animationController.forward();
                    isDrawerClosed.value = false;
                  }

                  isDragging = false;
                },
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      width: AppSize.getAppWidth(context) * .7,
                      height: AppSize.getAppHeight(context),
                      left: closed ? -AppSize.getAppWidth(context) * .7 : 0,
                      duration: kThemeAnimationDuration,
                      curve: Curves.fastOutSlowIn,
                      child: DrawerMenuContent(
                        isMainMenu: widget.isMainMenu,
                        selectedIndex: widget.selectedIndex,
                        onSelected: (value) {
                          widget.onSelected(value);
                          animationController.reverse();
                          isDrawerClosed.value = true;
                        },
                      ),
                    ),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(animation.value - 30 * animation.value * pi / 180),
                      child: Transform.translate(
                        offset: Offset(
                          animation.value * (AppSize.getAppWidth(context) * .7 - 15),
                          0,
                        ),
                        child: Transform.scale(
                          scale: scaleAnimation.value,
                          child: AnimatedContainer(
                            duration: kThemeAnimationDuration,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(radiusAnimation.value),
                              child: AbsorbPointer(
                                absorbing: closed ? false : true,
                                child: widget.child,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      top: 20,
                      left: closed ? 0 : AppSize.getAppWidth(context) * .7 - 40,
                      duration: kThemeAnimationDuration,
                      curve: Curves.fastOutSlowIn,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: GestureDetector(
                          onTap: () {
                            if (closed) {
                              animationController.forward();
                              isDrawerClosed.value = false;
                            } else {
                              animationController.reverse();
                              isDrawerClosed.value = true;
                            }
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Palette.background,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 2),
                                  color: Palette.primaryText.withOpacity(.2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: SvgAsset(
                              AssetPath.getIcon(
                                closed ? 'hamburger_outlined.svg' : 'close_outlined.svg',
                              ),
                              color: Palette.primaryText,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (widget.showNavigationBar)
                      AnimatedPositioned(
                        left: 0,
                        right: 0,
                        bottom: closed ? 0 : -kBottomNavigationBarHeight,
                        duration: kThemeAnimationDuration,
                        curve: Curves.fastOutSlowIn,
                        child: Container(
                          height: kBottomNavigationBarHeight,
                          decoration: const BoxDecoration(
                            color: Palette.black2,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            children: [
                              NavigationBarTabIcon(
                                selectedIcon: AssetPath.getIcon('class_filled.svg'),
                                unselectedIcon: AssetPath.getIcon('class_outlined.svg'),
                                isSelected: widget.selectedIndex == 0,
                                onTap: () => widget.onSelected(0),
                              ),
                              NavigationBarTabIcon(
                                selectedIcon: AssetPath.getIcon('assistance_filled.svg'),
                                unselectedIcon: AssetPath.getIcon('assistance_outlined.svg'),
                                isSelected: widget.selectedIndex == 1,
                                onTap: () => widget.onSelected(1),
                              ),
                              NavigationBarTabIcon(
                                selectedIcon: AssetPath.getIcon('leaderboard_filled.svg'),
                                unselectedIcon: AssetPath.getIcon('leaderboard_outlined.svg'),
                                isSelected: widget.selectedIndex == 2,
                                onTap: () => widget.onSelected(2),
                              ),
                              NavigationBarTabIcon(
                                selectedIcon: AssetPath.getIcon('extras_filled.svg'),
                                unselectedIcon: AssetPath.getIcon('extras_outlined.svg'),
                                isSelected: widget.selectedIndex == 3,
                                onTap: () => widget.onSelected(3),
                              ),
                              NavigationBarTabIcon(
                                selectedIcon: AssetPath.getIcon('people_filled.svg'),
                                unselectedIcon: AssetPath.getIcon('people_outlined.svg'),
                                isSelected: widget.selectedIndex == 4,
                                onTap: () => widget.onSelected(4),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class NavigationBarTabIcon extends StatelessWidget {
  final bool isSelected;
  final String selectedIcon;
  final String unselectedIcon;
  final VoidCallback onTap;

  const NavigationBarTabIcon({
    super.key,
    required this.isSelected,
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            AnimatedContainer(
              width: isSelected ? 24 : 0,
              height: 5,
              duration: kThemeAnimationDuration,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                color: Palette.purple3,
              ),
            ),
            Expanded(
              child: SvgAsset(
                isSelected ? selectedIcon : unselectedIcon,
                color: isSelected ? Palette.purple3 : Palette.secondaryText.withOpacity(.5),
                width: 22,
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
