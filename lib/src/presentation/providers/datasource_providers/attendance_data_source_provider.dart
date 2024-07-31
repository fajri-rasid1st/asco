// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/core/utils/http_client.dart';
import 'package:asco/src/data/datasources/attendance_data_source.dart';

part 'attendance_data_source_provider.g.dart';

@riverpod
AttendanceDataSource attendanceDataSource(AttendanceDataSourceRef ref) {
  return AttendanceDataSourceImpl(client: HttpClient.client);
}
