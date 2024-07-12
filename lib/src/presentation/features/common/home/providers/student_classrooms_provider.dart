// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/classrooms/classroom.dart';
import 'package:asco/src/presentation/providers/repository_providers/classroom_repository_provider.dart';

part 'student_classrooms_provider.g.dart';

@riverpod
class StudentClassrooms extends _$StudentClassrooms {
  @override
  Future<List<Classroom>?> build() async {
    List<Classroom>? classrooms;

    state = const AsyncValue.loading();

    final result = await ref.watch(classroomRepositoryProvider).getStudentClassrooms();

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
