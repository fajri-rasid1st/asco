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

  static List<int>? createAttendanceDataExcel(List<Map<String, Object?>> data) {
    final excel = Excel.createExcel();

    final sheet = excel['attendance-class'];

    final headerCellStyle = CellStyle(
      backgroundColorHex: ExcelColor.yellow,
      fontFamily: getFontFamily(FontFamily.Calibri),
      fontSize: 12,
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
      data.length,
      (index) => 'Pertemuan ${data[index]['meetingNumber']}',
    );

    final headers = ['No.', 'NIM', 'Nama Lengkap', ...meetings];

    for (var i = 0; i < headers.length; i++) {
      final cellIndex1 = CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0);
      final cellIndex2 = CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 1);

      sheet.cell(cellIndex1)
        ..value = TextCellValue(headers[i])
        ..cellStyle = headerCellStyle;

      // sheet.merge(cellIndex1, cellIndex2);
    }

    return excel.save();
  }
}
