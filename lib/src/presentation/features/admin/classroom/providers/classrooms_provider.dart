// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/classrooms/classroom.dart';
import 'package:asco/src/presentation/providers/repository_providers/classroom_repository_provider.dart';

part 'classrooms_provider.g.dart';

@riverpod
class Classrooms extends _$Classrooms {
  @override
  Future<List<Classroom>?> build(String practicumId) async {
    List<Classroom>? classrooms;

    state = const AsyncValue.loading();

    final result = await ref.watch(classroomRepositoryProvider).getClassrooms(practicumId);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        classrooms = r;
        state = AsyncValue.data(classrooms);
      },
    );

    return classrooms;
  }
}
