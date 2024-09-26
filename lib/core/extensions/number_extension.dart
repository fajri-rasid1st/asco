// Package imports:
import 'package:intl/intl.dart';

extension DecimalPattern on int {
  String toDecimalPattern() {
    return NumberFormat.decimalPattern('id_ID').format(this);
  }
}

extension StringDateTime on int {
  String to24TimeFormat() {
    final hours = this ~/ 60;
    final minutes = this % 60;

    return "$hours:${minutes.toString().padLeft(2, '0')}";
  }

  String toDateTimeFormat(String? pattern) {
    final date = DateTime.fromMillisecondsSinceEpoch(this * 1000);

    return DateFormat(pattern, 'id_ID').format(date);
  }
}
