// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

// Project imports:
import 'package:asco/core/configs/api_configs.dart';
import 'package:asco/core/errors/exceptions.dart';
import 'package:asco/core/extensions/iterable_extension.dart';
import 'package:asco/core/services/file_service.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/data_response.dart';
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/meetings/meeting_post.dart';
import 'package:asco/src/data/models/meetings/meeting_schedule.dart';

abstract class MeetingDataSource {
  /// Admin: Get meetings
  Future<List<Meeting>> getMeetings(
    String practicumId, {
    String query = '',
    bool asc = true,
  });

  /// Admin: Get meeting detail
  Future<Meeting> getMeetingDetail(String id);

  /// Admin: Create meeting
  Future<void> createMeeting(
    String practicumId, {
    required MeetingPost meeting,
  });

  /// Admin: Edit meeting
  Future<void> editMeeting(
    Meeting oldMeeting,
    MeetingPost newMeeting,
  );

  /// Admin: Delete meeting
  Future<void> deleteMeeting(String id);

  /// Student, Assistant: Get classroom meetings
  Future<List<Meeting>> getClassroomMeetings(
    String classroomId, {
    bool asc = true,
  });

  /// Assistant: Get meeting schedules
  Future<List<MeetingSchedule>> getMeetingSchedules({String practicum = ''});
}

class MeetingDataSourceImpl implements MeetingDataSource {
  final http.Client client;

  const MeetingDataSourceImpl({required this.client});

  @override
  Future<List<Meeting>> getMeetings(
    String practicumId, {
    String query = '',
    bool asc = true,
  }) async {
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

        return data.map((e) {
          return Meeting.fromJson(e);
        }).where((e) {
          final lesson = e.lesson!.toLowerCase();
          final keyword = query.toLowerCase();

          return lesson.contains(keyword);
        }).sortedBy((e) {
          return e.number!;
        }, asc: asc);
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
  Future<void> createMeeting(
    String practicumId, {
    required MeetingPost meeting,
  }) async {
    try {
      final modulePath =
          meeting.modulePath != null ? await FileService.uploadFile(meeting.modulePath!) : null;

      final assignmentPath = meeting.assignmentPath != null
          ? await FileService.uploadFile(meeting.assignmentPath!)
          : null;

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
  Future<void> editMeeting(
    Meeting oldMeeting,
    MeetingPost newMeeting,
  ) async {
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

  @override
  Future<List<Meeting>> getClassroomMeetings(
    String classroomId, {
    bool asc = true,
  }) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/classes/$classroomId/meetings'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        final data = result.data as List;

        return data.map((e) => Meeting.fromJson(e)).sortedBy((e) => e.number!, asc: asc);
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<List<MeetingSchedule>> getMeetingSchedules({String practicum = ''}) async {
    try {
      final queryParam = practicum.isEmpty ? practicum : 'practicum=$practicum';

      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/users/meetings?$queryParam'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        final data = result.data as List;

        return data.map((e) => MeetingSchedule.fromJson(e)).sortedBy((e) => e.number!);
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }
}
