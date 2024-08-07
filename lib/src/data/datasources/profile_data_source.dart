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
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/data/models/profiles/profile_post.dart';

abstract class ProfileDataSource {
  /// Get Profiles
  Future<List<Profile>> getProfiles({
    String query = '',
    String role = '',
    String sortBy = '',
    String orderBy = '',
    String practicum = '',
  });

  /// Get profile detail
  Future<Profile> getProfileDetail(String username);

  /// Create profiles
  Future<void> createProfiles(List<ProfilePost> profiles);

  /// Edit profile
  Future<void> editProfile(String username, ProfilePost profile);

  /// Delete profile
  Future<void> deleteProfile(String username);
}

class ProfileDataSourceImpl implements ProfileDataSource {
  final http.Client client;

  const ProfileDataSourceImpl({required this.client});

  @override
  Future<List<Profile>> getProfiles({
    String query = '',
    String role = '',
    String sortBy = '',
    String orderBy = '',
    String practicum = '',
  }) async {
    try {
      final searchParam = query.isEmpty ? query : '&query=$query';
      final roleParam = role.isEmpty ? role : '&role=$role';
      final sortByParam = sortBy.isEmpty ? sortBy : '&sortBy=$sortBy';
      final orderByParam = orderBy.isEmpty ? orderBy : '&orderBy=$orderBy';
      final practicumParam = practicum.isEmpty ? practicum : '&practicum=$practicum';

      final queryParams = '$searchParam$roleParam$sortByParam$orderByParam$practicumParam';

      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/users/master?$queryParams'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        final data = result.data as List;

        return data.map((e) => Profile.fromJson(e)).toList();
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<Profile> getProfileDetail(String username) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/users/$username'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        return Profile.fromJson(result.data);
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> createProfiles(List<ProfilePost> profiles) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/users'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({
          'data': profiles.map((e) => e.toJson()).toList(),
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
  Future<void> editProfile(String username, ProfilePost profile) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/users/$username'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode(profile.toJson()),
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
  Future<void> deleteProfile(String username) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/users/$username'),
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
