// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/enums/user_badge_type.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';

class AttendanceDetailPage extends StatelessWidget {
  const AttendanceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Absensi - Pertemuan 1',
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List<Flexible>.generate(
                  attendanceStatus.length,
                  (index) => Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleBorderContainer(
                          size: 16,
                          withBorder: false,
                          fillColor: attendanceStatusColor.values.toList()[index],
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            attendanceStatusColor.keys.toList()[index],
                            style: textTheme.bodyMedium!.copyWith(
                              color: attendanceStatusColor.values.toList()[index],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 10,
                (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == 9 ? 0 : 10,
                    ),
                    child: const UserCard(
                      badgeType: UserBadgeType.text,
                      trailing: CircleBorderContainer(
                        size: 28,
                        withBorder: false,
                        fillColor: Palette.success,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
