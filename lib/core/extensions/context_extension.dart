// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/core/utils/widget_utils.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/sorting_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';

extension DialogExtension on BuildContext {
  Future<Object?> showLoadingDialog() {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => const LoadingIndicator(),
    );
  }

  Future<Object?> showConfirmDialog({
    required String title,
    required String message,
    String? primaryButtonText,
    VoidCallback? onPressedPrimaryButton,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => ConfirmDialog(
        title: title,
        message: message,
        primaryButtonText: primaryButtonText,
        onPressedPrimaryButton: onPressedPrimaryButton,
      ),
    );
  }

  Future<Object?> showSortingDialog({
    required List<String> items,
    required List<String> values,
    void Function(Map<String, dynamic> value)? onSubmitted,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => SortingDialog(
        items: items,
        values: values,
        onSubmitted: onSubmitted,
      ),
    );
  }
}

extension SnackBarExtension on BuildContext {
  void showSnackBar({
    required String title,
    required String message,
    SnackBarType type = SnackBarType.success,
  }) {
    scaffoldMessengerKey.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(
        WidgetUtils.createSnackBar(
          title: title,
          message: message,
          type: type,
        ),
      );
  }
}
