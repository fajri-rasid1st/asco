// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/src/presentation/shared/widgets/custom_snack_bar.dart';

/// A collection of widget utility functions that are reusable for this app
class WidgetUtils {
  /// Create custom snackbar
  ///
  /// - [title] The title of snackbar. If null, title will be an empty string
  ///
  /// - [message] The message of snackbar. Will be displayed under the title
  ///
  /// - [type] The type of snackbar. default to `SnackBarType.success`
  ///
  /// Its only create snackbar, not showing it. For showing snackbar, simply use:
  /// `ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(snackbar)`.
  static SnackBar createSnackBar({
    required String title,
    required String message,
    required SnackBarType type,
  }) {
    return SnackBar(
      elevation: 0,
      clipBehavior: Clip.none,
      backgroundColor: Colors.transparent,
      content: CustomSnackBar(
        title: title,
        message: message,
        type: type,
      ),
    );
  }
}
