// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/core/enums/model_attributes.dart';
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/providers/repository_providers/profile_repository_provider.dart';

part 'users_provider.g.dart';

@riverpod
class Users extends _$Users {
  @override
  Future<List<Profile>?> build({
    String role = '',
    String practicum = '',
    String query = '',
    UserAttribute sortedBy = UserAttribute.username,
    bool asc = true,
  }) async {
    List<Profile>? users;

    state = const AsyncValue.loading();

    final result = await ref.watch(profileRepositoryProvider).getProfiles(
          role: role,
          practicum: practicum,
          query: query,
          sortedBy: sortedBy,
          asc: asc,
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
