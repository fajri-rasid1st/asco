// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:asco/core/configs/api_configs.dart';
import 'package:asco/core/errors/exceptions.dart';
import 'package:asco/core/helpers/auth_preferences_helper.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/data_response.dart';
import 'package:asco/src/data/models/profiles/profile.dart';

abstract class AuthDataSource {
  /// Login
  Future<bool> login(
    String username,
    String password,
  );

  /// Is login
  Future<bool> isLogin();

  /// Get credential
  Future<Profile> getCredential();

  /// Logout
  Future<bool> logOut();
}

class AuthDataSourceImpl implements AuthDataSource {
  final http.Client client;
  final AuthPreferencesHelper preferencesHelper;

  const AuthDataSourceImpl({
    required this.client,
    required this.preferencesHelper,
  });

  @override
  Future<bool> login(
    String username,
    String password,
  ) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/users/login'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        CredentialSaver.accessToken = result.data['accessToken'];

        return await preferencesHelper.setAccessToken(result.data['accessToken']);
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<bool> isLogin() async {
    try {
      final accessToken = await preferencesHelper.getAccessToken();
      final credential = await preferencesHelper.getCredential();

      return accessToken != null && credential != null;
    } catch (e) {
      throw PreferencesException(e.toString());
    }
  }

  @override
  Future<Profile> getCredential() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/users'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        final profile = Profile.fromJson(result.data);

        CredentialSaver.credential = profile;

        await preferencesHelper.setCredential(profile);

        return profile;
      } else {
        throw ServerException(result.error?.code, result.error?.message);
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<bool> logOut() async {
    try {
      final result1 = await preferencesHelper.removeAccessToken();
      final result2 = await preferencesHelper.removeCredential();

      CredentialSaver.accessToken = null;
      CredentialSaver.credential = null;

      return result1 && result2;
    } catch (e) {
      throw PreferencesException(e.toString());
    }
  }
}
