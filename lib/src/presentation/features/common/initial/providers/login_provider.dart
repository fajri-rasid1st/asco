// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/features/common/initial/providers/credential_provider.dart';
import 'package:asco/src/presentation/providers/repository_providers/auth_repository_provider.dart';

part 'login_provider.g.dart';

@riverpod
class Login extends _$Login {
  @override
  AsyncValue<(bool?, Profile?)> build() {
    return const AsyncValue.data((null, null));
  }

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(authRepositoryProvider).login(username, password);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        if (r) {
          ref.listen(credentialProvider, (_, state) {
            state.whenOrNull(
              error: (error, _) => this.state = AsyncValue.error(error, StackTrace.current),
              data: (data) => this.state = AsyncValue.data((r, data)),
            );
          });
        }
      },
    );
  }
}
