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
import 'package:asco/src/data/models/assistances/assistance_post.dart';
import 'package:asco/src/data/models/control_cards/control_card.dart';

abstract class ControlCardDataSource {
  /// Student: Get control cards
  Future<List<ControlCard>> getControlCards(String practicumId);

  /// Admin, Assistant, Student: Get student control cards
  Future<List<ControlCard>> getStudentControlCards(
    String practicumId,
    String studentId,
  );

  /// Student: Get control card detail
  Future<ControlCard> getControlCardDetail(String id);

  /// Assistant: Get assistance group meeting control cards
  Future<List<ControlCard>> getMeetingControlCards(String meetingId);

  /// Assistant: Update student assistance
  Future<void> updateAssistance(
    String assistanceId,
    AssistancePost assistance,
  );
}

class ControlCardDataSourceImpl implements ControlCardDataSource {
  final http.Client client;

  const ControlCardDataSourceImpl({required this.client});

  @override
  Future<List<ControlCard>> getControlCards(String practicumId) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/practicums/$practicumId/cards'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        final data = result.data as List;

        return data.map((e) => ControlCard.fromJson(e)).sortedBy((e) => e.meeting!.number!);
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<List<ControlCard>> getStudentControlCards(
    String practicumId,
    String studentId,
  ) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/practicums/$practicumId/students/$studentId/cards'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        final data = result.data as List;

        return data.map((e) => ControlCard.fromJson(e)).sortedBy((e) => e.meeting!.number!);
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<ControlCard> getControlCardDetail(String id) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/cards/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        return ControlCard.fromJson(result.data);
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<List<ControlCard>> getMeetingControlCards(String meetingId) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/meetings/$meetingId/cards'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        final data = result.data as List;

        return data.map((e) => ControlCard.fromJson(e)).sortedBy((e) => e.student!.username!);
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> updateAssistance(
    String assistanceId,
    AssistancePost assistance,
  ) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/assistances/$assistanceId'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode(assistance.toJson()),
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
