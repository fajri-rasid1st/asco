// Dart imports:
import 'dart:io';

// Package imports:
import 'package:excel/excel.dart';

// Project imports:
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/src/data/models/attendances/attendance.dart';
import 'package:asco/src/data/models/scores/score_recap.dart';

class ExcelHelper {
  static List<Map<String, String?>>? convertToData(String path) {
    try {
      final bytes = File(path).readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);

      List<Map<String, String?>> data = [];

      for (var table in excel.tables.keys) {
        List<String> keys = [];

        for (var cell in excel.tables[table]!.row(0)) {
          keys.add(cell!.value.toString());
        }

        for (var rows in excel.tables[table]!.rows.sublist(1)) {
          Map<String, String?> temp = {};

          for (var i = 0; i < keys.length; i++) {
            final value = rows[i]!.value;

            temp[keys[i]] = value.toString();
          }

          data.add(temp);
        }
      }

      return data;
    } catch (e) {
      return null;
    }
  }

  static void insertAttendanceToExcel({
    required Excel excel,
    required int sheetNumber,
    required List<Attendance> attendances,
  }) {
    // Rename first sheet
    if (sheetNumber == 1) {
      excel.rename('Sheet1', 'Pertemuan $sheetNumber');
    }

    // Get active sheet
    final sheet = excel.sheets['Pertemuan $sheetNumber']!;

    // Create header cell style
    final headerCellStyle = CellStyle(
      fontFamily: getFontFamily(FontFamily.Calibri),
      fontSize: 11,
      bold: true,
      textWrapping: TextWrapping.WrapText,
      verticalAlign: VerticalAlign.Center,
      horizontalAlign: HorizontalAlign.Center,
      leftBorder: Border(borderStyle: BorderStyle.Thin),
      rightBorder: Border(borderStyle: BorderStyle.Thin),
      topBorder: Border(borderStyle: BorderStyle.Thin),
      bottomBorder: Border(borderStyle: BorderStyle.Thin),
    );

    // Define header values
    final headers = [
      'No.',
      'NIM',
      'Nama Lengkap',
      'Status',
    ];

    // Set header values to cells
    for (var i = 0; i < headers.length; i++) {
      final cellIndex = CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0);

      sheet.cell(cellIndex)
        ..value = TextCellValue(headers[i])
        ..cellStyle = headerCellStyle;

      if (i == headers.length - 1) sheet.setColumnWidth(i, 16);
    }

    // Create data cell style
    final dataCellStyle = CellStyle(
      fontFamily: getFontFamily(FontFamily.Calibri),
      fontSize: 11,
      textWrapping: TextWrapping.WrapText,
      verticalAlign: VerticalAlign.Center,
      horizontalAlign: HorizontalAlign.Center,
      leftBorder: Border(borderStyle: BorderStyle.Thin),
      rightBorder: Border(borderStyle: BorderStyle.Thin),
      topBorder: Border(borderStyle: BorderStyle.Thin),
      bottomBorder: Border(borderStyle: BorderStyle.Thin),
    );

    // Set data values to cells
    // Column looping
    for (var i = 0; i < attendances.length; i++) {
      final attendance = attendances[i];

      final data = [
        (i + 1).toString(),
        attendance.student!.username!,
        attendance.student!.fullname!,
        MapHelper.readableAttendanceMap[attendance.status]!,
      ];

      // Row looping
      for (var j = 0; j < data.length; j++) {
        final cellIndex = CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1);
        final value = int.tryParse(data[j]);

        // Update cell value
        if (value != null) {
          sheet.cell(cellIndex).value = IntCellValue(value);
        } else {
          sheet.cell(cellIndex).value = TextCellValue(data[j]);
        }

        // Update cell style
        if (j == 2) {
          sheet.cell(cellIndex).cellStyle = dataCellStyle.copyWith(
            horizontalAlignVal: HorizontalAlign.Left,
          );
        } else if (j == 3) {
          String hexColor = switch (data.last) {
            'Hadir' => '#9D7DF5',
            'Alpa' => '#FA78A6',
            'Sakit' => '#FAC678',
            'Izin' => '#788DFA',
            _ => '#FFFFFF',
          };

          sheet.cell(cellIndex).cellStyle = dataCellStyle.copyWith(
            backgroundColorHexVal: ExcelColor.fromHexString(hexColor),
          );
        } else {
          sheet.cell(cellIndex).cellStyle = dataCellStyle;
        }
      }
    }

    sheet.setRowHeight(0, 25);
    sheet.setColumnAutoFit(0);
    sheet.setColumnWidth(1, 18);
    sheet.setColumnWidth(2, 36);
  }

  static void insertScoreToExcel({
    required Excel excel,
    required List<ScoreRecap> scores,
  }) {
    // Get active sheet
    final sheet = excel.sheets['Sheet1']!;

    // Create header cell style
    final headerCellStyle = CellStyle(
      fontFamily: getFontFamily(FontFamily.Calibri),
      fontSize: 11,
      bold: true,
      textWrapping: TextWrapping.WrapText,
      verticalAlign: VerticalAlign.Center,
      horizontalAlign: HorizontalAlign.Center,
      leftBorder: Border(borderStyle: BorderStyle.Thin),
      rightBorder: Border(borderStyle: BorderStyle.Thin),
      topBorder: Border(borderStyle: BorderStyle.Thin),
      bottomBorder: Border(borderStyle: BorderStyle.Thin),
    );

    // Define header values
    final headers = [
      'No.',
      'NIM',
      'Nama Lengkap',
      'Kuis',
      'Respons',
      'Praktikum',
      'Ujian Lab',
      'Nilai Akhir',
    ];

    // Set header values to cells
    for (var i = 0; i < headers.length; i++) {
      final cellIndex = CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0);

      sheet.cell(cellIndex)
        ..value = TextCellValue(headers[i])
        ..cellStyle = headerCellStyle;

      if (i > 2) sheet.setColumnWidth(i, 12);
    }

    // Create data cell style
    final dataCellStyle = CellStyle(
      fontFamily: getFontFamily(FontFamily.Calibri),
      fontSize: 11,
      textWrapping: TextWrapping.WrapText,
      verticalAlign: VerticalAlign.Center,
      horizontalAlign: HorizontalAlign.Center,
      leftBorder: Border(borderStyle: BorderStyle.Thin),
      rightBorder: Border(borderStyle: BorderStyle.Thin),
      topBorder: Border(borderStyle: BorderStyle.Thin),
      bottomBorder: Border(borderStyle: BorderStyle.Thin),
    );

    // Set data values to cells
    // Column looping
    for (var i = 0; i < scores.length; i++) {
      final score = scores[i];

      final data = [
        (i + 1).toString(),
        score.student!.username!,
        score.student!.fullname!,
        score.quizAverageScore!.toStringAsFixed(1),
        score.responseAverageScore!.toStringAsFixed(1),
        score.assignmentAverageScore!.toStringAsFixed(1),
        score.labExamScore!.toStringAsFixed(1),
        score.finalScore!.toStringAsFixed(1),
      ];

      // Row looping
      for (var j = 0; j < data.length; j++) {
        final cellIndex = CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1);
        final value = num.tryParse(data[j]);

        // Update cell value
        if (value != null) {
          if (j == 0) {
            sheet.cell(cellIndex).value = IntCellValue(value.toInt());
          } else {
            sheet.cell(cellIndex).value = DoubleCellValue(value.toDouble());
          }
        } else {
          sheet.cell(cellIndex).value = TextCellValue(data[j]);
        }

        // Update cell style
        if (j == 2) {
          sheet.cell(cellIndex).cellStyle = dataCellStyle.copyWith(
            horizontalAlignVal: HorizontalAlign.Left,
          );
        } else {
          sheet.cell(cellIndex).cellStyle = dataCellStyle;
        }
      }
    }

    sheet.setRowHeight(0, 25);
    sheet.setColumnAutoFit(0);
    sheet.setColumnWidth(1, 18);
    sheet.setColumnWidth(2, 36);
  }
}
