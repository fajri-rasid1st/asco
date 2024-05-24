// Project imports:
import 'package:law_app/features/admin/data/models/user_models/user_credential_model.dart';
import 'package:law_app/features/auth/data/datasources/auth_preferences_helper.dart';

class CredentialSaver {
  static String? accessToken;
  static UserCredentialModel? user;

  static Future<void> init() async {
    if (accessToken == null || user == null) {
      AuthPreferencesHelper preferencesHelper = AuthPreferencesHelper();

      accessToken = await preferencesHelper.getAccessToken();
      user = await preferencesHelper.getUserCredential();
    }
  }
}
