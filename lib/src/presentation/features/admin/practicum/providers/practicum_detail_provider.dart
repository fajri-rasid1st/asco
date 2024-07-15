// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/presentation/providers/repository_providers/practicum_repository_provider.dart';

part 'practicum_detail_provider.g.dart';

@riverpod
class PracticumDetail extends _$PracticumDetail {
  @override
  Future<Practicum?> build(String id) async {
    Practicum? practicum;

    state = const AsyncValue.loading();

    final result = await ref.watch(practicumRepositoryProvider).getPracticumDetail(id);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        practicum = r.copyWith(
          classrooms: r.classrooms?..sort((a, b) => a.name!.compareTo(b.name!)),
        );

        state = AsyncValue.data(practicum);
      },
    );

    return practicum;
  }
}
