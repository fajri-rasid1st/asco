// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/src/presentation/features/admin/home/pages/admin_home_page.dart';
import 'package:asco/src/presentation/features/admin/users/pages/user_detail_page.dart';
import 'package:asco/src/presentation/features/admin/users/pages/user_form_page.dart';
import 'package:asco/src/presentation/features/admin/users/pages/user_list_home_page.dart';
import 'package:asco/src/presentation/features/common/on_boarding_page.dart';
import 'package:asco/src/presentation/features/home/home_page.dart';
import 'package:asco/src/presentation/features/menu/main_menu_page.dart';

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
      return MaterialPageRoute(
        builder: (_) => const HomePage(),
      );
    case mainMenuRoute:
      return MaterialPageRoute(
        builder: (_) => const MainMenuPage(),
      );
    case adminHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const AdminHomePage(),
      );
    case userListHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const UserListHomePage(),
      );
    case userDetailRoute:
      return MaterialPageRoute(
        builder: (_) => const UserDetailPage(),
      );
    case userFormRoute:
      return MaterialPageRoute(
        builder: (_) => const UserFormPage(),
      );
    default:
      return null;
  }
}
