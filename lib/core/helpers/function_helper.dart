// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A collection of helper functions that are reusable for this app
class FunctionHelper {
  static String nextLetter(String letter) {
    if (letter.length != 1 || !RegExp(r'^[A-Z]$').hasMatch(letter)) {
      throw ArgumentError('Input must be a single uppercase alphabet letter.');
    }

    final code = letter.codeUnitAt(0);

    if (letter == 'Z') return 'A';

    return String.fromCharCode(code + 1);
  }

  static bool handleFabVisibilityOnScroll(
    AnimationController animationController,
    UserScrollNotification notification,
  ) {
    if (notification.depth != 0) return false;

    switch (notification.direction) {
      case ScrollDirection.forward:
        if (notification.metrics.maxScrollExtent != notification.metrics.minScrollExtent) {
          if (notification.metrics.pixels != 0) {
            animationController.forward();
          }
        }
        break;
      case ScrollDirection.reverse:
        if (notification.metrics.maxScrollExtent != notification.metrics.minScrollExtent) {
          animationController.reverse();
        }
        break;
      case ScrollDirection.idle:
        break;
    }

    return false;
  }
}
