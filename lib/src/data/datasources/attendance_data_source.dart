// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:asco/core/configs/api_configs.dart';
import 'package:asco/core/errors/exceptions.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/data_response.dart';
import 'package:asco/src/data/models/attendances/attendance.dart';
import 'package:asco/src/data/models/attendances/attendance_post.dart';

abstract class AttendanceDataSource {
  /// Get attendances (student)
  Future<List<Attendance>> getStudentAttendances(String practicumId);

  /// Get attendances
  Future<List<Attendance>> getAttendances(String practicumId, String studentId);

  /// Add attendance for student in a meeting
  Future<void> createAttendance(String meetingId, {required AttendancePost attendance});
}

class AttendanceDataSourceImpl implements AttendanceDataSource {
  final http.Client client;

  const AttendanceDataSourceImpl({required this.client});

  @override
  Future<List<Attendance>> getStudentAttendances(String practicumId) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/practicums/$practicumId/attendances'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        final data = result.data as List;

        return data.map((e) => Attendance.fromJson(e)).toList();
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<List<Attendance>> getAttendances(String practicumId, String studentId) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/practicums/$practicumId/students/$studentId/attendances'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        final data = result.data as List;

        return data.map((e) => Attendance.fromJson(e)).toList();
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> createAttendance(String meetingId, {required AttendancePost attendance}) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/meetings/$meetingId/attendances'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode(attendance.toJson()),
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode != 201) {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }
}
