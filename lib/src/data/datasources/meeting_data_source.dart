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
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/meetings/meeting_post.dart';

abstract class MeetingDataSource {
  /// Get meetings
  Future<List<Meeting>> getMeetings(String practicumId);

  /// Add meeting to practicum
  Future<void> addMeetingToPracticum(String practicumId, {required MeetingPost meeting});
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
  Future<void> addMeetingToPracticum(String practicumId, {required MeetingPost meeting}) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/practicums/$practicumId/meetings'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode(meeting.toJson()),
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
