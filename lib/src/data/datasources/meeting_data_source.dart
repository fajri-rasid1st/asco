// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

// Project imports:
import 'package:asco/core/configs/api_configs.dart';
import 'package:asco/core/errors/exceptions.dart';
import 'package:asco/core/services/file_service.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/data_response.dart';
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/meetings/meeting_post.dart';

abstract class MeetingDataSource {
  /// Get meetings
  Future<List<Meeting>> getMeetings(String practicumId);

  /// Get meeting detail
  Future<Meeting> getMeetingDetail(String id);

  /// Add meeting to practicum
  Future<void> addMeetingToPracticum(String practicumId, {required MeetingPost meeting});

  /// Edit meeting
  Future<void> editMeeting(Meeting oldMeeting, MeetingPost newMeeting);

  /// Delete meeting
  Future<void> deleteMeeting(String id);
}

class MeetingDataSourceImpl implements MeetingDataSource {
  final http.Client client;

  const MeetingDataSourceImpl({required this.client});

  @override
  Future<List<Meeting>> getMeetings(String practicumId) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/practicums/$practicumId/meetings'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        final data = result.data as List;

        return data.map((e) => Meeting.fromJson(e)).toList();
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<Meeting> getMeetingDetail(String id) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/meetings/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        return Meeting.fromJson(result.data);
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> addMeetingToPracticum(String practicumId, {required MeetingPost meeting}) async {
    final modulePath =
        meeting.modulePath != null ? await FileService.uploadFile(meeting.modulePath!) : null;

    final assignmentPath = meeting.assignmentPath != null
        ? await FileService.uploadFile(meeting.assignmentPath!)
        : null;

    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/practicums/$practicumId/meetings'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode(
          meeting
              .copyWith(
                modulePath: modulePath,
                assignmentPath: assignmentPath,
              )
              .toJson(),
        ),
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode != 201) {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> editMeeting(Meeting oldMeeting, MeetingPost newMeeting) async {
    try {
      final isModuleUpdated = newMeeting.modulePath != null &&
          p.basename(oldMeeting.modulePath ?? '') != p.basename(newMeeting.modulePath!);

      final isAssignmentUpdated = newMeeting.assignmentPath != null &&
          p.basename(oldMeeting.assignmentPath ?? '') != p.basename(newMeeting.assignmentPath!);

      final modulePath = isModuleUpdated
          ? await FileService.uploadFile(newMeeting.modulePath!)
          : oldMeeting.modulePath != null
              ? p.basename(oldMeeting.modulePath!)
              : null;

      final assignmentPath = isAssignmentUpdated
          ? await FileService.uploadFile(newMeeting.assignmentPath!)
          : oldMeeting.assignmentPath != null
              ? p.basename(oldMeeting.assignmentPath!)
              : null;

      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/meetings/${oldMeeting.id}'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode(
          newMeeting
              .copyWith(
                modulePath: modulePath,
                assignmentPath: assignmentPath,
              )
              .toJson(),
        ),
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode != 200) {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> deleteMeeting(String id) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/meetings/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode != 200) {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }
}
