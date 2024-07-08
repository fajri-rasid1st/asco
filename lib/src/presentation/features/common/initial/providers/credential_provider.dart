// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/providers/repository_providers/auth_repository_provider.dart';

part 'credential_provider.g.dart';

@riverpod
class Credential extends _$Credential {
  @override
  Future<Profile?> build() async {
    Profile? credential;

    state = const AsyncValue.loading();

    final result = await ref.watch(authRepositoryProvider).getCredential();

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        credential = r;
        state = AsyncValue.data(r);
      },
    );

    return credential;
  }
}
