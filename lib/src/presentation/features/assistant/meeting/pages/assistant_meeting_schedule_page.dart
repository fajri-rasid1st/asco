// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/number_extension.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/features/assistant/meeting/providers/meeting_schedules_provider.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_badge.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';

class AssistantMeetingSchedulePage extends StatelessWidget {
  final String practicumId;

  const AssistantMeetingSchedulePage({super.key, required this.practicumId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Jadwal Pemateri',
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final schedules = ref.watch(MeetingSchedulesProvider(practicum: practicumId));

          ref.listen(MeetingSchedulesProvider(practicum: practicumId), (_, state) {
            state.whenOrNull(error: context.responseError);
          });

          return schedules.when(
            loading: () => const LoadingIndicator(),
            error: (_, __) => const SizedBox(),
            data: (schedules) {
              if (schedules == null) return const SizedBox();

              if (schedules.isEmpty) {
                return const CustomInformation(
                  title: 'Jadwal tidak ada',
                  subtitle: 'Anda belum memiliki jadwal sebagai pemateri/pendamping',
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) => InkWellContainer(
                  radius: 99,
                  color: Palette.background,
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                  child: Row(
                    children: [
                      CircleBorderContainer(
                        size: 60,
                        withBorder: false,
                        fillColor: Palette.purple3,
                        child: Text(
                          '#${schedules[index].number}',
                          style: textTheme.titleMedium!.copyWith(
                            color: Palette.background,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${schedules[index].lesson}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleSmall!.copyWith(
                                color: Palette.purple2,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              '${schedules[index].date?.toDateTimeFormat('d MMMM yyyy')}',
                              style: textTheme.labelSmall!.copyWith(
                                color: Palette.secondaryText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CustomBadge(
                              text: schedules[index].asMain! ? 'Pemateri' : 'Pendamping',
                              color: schedules[index].asMain! ? Palette.plum1 : Palette.plum2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemCount: schedules.length,
              );
            },
          );
        },
      ),
    );
  }
}
