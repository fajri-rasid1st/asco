// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/core/utils/widget_utils.dart';
import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  void back() {
    navigatorKey.currentState?.pop();
  }
}

extension DialogExtension on BuildContext {
  Future<Object?> showLoadingDialog() {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => const LoadingIndicator(),
    );
  }
}

extension SnackBarExtension on BuildContext {
  void showBanner({
    required String message,
    required SnackBarType type,
  }) {
    final snackBar = WidgetUtils.createSnackBar(
      message: message,
      type: type,
    );

    scaffoldMessengerKey.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

extension ModalBottomSheetExtension on BuildContext {
  Future<Object?> showNetworkErrorModalBottomSheet({
    VoidCallback? onPressedPrimaryButton,
  }) {
    return showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => NetworkErrorBottomSheet(
        onPressedPrimaryButton: onPressedPrimaryButton,
      ),
    );
  }
}
