// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/src/presentation/features/admin/home/pages/admin_home_page.dart';
import 'package:asco/src/presentation/features/admin/practicums/pages/practicum_detail_page.dart';
import 'package:asco/src/presentation/features/admin/practicums/pages/practicum_form_page.dart';
import 'package:asco/src/presentation/features/admin/practicums/pages/practicum_list_home_page.dart';
import 'package:asco/src/presentation/features/admin/users/pages/user_detail_page.dart';
import 'package:asco/src/presentation/features/admin/users/pages/user_form_page.dart';
import 'package:asco/src/presentation/features/admin/users/pages/user_list_home_page.dart';
import 'package:asco/src/presentation/features/common/on_boarding_page.dart';
import 'package:asco/src/presentation/features/home/home_page.dart';
import 'package:asco/src/presentation/features/menu/main_menu_page.dart';
import 'package:asco/src/presentation/shared/pages/practicum_list_page.dart';

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
      final args = settings.arguments as UserFormPageArgs;

      return MaterialPageRoute(
        builder: (_) => UserFormPage(args: args),
      );
    case practicumListRoute:
      final args = settings.arguments as PracticumListPageArgs;

      return MaterialPageRoute(
        builder: (_) => PracticumListPage(args: args),
      );
    case practicumListHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const PracticumListHomePage(),
      );
    case practicumDetailRoute:
      return MaterialPageRoute(
        builder: (_) => const PracticumDetailPage(),
      );
    case practicumFirstFormRoute:
      final args = settings.arguments as PracticumFormPageArgs;

      return MaterialPageRoute(
        builder: (_) => PracticumFirstFormPage(args: args),
      );
    case practicumSecondFormRoute:
      final args = settings.arguments as PracticumFormPageArgs;

      return MaterialPageRoute(
        builder: (_) => PracticumSecondFormPage(args: args),
      );
    default:
      return null;
  }
}
