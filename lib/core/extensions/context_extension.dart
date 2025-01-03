// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/services/file_service.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/core/utils/widget_utils.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/profile_picture_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/sorting_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';

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

  void showNoConnectionSnackBar() {
    scaffoldMessengerKey.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(
        WidgetUtils.createSnackBar(
          title: 'Tidak Ada Koneksi',
          message: 'Hubungkan perangkat dengan koneksi internet, lalu coba lagi.',
          type: SnackBarType.error,
        ),
      );
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
    required List values,
    required Enum sortedBy,
    required bool asc,
    void Function(Map<String, dynamic> value)? onSubmitted,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => SortingDialog(
        items: items,
        values: values,
        sortedBy: sortedBy,
        asc: asc,
        onSubmitted: onSubmitted,
      ),
    );
  }

  Future<Object?> showProfilePictureDialog(String? imageUrl) {
    return showGeneralDialog(
      context: this,
      barrierLabel: 'profile_picture',
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: anim1,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
      pageBuilder: (_, __, ___) => ProfilePictureDialog(imageUrl: imageUrl),
    );
  }
}

extension TimePickerExtension on BuildContext {
  Future<TimeOfDay?> showCustomTimePicker({
    required TimeOfDay initialTime,
    required GlobalKey<FormBuilderState> formKey,
    required String fieldKey,
    String? helpText,
  }) async {
    final time = await showTimePicker(
      context: this,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      helpText: helpText,
      minuteLabelText: 'Menit',
      hourLabelText: 'Jam',
      cancelText: 'Kembali',
      confirmText: 'Konfirmasi',
      errorInvalidText: 'Masukkan waktu yang valid',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (time != null) {
      formKey.currentState?.fields[fieldKey]?.didChange(time.format(this));
    }

    return time;
  }
}

extension DatePickerExtension on BuildContext {
  Future<DateTime?> showCustomDatePicker({
    required DateTime initialdate,
    required DateTime firstDate,
    required DateTime lastDate,
    required GlobalKey<FormBuilderState> formKey,
    required String fieldKey,
    String? helpText,
  }) async {
    final date = await showDatePicker(
      context: this,
      initialDate: initialdate,
      firstDate: firstDate,
      lastDate: lastDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: helpText,
      cancelText: 'Kembali',
      confirmText: 'Konfirmasi',
      locale: const Locale('id', 'ID'),
    );

    if (date != null) {
      formKey.currentState?.fields[fieldKey]?.didChange(DateFormat('d/M/yyyy').format(date));
    }

    return date;
  }
}

extension ProviderResponseExtension on BuildContext {
  Null responseError(Object e, StackTrace st) {
    if (e == kNoInternetConnection) {
      showNoConnectionSnackBar();
    } else {
      showSnackBar(
        title: 'Terjadi Kesalahan',
        message: '$e',
        type: SnackBarType.error,
      );
    }
  }
}

extension FileExtension on BuildContext {
  void openFile({required String name, String? path}) {
    if (path != null && path.isNotEmpty) {
      final isUrl = Uri.tryParse(path)?.isAbsolute ?? false;

      FileService.openFile(path, isUrl);
    } else {
      showSnackBar(
        title: 'File Tidak Ada',
        message: 'File ${name.toLowerCase()} belum dimasukkan.',
        type: SnackBarType.info,
      );
    }
  }

  void openUrl({required String name, required String url}) {
    if (url.split('/').last.isNotEmpty) {
      FunctionHelper.openUrl(url);
    } else {
      showSnackBar(
        title: '$name Tidak Ada',
        message: 'Pengguna belum memasukkan username $name.',
        type: SnackBarType.info,
      );
    }
  }
}
