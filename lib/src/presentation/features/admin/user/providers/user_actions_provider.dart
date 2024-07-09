// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/profiles/profile_post.dart';
import 'package:asco/src/presentation/providers/repository_providers/profile_repository_provider.dart';

part 'user_actions_provider.g.dart';

@riverpod
class UserActions extends _$UserActions {
  @override
  AsyncValue<String?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createUser(List<ProfilePost> users) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(profileRepositoryProvider).createProfiles(users);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data('Berhasil menambahkan pengguna'),
    );
  }

  Future<void> editUser(String username, ProfilePost user) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(profileRepositoryProvider).editProfile(username, user);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data('Berhasil mengedit data pengguna'),
    );
  }

  Future<void> deleteUser(String username) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(profileRepositoryProvider).deleteProfile(username);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data('Berhasil menghapus pengguna'),
    );
  }
}
