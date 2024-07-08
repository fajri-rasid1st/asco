// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/features/common/initial/providers/credential_provider.dart';
import 'package:asco/src/presentation/providers/repository_providers/auth_repository_provider.dart';

part 'is_login_provider.g.dart';

@riverpod
class IsLogin extends _$IsLogin {
  @override
  Future<(bool?, Profile?)> build() async {
    bool? isLogin;
    Profile? credential;

    state = const AsyncValue.loading();

    final result = await ref.watch(authRepositoryProvider).isLogin();

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        isLogin = r;

        if (r) {
          ref.listen(credentialProvider, (_, state) {
            state.whenOrNull(
              error: (error, _) {
                this.state = AsyncValue.error(error, StackTrace.current);
              },
              data: (data) {
                credential = data;

                this.state = AsyncValue.data((isLogin, credential));
              },
            );
          });
        }
      },
    );

    return (isLogin, credential);
  }
}
