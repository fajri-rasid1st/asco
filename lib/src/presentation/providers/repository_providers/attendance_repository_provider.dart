// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/repositories/attendance_repository.dart';
import 'package:asco/src/presentation/providers/datasource_providers/attendance_data_source_provider.dart';
import 'package:asco/src/presentation/providers/generated_providers/network_info_provider.dart';

part 'attendance_repository_provider.g.dart';

@riverpod
AttendanceRepository attendanceRepository(AttendanceRepositoryRef ref) {
  return AttendanceRepositoryImpl(
    attendanceDataSource: ref.watch(attendanceDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
