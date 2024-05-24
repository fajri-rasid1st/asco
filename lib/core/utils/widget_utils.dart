// Flutter imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:flutter/material.dart';

/// A collection of widget utility functions that are reusable for this app
class WidgetUtils {
  /// Create a custom [SnackBar] widget.
  static SnackBar createSnackBar({
    required String message,
    required SnackBarType type,
    bool autoClose = true,
    Duration autoCloseDuration = const Duration(milliseconds: 3500),
    bool showOkButton = false,
  }) {
    return const SnackBar(content: Text(''));
  }
}
