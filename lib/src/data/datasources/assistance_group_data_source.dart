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
import 'package:asco/src/data/models/assistance_groups/assistance_group.dart';
import 'package:asco/src/data/models/assistance_groups/assistance_group_post.dart';

abstract class AssistanceGroupDataSource {
  /// Get assistance groups
  Future<List<AssistanceGroup>> getAssistanceGroups(String practicumId);

  /// Add assistance group to practicum
  Future<void> addAssistanceGroupToPracticum(
    String practicumId, {
    required AssistanceGroupPost assistanceGroup,
  });
}

class AssistanceGroupDataSourceImpl implements AssistanceGroupDataSource {
  final http.Client client;

  const AssistanceGroupDataSourceImpl({required this.client});

  @override
  Future<List<AssistanceGroup>> getAssistanceGroups(String practicumId) async {
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

        return data.map((e) => AssistanceGroup.fromJson(e)).toList();
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> addAssistanceGroupToPracticum(
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
}
