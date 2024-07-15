// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/presentation/providers/repository_providers/practicum_repository_provider.dart';

part 'practicums_provider.g.dart';

@riverpod
class Practicums extends _$Practicums {
  @override
  Future<List<Practicum>?> build() async {
    List<Practicum>? practicums;

    state = const AsyncValue.loading();

    final result = await ref.watch(practicumRepositoryProvider).getPracticums();

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        practicums = r.map((e) {
          return e.copyWith(
            classrooms: e.classrooms?..sort((a, b) => a.name!.compareTo(b.name!)),
          );
        }).toList();

        state = AsyncValue.data(practicums);
      },
    );

    return practicums;
  }
}
