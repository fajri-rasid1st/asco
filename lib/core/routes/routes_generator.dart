// Flutter imports:
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/src/presentation/features/common/on_boarding_page.dart';
import 'package:flutter/material.dart';

// Register the RouteObserver as a navigation observer
final routeObserver = RouteObserver<ModalRoute<void>>();

// App routes generator
Route<dynamic>? generateAppRoutes(RouteSettings settings) {
  switch (settings.name) {
    case onBoardingRoute:
      return MaterialPageRoute(
        builder: (_) => const OnBoardingPage(),
      );
    default:
      return null;
  }
}
