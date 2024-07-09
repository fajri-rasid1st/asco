// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/practicums/practicum_post.dart';
import 'package:asco/src/presentation/providers/repository_providers/practicum_repository_provider.dart';

part 'practicum_actions_provider.g.dart';

@riverpod
class PracticumActions extends _$PracticumActions {
  @override
  AsyncValue<String?> build() {
    return const AsyncValue.data(null);
  }

  Future<String?> createPracticum(PracticumPost practicum) async {
    String? data;

    state = const AsyncValue.loading();

    final result = await ref.watch(practicumRepositoryProvider).createPracticum(practicum);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        data = r;
        state = const AsyncValue.data('Berhasil menambahkan praktikum');
      },
    );

    return data;
  }

  Future<String?> editUser(String id, PracticumPost practicum) async {
    String? data;

    state = const AsyncValue.loading();

    final result = await ref.watch(practicumRepositoryProvider).editPracticum(id, practicum);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        data = r;
        state = const AsyncValue.data('Berhasil mengedit praktikum');
      },
    );

    return data;
  }

  Future<void> deleteUser(String id) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(practicumRepositoryProvider).deletePracticum(id);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data('Berhasil menghapus praktikum'),
    );
  }
}
