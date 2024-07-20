// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/providers/repository_providers/profile_repository_provider.dart';

part 'user_detail_provider.g.dart';

@riverpod
class UserDetail extends _$UserDetail {
  @override
  Future<Profile?> build(String username) async {
    Profile? user;

    state = const AsyncValue.loading();

    final result = await ref.watch(profileRepositoryProvider).getProfileDetail(username);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        user = r;
        state = AsyncValue.data(user);
      },
    );

    return user;
  }
}
