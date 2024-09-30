// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/profiles/profile_post.dart';
import 'package:asco/src/presentation/providers/repository_providers/profile_repository_provider.dart';

part 'update_profile_provider.g.dart';

@riverpod
class UpdateProfile extends _$UpdateProfile {
  @override
  AsyncValue<Null> build() {
    return const AsyncValue.data(null);
  }

  Future<void> updateProfile(ProfilePost profile) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(profileRepositoryProvider).updateProfile(profile);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data(null),
    );
  }
}
