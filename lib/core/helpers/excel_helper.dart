// Dart imports:
import 'dart:io';

// Package imports:
import 'package:excel/excel.dart';

class ExcelHelper {
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

  static List<int>? createAttendanceDataExcel({
    required List<Map<String, Object>> data,
    required int totalAttendances,
  }) {
    final excel = Excel.createExcel();

    excel.setDefaultSheet('Kehadiran Kelas');

    final sheet = excel.sheets['Kehadiran Kelas']!;

    /// Create header
    final headerCellStyle = CellStyle(
      backgroundColorHex: ExcelColor.yellow,
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

    final meetings = List<String>.generate(
      totalAttendances,
      (index) => 'Pertemuan ${index + 1}',
    );

    final headers = ['No.', 'NIM', 'Nama Lengkap', ...meetings];

    for (var i = 0; i < headers.length; i++) {
      final cellIndex = CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0);

      sheet.cell(cellIndex)
        ..value = TextCellValue(headers[i])
        ..cellStyle = headerCellStyle;

      if (i >= 3) sheet.setColumnWidth(i, 16);
    }

    /// Create data
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

    for (var i = 0; i < data.length; i++) {
      final dataMap = data[i];

      final dataList = [
        (i + 1).toString(),
        dataMap['username'] as String,
        dataMap['fullname'] as String,
        ...(dataMap['attendanceStatus'] as List<String>),
      ];

      for (var j = 0; j < dataList.length; j++) {
        final cellIndex = CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1);

        sheet.cell(cellIndex).value = TextCellValue(dataList[j]);

        if (j != 2) {
          sheet.cell(cellIndex).cellStyle = dataCellStyle;
        } else {
          sheet.cell(cellIndex).cellStyle = dataCellStyle.copyWith(
            horizontalAlignVal: HorizontalAlign.Left,
          );
        }
      }
    }

    sheet.setRowHeight(0, 25);
    sheet.setColumnAutoFit(0);
    sheet.setColumnWidth(1, 18);
    sheet.setColumnWidth(2, 36);

    return excel.save();
  }
}
