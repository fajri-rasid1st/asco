// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:asco/core/utils/const.dart';
import 'package:asco/core/utils/credential_saver.dart';

class AuthPreferencesHelper {
  static AuthPreferencesHelper? _instance;

  AuthPreferencesHelper._internal() {
    _instance = this;
  }

  factory AuthPreferencesHelper() => _instance ?? AuthPreferencesHelper._internal();

  SharedPreferences? _preferences;

  Future<SharedPreferences> _initPreferences() async {
    return await SharedPreferences.getInstance();
  }

  Future<SharedPreferences?> get preferences async {
    return _preferences ??= await _initPreferences();
  }

  /// Set [accessToken] to persistent storage
  Future<bool> setAccessToken(String accessToken) async {
    final pr = await preferences;

    return await pr!.setString(accessTokenKey, accessToken);
  }

  /// Get access token from persistent storage
  Future<String?> getAccessToken() async {
    final pr = await preferences;

    if (pr!.containsKey(accessTokenKey)) {
      final token = pr.getString(accessTokenKey);

      CredentialSaver.accessToken ??= token;

      return token;
    }

    return null;
  }

  /// Remove access token from persistent storage
  Future<bool> removeAccessToken() async {
    CredentialSaver.accessToken = null;

    final pr = await preferences;

    return await pr!.remove(accessTokenKey);
  }
}
