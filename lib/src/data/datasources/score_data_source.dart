// Dart imports:
import 'dart:io';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:asco/core/configs/api_configs.dart';
import 'package:asco/core/enums/model_attributes.dart';
import 'package:asco/core/errors/exceptions.dart';
import 'package:asco/core/extensions/iterable_extension.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/data_response.dart';
import 'package:asco/src/data/models/scores/score_recap.dart';

abstract class ScoreDataSource {
  /// Admin, Assistant, Student: Get scores
  Future<List<ScoreRecap>> getScores(
    String practicumId, {
    String query = '',
    ScoreAttribute sortedBy = ScoreAttribute.username,
    bool asc = true,
  });

  /// Admin, Assistant: Get student score detail
  Future<ScoreRecap> getStudentScoreDetail(
    String practicumId,
    String username,
  );

  /// Student: Get score detail
  Future<ScoreRecap> getScoreDetail(String practicumId);
}

class ScoreDataSourceImpl implements ScoreDataSource {
  final http.Client client;

  const ScoreDataSourceImpl({required this.client});

  @override
  Future<List<ScoreRecap>> getScores(
    String practicumId, {
    String query = '',
    ScoreAttribute sortedBy = ScoreAttribute.username,
    bool asc = true,
  }) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/practicums/$practicumId/scores'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        final data = result.data as List;

        return data.map((e) {
          return ScoreRecap.fromJson(e);
        }).where((e) {
          final username = e.student!.username!.toLowerCase();
          final fullname = e.student!.fullname!.toLowerCase();
          final keyword = query.toLowerCase();

          return username.contains(keyword) || fullname.contains(keyword);
        }).sortedBy((e) {
          switch (sortedBy) {
            case ScoreAttribute.username:
              return e.student!.username!;
            case ScoreAttribute.fullname:
              return e.student!.fullname!;
            case ScoreAttribute.finalScore:
              return e.finalScore!;
            case ScoreAttribute.labExamScore:
              return e.labExamScore!;
          }
        }, asc: asc);
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<ScoreRecap> getStudentScoreDetail(
    String practicumId,
    String username,
  ) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/practicums/$practicumId/students/$username/scores'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        final score = ScoreRecap.fromJson(result.data);

        return score.copyWith(
          assignmentScores: score.assignmentScores?.sortedBy((e) => e.meetingNumber!),
          quizScores: score.quizScores?.sortedBy((e) => e.meetingNumber!),
          responseScores: score.responseScores?.sortedBy((e) => e.meetingNumber!),
        );
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<ScoreRecap> getScoreDetail(String practicumId) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/practicums/$practicumId/students/scores'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        final score = ScoreRecap.fromJson(result.data);

        return score.copyWith(
          assignmentScores: score.assignmentScores?.sortedBy((e) => e.meetingNumber!),
          quizScores: score.quizScores?.sortedBy((e) => e.meetingNumber!),
          responseScores: score.responseScores?.sortedBy((e) => e.meetingNumber!),
        );
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }
}
