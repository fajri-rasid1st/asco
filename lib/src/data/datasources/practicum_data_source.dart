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
import 'package:asco/src/data/models/classrooms/classroom_post.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/data/models/practicums/practicum_post.dart';
import 'package:asco/src/data/models/profiles/profile.dart';

abstract class PracticumDataSource {
  /// Get Practicums
  Future<List<Practicum>> getPracticums();

  /// Get practicum detail
  Future<Practicum> getPracticumDetail(String id);

  /// Create practicum
  Future<String> createPracticum(PracticumPost practicum);

  /// Edit practicum
  Future<String> editPracticum(String id, PracticumPost practicum);

  /// Delete practicum
  Future<void> deletePracticum(String id);

  /// Add classrooms and assistants to practicum
  Future<void> addClassroomsAndAssistantsToPracticum(
    String id, {
    required List<ClassroomPost> classrooms,
    required List<Profile> assistants,
  });
}

class PracticumDataSourceImpl implements PracticumDataSource {
  final http.Client client;

  PracticumDataSourceImpl({required this.client});

  @override
  Future<List<Practicum>> getPracticums() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/practicums'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        final data = result.data as List;

        return data.map((e) => Practicum.fromJson(e)).toList();
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<Practicum> getPracticumDetail(String id) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/practicums/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        return Practicum.fromJson(result.data);
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<String> createPracticum(PracticumPost practicum) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/practicums'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode(practicum.toJson()),
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode != 201) {
        throw ServerException(result.error?.code, result.error?.message);
      }

      return result.data as String;
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<String> editPracticum(String id, PracticumPost practicum) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/practicums/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode(practicum.toJson()),
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode != 200) {
        throw ServerException(result.error?.code, result.error?.message);
      }

      return result.data as String;
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> deletePracticum(String id) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/practicums/$id'),
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
  Future<void> addClassroomsAndAssistantsToPracticum(
    String id, {
    required List<ClassroomPost> classrooms,
    required List<Profile> assistants,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/practicums/$id/extras'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({
          'classrooms': classrooms.map((e) => e.toJson()).toList(),
          'assistants': assistants.map((e) => e.username).toList(),
        }),
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
