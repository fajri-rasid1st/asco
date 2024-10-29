// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/core/helpers/auth_preferences_helper.dart';
import 'package:asco/core/utils/http_client.dart';
import 'package:asco/src/data/datasources/auth_data_source.dart';

part 'auth_data_source_provider.g.dart';

@riverpod
AuthDataSource authDataSource(Ref ref) {
  return AuthDataSourceImpl(
    client: HttpClient.client,
    preferencesHelper: AuthPreferencesHelper(),
  );
}
