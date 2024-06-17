// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/asco_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/cards/meeting_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_icon_button.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';
import 'package:asco/src/presentation/shared/widgets/practicum_badge_image.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage({super.key});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final meetingMenuCards = [
      MeetingMenuCard(
        title: 'Tata Tertib',
        strokeColor: Palette.purple3,
        fillColor: Palette.purple4,
        icon: Icons.list_alt_outlined,
        onTap: () {},
      ),
      MeetingMenuCard(
        title: 'Kontrak Kuliah',
        strokeColor: Palette.salmon1,
        fillColor: Palette.salmon2,
        icon: Icons.description_outlined,
        onTap: () {},
      ),
      // if (CredentialSaver.user.role == 'STUDENT')
      MeetingMenuCard(
        title: 'Riwayat Kehadiran',
        strokeColor: Palette.azure1,
        fillColor: Palette.azure2,
        icon: Icons.history_outlined,
        onTap: () => navigatorKey.currentState!.pushNamed(studentAttendanceHistoryRoute),
      )
      // else
      //   MeetingMenuCard(
      //     title: 'Jadwal Pemateri',
      //     strokeColor: Palette.azure1,
      //     fillColor: Palette.azure2,
      //     icon: Icons.calendar_today_outlined,
      //     onTap: () {},
      //   ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const AscoAppBar(),
            const SizedBox(height: 24),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  bottom: -8,
                  child: Container(
                    width: AppSize.getAppWidth(context) - 80,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Palette.purple2,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Palette.purple3,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pemrograman Mobile A',
                                style: textTheme.titleLarge!.copyWith(
                                  color: Palette.background,
                                  fontWeight: FontWeight.w600,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Setiap hari Senin Pukul 10.10 - 12.40',
                                style: textTheme.bodySmall!.copyWith(
                                  color: Palette.scaffoldBackground,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        const PracticumBadgeImage(
                          badgeUrl: 'https://placehold.co/138x150/png',
                          width: 44,
                          height: 48,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 14,
                childAspectRatio: 16 / 7,
              ),
              itemBuilder: (context, index) => meetingMenuCards[index],
              itemCount: meetingMenuCards.length,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Pertemuan',
                    style: textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CustomIconButton(
                  'arrow_sort_outlined.svg',
                  color: Palette.primaryText,
                  size: 20,
                  tooltip: 'Urutkan',
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 6),
            ...List<Padding>.generate(
              10,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == 9 ? kBottomNavigationBarHeight : 10,
                ),
                child: MeetingCard(
                  onTap: () => navigatorKey.currentState!.pushNamed(studentMeetingDetailRoute),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MeetingMenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color strokeColor;
  final Color fillColor;
  final VoidCallback? onTap;

  const MeetingMenuCard({
    super.key,
    required this.title,
    required this.icon,
    required this.strokeColor,
    required this.fillColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 12,
      color: Palette.background,
      padding: const EdgeInsets.all(10),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: strokeColor,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: Palette.background,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall!.copyWith(
                color: strokeColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
