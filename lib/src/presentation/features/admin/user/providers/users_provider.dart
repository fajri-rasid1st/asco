// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/providers/repository_providers/profile_repository_provider.dart';

part 'users_provider.g.dart';

@riverpod
class Users extends _$Users {
  @override
  Future<List<Profile>?> build({
    String query = '',
    String role = '',
    String sortBy = '',
    String orderBy = '',
    String practicum = '',
  }) async {
    List<Profile>? users;

    state = const AsyncValue.loading();

    final result = await ref.watch(profileRepositoryProvider).getProfiles(
          query: query,
          role: role,
          sortBy: sortBy,
          orderBy: orderBy,
          practicum: practicum,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        users = r;
        state = AsyncValue.data(users);
      },
    );

    return users;
  }
}
