// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/extensions/button_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class MeetingDetailPage extends StatelessWidget {
  final MeetingDetailPageArgs args;

  const MeetingDetailPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Pertemuan 1',
        action: IconButton(
          onPressed: () => navigatorKey.currentState!.pushNamed(
            meetingFormRoute,
            // arguments: ,
          ),
          icon: const Icon(Icons.edit_rounded),
          iconSize: 20,
          tooltip: 'Edit',
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
          ),
        ),
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
                        CircleBorderContainer(
                          size: 64,
                          withBorder: false,
                          fillColor: Palette.purple3,
                          child: Text(
                            '#1',
                            style: textTheme.titleLarge!.copyWith(
                              color: Palette.background,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tipe Data dan Attribute',
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
                          '26 Februari 2024',
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
            const SectionHeader(title: 'Modul'),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.menu_book_rounded),
              label: const Text('Buka Modul'),
              style: FilledButton.styleFrom(
                foregroundColor: Palette.purple2,
                backgroundColor: Palette.background,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ).fullWidth(),
            const SectionHeader(title: 'Mentor'),
            UserCard(
              user: CredentialSaver.credential!,
              badgeText: 'Pemateri',
            ),
            const SizedBox(height: 10),
            UserCard(
              user: CredentialSaver.credential!,
              badgeText: 'Pendamping',
            )
          ],
        ),
      ),
    );
  }
}

class MeetingDetailPageArgs {
  final String id;
  final String practicumName;

  const MeetingDetailPageArgs({
    required this.id,
    required this.practicumName,
  });
}
