// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/widget_utils.dart';
import 'package:law_app/features/shared/widgets/dialog/confirm_dialog.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_alert_dialog.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_selector_dialog.dart';
import 'package:law_app/features/shared/widgets/dialog/delete_confirm_dialog.dart';
import 'package:law_app/features/shared/widgets/dialog/single_form_dialog.dart';
import 'package:law_app/features/shared/widgets/dialog/single_form_text_area_dialog.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/network_error_bottom_sheet.dart';

extension NavigationExtension on BuildContext {
  void back() {
    scaffoldMessengerKey.currentState?.hideCurrentMaterialBanner();
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

  Future<Object?> showCustomInformationDialog({
    required String title,
    required Widget child,
  }) {
    return showDialog(
      context: this,
      builder: (_) => CustomDialog(
        showPrimaryButton: false,
        title: title,
        child: child,
      ),
    );
  }

  Future<Object?> showConfirmDialog({
    required String title,
    required String message,
    bool withCheckbox = false,
    String? checkboxLabel,
    String? primaryButtonText,
    VoidCallback? onPressedPrimaryButton,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => ConfirmDialog(
        title: title,
        message: message,
        withCheckbox: withCheckbox,
        checkboxLabel: checkboxLabel,
        primaryButtonText: primaryButtonText,
        onPressedPrimaryButton: onPressedPrimaryButton,
      ),
    );
  }

  Future<Object?> showDeleteConfirmDialog({
    required String title,
    VoidCallback? onIconPressed,
  }) {
    return showGeneralDialog(
      context: this,
      barrierLabel: '',
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, start, end) => Container(),
      transitionBuilder: (context, start, end, widget) {
        return DeleteConfirmDialog(
          start: start,
          title: title,
          onIconPressed: onIconPressed,
        );
      },
    );
  }

  Future<Object?> showCustomAlertDialog({
    required String title,
    required String message,
    Color? foregroundColor,
    Color? backgroundColor,
    bool withCheckbox = false,
    String? checkboxLabel,
    String? primaryButtonText,
    VoidCallback? onPressedPrimaryButton,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => CustomAlertDialog(
        title: title,
        message: message,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        withCheckbox: withCheckbox,
        checkboxLabel: checkboxLabel,
        primaryButtonText: primaryButtonText,
        onPressedPrimaryButton: onPressedPrimaryButton,
      ),
    );
  }

  Future<Object?> showCustomSelectorDialog({
    required String title,
    required List<Map<String, dynamic>> items,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => CustomSelectorDialog(
        title: title,
        items: items,
      ),
    );
  }

  Future<Object?> showSingleFormDialog({
    required String title,
    required String name,
    required String label,
    required String hintText,
    String? initialValue,
    int maxLines = 1,
    TextInputType textInputType = TextInputType.name,
    String? primaryButtonText,
    void Function(Map<String, dynamic> value)? onSubmitted,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => SingleFormDialog(
        title: title,
        name: name,
        label: label,
        hintText: hintText,
        initialValue: initialValue,
        maxLines: maxLines,
        textInputType: textInputType,
        primaryButtonText: primaryButtonText,
        onSubmitted: onSubmitted,
      ),
    );
  }

  Future<Object?> showSingleFormTextAreaDialog({
    required String title,
    String? textFieldInitialValue,
    required String textFieldName,
    required String textFieldLabel,
    required String textFieldHint,
    String? textAreaInitialValue,
    required String textAreaName,
    required String textAreaLabel,
    required String textAreaHint,
    int textAreaMaxLines = 5,
    String? primaryButtonText,
    void Function(Map<String, dynamic> value)? onSubmitted,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => SingleFormTextAreaDialog(
        title: title,
        textFieldInitialValue: textFieldInitialValue,
        textFieldName: textFieldName,
        textFieldLabel: textFieldLabel,
        textFieldHint: textFieldHint,
        textAreaInitialValue: textAreaInitialValue,
        textAreaName: textAreaName,
        textAreaLabel: textAreaLabel,
        textAreaHint: textAreaHint,
        textAreaMaxLines: textAreaMaxLines,
        primaryButtonText: primaryButtonText,
        onSubmitted: onSubmitted,
      ),
    );
  }
}

extension BannerExtension on BuildContext {
  void showBanner({
    required String message,
    required BannerType type,
  }) {
    final banner = WidgetUtils.createMaterialBanner(
      message: message,
      type: type,
    );

    scaffoldMessengerKey.currentState!
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(banner);
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
