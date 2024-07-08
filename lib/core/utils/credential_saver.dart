// Project imports:
import 'package:asco/core/helpers/auth_preferences_helper.dart';
import 'package:asco/src/data/models/profiles/profile.dart';

class CredentialSaver {
  static String? accessToken;
  static Profile? credential;

  static Future<void> init() async {
    if (accessToken == null || credential == null) {
      AuthPreferencesHelper preferencesHelper = AuthPreferencesHelper();

      accessToken = await preferencesHelper.getAccessToken();
      credential = await preferencesHelper.getCredential();
    }
  }
}
