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
import 'package:asco/src/data/models/assistance_groups/assistance_group.dart';
import 'package:asco/src/data/models/assistance_groups/assistance_group_post.dart';

abstract class AssistanceGroupDataSource {
  /// Admin: Get assistance groups
  Future<List<AssistanceGroup>> getAssistanceGroups(
    String practicumId, {
    String query = '',
  });

  /// Admin: Get assistance group detail
  Future<AssistanceGroup> getAssistanceGroupDetail(String id);

  /// Admin: Create assistance group
  Future<void> createAssistanceGroup(
    String practicumId, {
    required AssistanceGroupPost assistanceGroup,
  });

  /// Admin: Edit assistance group
  Future<void> editAssistanceGroup(
    String id,
    AssistanceGroupPost assistanceGroup,
  );

  /// Admin: Delete assistance group
  Future<void> deleteAssistanceGroup(String id);

  /// Admin: Remove student from assistance group
  Future<void> removeStudentFromAssistanceGroup(
    String id, {
    required String username,
  });
}

class AssistanceGroupDataSourceImpl implements AssistanceGroupDataSource {
  final http.Client client;

  const AssistanceGroupDataSourceImpl({required this.client});

  @override
  Future<List<AssistanceGroup>> getAssistanceGroups(
    String practicumId, {
    String query = '',
  }) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/practicums/$practicumId/groups'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        final data = result.data as List;

        return data.map((e) {
          return AssistanceGroup.fromJson(e);
        }).where((e) {
          final keyword = query.toLowerCase();

          final students = e.students!.where((p) {
            final username = p.username!.toLowerCase();
            final fullname = p.fullname!.toLowerCase();

            return username.contains(keyword) || fullname.contains(keyword);
          });

          return students.isNotEmpty;
        }).sortedBy((e) {
          return e.number!;
        });
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<AssistanceGroup> getAssistanceGroupDetail(String id) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/groups/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        return AssistanceGroup.fromJson(result.data);
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> createAssistanceGroup(
    String practicumId, {
    required AssistanceGroupPost assistanceGroup,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/practicums/$practicumId/groups'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode(assistanceGroup.toJson()),
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
  Future<void> editAssistanceGroup(
    String id,
    AssistanceGroupPost assistanceGroup,
  ) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/groups/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode(assistanceGroup.toJson()),
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
  Future<void> deleteAssistanceGroup(String id) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/groups/$id'),
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
  Future<void> removeStudentFromAssistanceGroup(
    String id, {
    required String username,
  }) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/groups/$id/students/$username'),
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
