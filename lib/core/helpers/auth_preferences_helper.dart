// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/data/models/profiles/profile.dart';

class AuthPreferencesHelper {
  static AuthPreferencesHelper? _instance;

  AuthPreferencesHelper._internal() {
    _instance = this;
  }

  factory AuthPreferencesHelper() => _instance ?? AuthPreferencesHelper._internal();

  SharedPreferences? _preferences;

  Future<SharedPreferences> get preferences async {
    return _preferences ??= await SharedPreferences.getInstance();
  }

  /// Set [accessToken] to persistent storage
  Future<bool> setAccessToken(String accessToken) async {
    final pr = await preferences;

    return await pr.setString(accessTokenKey, accessToken);
  }

  /// Get access token from persistent storage
  Future<String?> getAccessToken() async {
    final pr = await preferences;

    if (pr.containsKey(accessTokenKey)) {
      return pr.getString(accessTokenKey);
    }

    return null;
  }

  /// Remove access token from persistent storage
  Future<bool> removeAccessToken() async {
    final pr = await preferences;

    return await pr.remove(accessTokenKey);
  }

  /// Set [credential] to persistent storage
  Future<bool> setCredential(Profile credential) async {
    final pr = await preferences;

    return await pr.setString(credentialKey, jsonEncode(credential.toJson()));
  }

  /// Get credential from persistent storage
  Future<Profile?> getCredential() async {
    final pr = await preferences;

    if (pr.containsKey(credentialKey)) {
      final data = pr.getString(credentialKey);

      return Profile.fromJson(jsonDecode(data!));
    }

    return null;
  }

  /// Remove credential from persistent storage
  Future<bool> removeCredential() async {
    final pr = await preferences;

    return await pr.remove(credentialKey);
  }
}
