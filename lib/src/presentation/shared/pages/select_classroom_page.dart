// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/enums/classroom_subtitle_type.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/classrooms/classroom.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/presentation/features/admin/classroom/pages/classroom_detail_page.dart';
import 'package:asco/src/presentation/shared/widgets/cards/classroom_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';

class SelectClassroomPage extends StatelessWidget {
  final SelectClassroomPageArgs args;

  const SelectClassroomPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '${args.practicum.course}',
      ),
      body: args.practicum.classroomsLength! > 0
          ? ListView.separated(
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) => ClassroomCard(
                classroom: args.practicum.classrooms![index],
                subtitleType: ClassroomSubtitleType.totalStudents,
                onTap: args.onItemTapped != null
                    ? () => args.onItemTapped!(args.practicum.classrooms![index])
                    : () => navigatorKey.currentState!.pushNamed(
                          classroomDetailRoute,
                          arguments: ClassroomDetailPageArgs(
                            id: args.practicum.classrooms![index].id!,
                            practicum: args.practicum,
                          ),
                        ),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: args.practicum.classrooms!.length,
            )
          : const CustomInformation(
              title: 'Data kelas kosong',
              subtitle: 'Tidak ada kelas yang dapat ditampilkan',
            ),
    );
  }
}

class SelectClassroomPageArgs {
  final Practicum practicum;
  final void Function(Classroom classroom)? onItemTapped;

  const SelectClassroomPageArgs({
    required this.practicum,
    this.onItemTapped,
  });
}
