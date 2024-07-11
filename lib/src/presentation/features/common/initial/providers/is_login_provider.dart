// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/presentation/features/common/initial/providers/credential_provider.dart';
import 'package:asco/src/presentation/providers/repository_providers/auth_repository_provider.dart';

part 'is_login_provider.g.dart';

@riverpod
class IsLogin extends _$IsLogin {
  @override
  Future<bool?> build() async {
    bool? isLogin;

    state = const AsyncValue.loading();

    final result = await ref.watch(authRepositoryProvider).isLogin();

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        isLogin = r;

        if (isLogin!) {
          ref.listen(credentialProvider, (_, state) {
            state.whenOrNull(
              error: (error, _) => this.state = AsyncValue.error(error, StackTrace.current),
              data: (_) => this.state = AsyncValue.data(isLogin),
            );
          });
        }
      },
    );

    return isLogin;
  }
}
