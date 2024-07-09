// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/enums/user_badge_type.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/pages/select_users_page.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/practicum_badge_image.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class ClassroomDetailPage extends StatelessWidget {
  const ClassroomDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Pemrograman Mobile A',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Palette.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: SvgAsset(
                      AssetPath.getVector('bg_attribute_3.svg'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PracticumBadgeImage(
                          badgeUrl: 'https://placehold.co/138x150/png',
                          width: 58,
                          height: 63,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Kelas A',
                          style: textTheme.headlineSmall!.copyWith(
                            color: Palette.purple2,
                          ),
                        ),
                        Text(
                          'Pemrograman Mobile',
                          style: textTheme.bodyLarge!.copyWith(
                            color: Palette.purple3,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Setiap Sabtu 07.30 - 09.30',
                          style: textTheme.bodySmall!.copyWith(
                            color: Palette.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SectionHeader(
              title: 'Peserta',
              showDivider: true,
              showActionButton: true,
              onPressedActionButton: () async {
                final result = await navigatorKey.currentState!.pushNamed(
                  selectUsersRoute,
                  arguments: const SelectUsersPageArgs(
                    title: 'Peserta - Kelas A',
                    role: 'Peserta',
                  ),
                );

                if (result != null) updateClassroom(result as List<int>);
              },
            ),
            ...List<Padding>.generate(
              10,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == 9 ? 0 : 10,
                ),
                child: UserCard(
                  user: CredentialSaver.credential!,
                  badgeType: UserBadgeType.text,
                  showDeleteButton: true,
                  onPressedDeleteButton: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateClassroom(List<int> selectedStudents) {
    debugPrint(selectedStudents.toString());
  }
}
