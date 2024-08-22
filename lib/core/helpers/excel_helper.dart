// Dart imports:
import 'dart:io';

// Package imports:
import 'package:excel/excel.dart';

// Project imports:
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/src/data/models/attendances/attendance.dart';

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

  static void insertAttendancesToExcel({
    required Excel excel,
    required int sheetNumber,
    required bool isLastSheet,
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
    final headers = ['No.', 'NIM', 'Nama Lengkap', 'Status'];

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
        MapHelper.getReadableAttendanceStatus(attendance.status)!,
      ];

      // Row looping
      for (var j = 0; j < data.length; j++) {
        final cellIndex = CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1);

        sheet.cell(cellIndex).value = TextCellValue(data[j]);

        if (j == 2) {
          sheet.cell(cellIndex).cellStyle = dataCellStyle.copyWith(
            horizontalAlignVal: HorizontalAlign.Left,
          );
        } else if (j == 3) {
          String hexColor = '#FFFFFF';

          switch (data.last) {
            case 'Hadir':
              hexColor = '#744BE4';
            case 'Alpa':
              hexColor = '#FA78A6';
            case 'Sakit':
              hexColor = '#FAC678';
            case 'Izin':
              hexColor = '#788DFA';
          }

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

    if (!isLastSheet) {
      excel.copy('Pertemuan $sheetNumber', 'Pertemuan ${sheetNumber + 1}');
    }
  }
}
