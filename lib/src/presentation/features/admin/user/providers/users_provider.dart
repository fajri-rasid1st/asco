// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/providers/repository_providers/profile_repository_provider.dart';

part 'users_provider.g.dart';

@riverpod
class Users extends _$Users {
  @override
  Future<List<Profile>?> build() async {
    List<Profile>? users;

    state = const AsyncValue.loading();

    final result = await ref.watch(profileRepositoryProvider).getProfiles();

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        users = r;
        state = AsyncValue.data(r);
      },
    );

    return users;
  }

  Future<void> filterUsers({String role = ''}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(profileRepositoryProvider).getProfiles(role: role);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = AsyncValue.data(r),
    );
  }
}
