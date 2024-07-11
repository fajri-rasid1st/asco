// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/classrooms/classroom.dart';
import 'package:asco/src/presentation/providers/repository_providers/classroom_repository_provider.dart';

part 'classroom_detail_provider.g.dart';

@riverpod
class ClassroomDetail extends _$ClassroomDetail {
  @override
  Future<Classroom?> build(String id) async {
    Classroom? classroom;

    state = const AsyncValue.loading();

    final result = await ref.watch(classroomRepositoryProvider).getClassroomDetail(id);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        classroom = r;
        state = AsyncValue.data(classroom);
      },
    );

    return classroom;
  }
}
