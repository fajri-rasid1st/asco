// Flutter imports:
import 'package:flutter/material.dart';

// Register the RouteObserver as a navigation observer
final routeObserver = RouteObserver<ModalRoute<void>>();

// App routes generator
Route<dynamic>? generateAppRoutes(RouteSettings settings) {
  switch (settings.name) {
    // case wrapperRoute:
    //   return MaterialPageRoute(
    //     builder: (_) => const Wrapper(),
    //   );
    default:
      return null;
  }
}
