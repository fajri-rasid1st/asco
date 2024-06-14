// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';

class StudentAttendanceHistoryPage extends StatelessWidget {
  const StudentAttendanceHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Riwayat Kehadiran',
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) => InkWellContainer(
          radius: 99,
          color: Palette.background,
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
          onTap: () {},
          child: Row(
            children: [
              CircleBorderContainer(
                size: 60,
                withBorder: false,
                fillColor: attendanceStatusColor.values.toList()[index % 4],
                child: Text(
                  '#${index + 1}',
                  style: textTheme.titleMedium!.copyWith(
                    color: Palette.background,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tipe Data dan Attribute',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall!.copyWith(
                        color: Palette.purple2,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      attendanceStatusColor.keys.toList()[index % 4],
                      style: textTheme.bodySmall!.copyWith(
                        color: attendanceStatusColor.values.toList()[index % 4],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '26 Februari 2024',
                      style: textTheme.labelSmall!.copyWith(
                        color: Palette.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: 10,
      ),
    );
  }
}
