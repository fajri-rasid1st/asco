// Dart imports:
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class FunctionHelper {
  static String nextLetter(String letter) {
    if (letter.length != 1 || !RegExp(r'^[A-Z]$').hasMatch(letter)) {
      throw ArgumentError('Input must be a single uppercase alphabet letter.');
    }

    final code = letter.codeUnitAt(0);

    if (letter == 'Z') return 'A';

    return String.fromCharCode(code + 1);
  }

  static Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  static Future<bool> requestPermission(Permission permission) async {
    if (await permission.isDenied) {
      final result = await permission.request();

      if (result.isGranted) return true;
      if (result.isDenied || result.isPermanentlyDenied) return false;
    }

    return true;
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

  static Future<int> get androidApiLevel async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      return androidInfo.version.sdkInt;
    }

    return 0;
  }
}
