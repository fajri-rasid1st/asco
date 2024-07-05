// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:excel/excel.dart';
import 'package:url_launcher/url_launcher.dart';

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

  static Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  static List<Map<String, Object?>>? excelToMap(String path) {
    try {
      final bytes = File(path).readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);

      List<Map<String, Object?>> data = [];

      for (var table in excel.tables.keys) {
        List<String> keys = [];

        for (var cell in excel.tables[table]!.row(0)) {
          keys.add(cell!.value.toString());
        }

        for (var rows in excel.tables[table]!.rows.sublist(1)) {
          Map<String, Object?> temp = {};

          for (var i = 0; i < keys.length; i++) {
            final cellValue = rows[i]!.value;

            Object? value = switch (cellValue) {
              FormulaCellValue() => cellValue.formula,
              TextCellValue() => cellValue.value,
              IntCellValue() => cellValue.value,
              DoubleCellValue() => cellValue.value,
              BoolCellValue() => cellValue.value,
              DateCellValue() => cellValue.asDateTimeUtc(),
              TimeCellValue() => cellValue.asDuration(),
              DateTimeCellValue() => cellValue.asDateTimeUtc(),
              null => null,
            };

            temp[keys[i]] = value;
          }

          data.add(temp);
        }
      }

      return data;
    } catch (e) {
      return null;
    }
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
