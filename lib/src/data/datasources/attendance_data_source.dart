// Dart imports:
import 'dart:io';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:asco/core/configs/api_configs.dart';
import 'package:asco/core/errors/exceptions.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/data_response.dart';
import 'package:asco/src/data/models/attendances/attendance.dart';
import 'package:asco/src/data/models/attendances/attendance_meeting.dart';

abstract class AttendanceDataSource {
  /// Student: Get attendances
  Future<List<Attendance>> getAttendances(String practicumId);

  /// Admin: Get attendance meetings
  Future<List<AttendanceMeeting>> getAttendanceMeetings(String practicumId);

  /// Admin: Get attendances by meeting id
  Future<List<Attendance>> getMeetingAttendances(
    String meetingId, {
    String classroomId = '',
  });

  // TODO: need implemented in Provider
  /// Assistant: Insert all attendances in a meeting
  Future<void> insertMeetingAttendances(String meetingId);
}

class AttendanceDataSourceImpl implements AttendanceDataSource {
  final http.Client client;

  const AttendanceDataSourceImpl({required this.client});

  @override
  Future<List<Attendance>> getAttendances(String practicumId) async {
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
  Future<List<AttendanceMeeting>> getAttendanceMeetings(String practicumId) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/practicums/$practicumId/meetings/attendances'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        final data = result.data as List;

        return data.map((e) => AttendanceMeeting.fromJson(e)).toList();
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<List<Attendance>> getMeetingAttendances(
    String meetingId, {
    String classroomId = '',
  }) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/meetings/$meetingId/attendances'),
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
  Future<void> insertMeetingAttendances(String meetingId) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/meetings/$meetingId/attendances/v2'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
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
