// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/src/presentation/features/admin/home/pages/admin_home_page.dart';
import 'package:asco/src/presentation/features/admin/users/pages/users_home_page.dart';
import 'package:asco/src/presentation/features/common/on_boarding_page.dart';
import 'package:asco/src/presentation/features/home/home_page.dart';
import 'package:asco/src/presentation/features/menu/main_menu_screen.dart';

// Register the RouteObserver as a navigation observer
final routeObserver = RouteObserver<ModalRoute<void>>();

// App routes generator
Route<dynamic>? generateAppRoutes(RouteSettings settings) {
  switch (settings.name) {
    case onBoardingRoute:
      return MaterialPageRoute(
        builder: (_) => const OnBoardingPage(),
      );
    case homeRoute:
      final roleId = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => HomePage(roleId: roleId),
      );
    case mainMenuRoute:
      return MaterialPageRoute(
        builder: (_) => const MainMenuScreen(),
      );
    case adminHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const AdminHomePage(),
      );
    case usersHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const UsersHomePage(),
      );
    default:
      return null;
  }
}
