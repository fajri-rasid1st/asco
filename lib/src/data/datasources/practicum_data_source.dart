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
import 'package:asco/src/data/models/classrooms/classroom_post.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/data/models/practicums/practicum_post.dart';
import 'package:asco/src/data/models/profiles/profile.dart';

abstract class PracticumDataSource {
  /// Admin, Assistant: Get Practicums
  Future<List<Practicum>> getPracticums();

  /// Admin: Get practicum detail
  Future<Practicum> getPracticumDetail(String id);

  /// Admin: Create practicum
  Future<String> createPracticum(PracticumPost practicum);

  /// Admin: Edit practicum
  Future<String> editPracticum(
    Practicum oldPracticum,
    PracticumPost newPracticum,
  );

  /// Admin: Delete practicum
  Future<void> deletePracticum(String id);

  /// Admin: Create classrooms and assistants
  Future<void> createClassroomsAndAssistants(
    String id, {
    required List<ClassroomPost> classrooms,
    required List<Profile> assistants,
  });

  /// Admin: Remove classroom from practicum
  Future<void> removeClassroomFromPracticum(String classroomId);

  /// Admin: Remove assistant from practicum
  Future<void> removeAssistantFromPracticum(
    String id, {
    required Profile assistant,
  });
}

class PracticumDataSourceImpl implements PracticumDataSource {
  final http.Client client;

  const PracticumDataSourceImpl({required this.client});

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
        final practicums = data.map((e) => Practicum.fromJson(e)).toList();

        return practicums.map((e) {
          return e.copyWith(
            classrooms: e.classrooms?.sortedBy((e) => e.name!),
          );
        }).toList();
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
        final practicum = Practicum.fromJson(result.data);

        return practicum.copyWith(
          classrooms: practicum.classrooms?.sortedBy((e) => e.name!),
        );
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
      final badgePath = await FileService.uploadFile(practicum.badgePath) ?? '';

      final courseContractPath = practicum.courseContractPath != null
          ? await FileService.uploadFile(practicum.courseContractPath!)
          : null;

      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/practicums'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode(
          practicum
              .copyWith(
                badgePath: badgePath,
                courseContractPath: courseContractPath,
              )
              .toJson(),
        ),
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
  Future<String> editPracticum(
    Practicum oldPracticum,
    PracticumPost newPracticum,
  ) async {
    try {
      final isBadgeUpdated =
          p.basename(oldPracticum.badgePath!) != p.basename(newPracticum.badgePath);

      final isCourseContractUpdated = newPracticum.courseContractPath != null &&
          p.basename(oldPracticum.courseContractPath ?? '') !=
              p.basename(newPracticum.courseContractPath!);

      final badgePath = isBadgeUpdated
          ? await FileService.uploadFile(newPracticum.badgePath) ?? ''
          : p.basename(oldPracticum.badgePath!);

      final courseContractPath = isCourseContractUpdated
          ? await FileService.uploadFile(newPracticum.courseContractPath!)
          : oldPracticum.courseContractPath != null
              ? p.basename(oldPracticum.courseContractPath!)
              : null;

      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/practicums/${oldPracticum.id}'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode(
          newPracticum
              .copyWith(
                badgePath: badgePath,
                courseContractPath: courseContractPath,
              )
              .toJson(),
        ),
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
  Future<void> createClassroomsAndAssistants(
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

  @override
  Future<void> removeClassroomFromPracticum(String classroomId) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/classes/$classroomId'),
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
  Future<void> removeAssistantFromPracticum(
    String id, {
    required Profile assistant,
  }) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/practicums/$id/assistants/${assistant.username}'),
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
