// Dart imports:
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class ScreenshotProtector {
  static const _platform = MethodChannel('secureScreenshotChannel');

  static Future<void> disable() async {
    if (Platform.isAndroid) {
      await _disableScreenshotsAndroid();
    } else if (Platform.isIOS) {
      await _disableScreenshotsIOS();
    }
  }

  static Future<void> enable() async {
    if (Platform.isAndroid) {
      await _enableScreenshotsAndroid();
    } else if (Platform.isIOS) {
      await _enableScreenshotsIOS();
    }
  }

  static Future<void> _disableScreenshotsAndroid() async {
    try {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    } on PlatformException catch (e) {
      debugPrint("Error disable screenshots on Android: ${e.message}");
    }
  }

  static Future<void> _disableScreenshotsIOS() async {
    try {
      await _platform.invokeMethod('secureiOS');
    } on PlatformException catch (e) {
      debugPrint("Error disable screenshots on iOS: ${e.message}");
    }
  }

  static Future<void> _enableScreenshotsAndroid() async {
    try {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    } on PlatformException catch (e) {
      debugPrint("Error enable screenshots on Android: ${e.message}");
    }
  }

  static Future<void> _enableScreenshotsIOS() async {
    try {
      await _platform.invokeMethod('unSecureiOS');
    } on PlatformException catch (e) {
      debugPrint("Error enable screenshots on iOS: ${e.message}");
    }
  }
}
