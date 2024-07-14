// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/enums/classroom_subtitle_type.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/classrooms/classroom.dart';
import 'package:asco/src/presentation/shared/widgets/cards/classroom_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';

class SelectClassroomPage extends StatelessWidget {
  final SelectClassroomPageArgs args;

  const SelectClassroomPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: args.title,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) => ClassroomCard(
          classroom: args.classrooms[index],
          subtitleType: ClassroomSubtitleType.totalStudents,
          onTap: args.onItemTapped ??
              () {
                navigatorKey.currentState!.pushNamed(
                  classroomDetailRoute,
                  arguments: args.classrooms[index].id,
                );
              },
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: args.classrooms.length,
      ),
    );
  }
}

class SelectClassroomPageArgs {
  final String title;
  final List<Classroom> classrooms;
  final VoidCallback? onItemTapped;

  const SelectClassroomPageArgs({
    required this.title,
    required this.classrooms,
    this.onItemTapped,
  });
}
