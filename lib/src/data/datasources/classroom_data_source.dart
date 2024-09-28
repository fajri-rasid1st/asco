// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:asco/core/configs/api_configs.dart';
import 'package:asco/core/errors/exceptions.dart';
import 'package:asco/core/extensions/iterable_extension.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/data_response.dart';
import 'package:asco/src/data/models/classrooms/classroom.dart';
import 'package:asco/src/data/models/profiles/profile.dart';

abstract class ClassroomDataSource {
  /// Student: Get classrooms
  Future<List<Classroom>> getClassrooms();

  /// Admin: Get classroom detail
  Future<Classroom> getClassroomDetail(String id);

  /// Admin: Add students to classroom
  Future<void> addStudentsToClassroom(
    String id, {
    required List<Profile> students,
  });

  /// Admin: Remove student from classroom
  Future<void> removeStudentFromClassroom(
    String id, {
    required Profile student,
  });
}

class ClassroomDataSourceImpl implements ClassroomDataSource {
  final http.Client client;

  const ClassroomDataSourceImpl({required this.client});

  @override
  Future<List<Classroom>> getClassrooms() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/classes'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        final data = result.data as List;

        return data.map((e) => Classroom.fromJson(e)).sortedBy((e) => e.name!);
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<Classroom> getClassroomDetail(String id) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/classes/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        return Classroom.fromJson(result.data);
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> addStudentsToClassroom(
    String id, {
    required List<Profile> students,
  }) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/classes/$id/students'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({
          'students': students.map((e) => e.username).toList(),
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
  Future<void> removeStudentFromClassroom(
    String id, {
    required Profile student,
  }) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/classes/$id/students/${student.username}'),
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
