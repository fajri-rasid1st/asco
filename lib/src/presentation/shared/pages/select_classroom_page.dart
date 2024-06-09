// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/enums/classroom_subtitle_type.dart';
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
        itemBuilder: (context, index) {
          return ClassroomCard(
            subtitleType: ClassroomSubtitleType.totalStudents,
            onTap: args.onItemTapped,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: 3,
      ),
    );
  }
}

class SelectClassroomPageArgs {
  final String title;
  final VoidCallback? onItemTapped;
  // final int practicumId;

  const SelectClassroomPageArgs({
    required this.title,
    required this.onItemTapped,
  });
}
