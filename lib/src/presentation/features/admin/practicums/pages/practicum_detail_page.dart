// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/features/admin/practicums/pages/practicum_form_page.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/practicum_badge_image.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class PracticumDetailPage extends StatelessWidget {
  const PracticumDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detail Praktikum',
        action: IconButton(
          onPressed: () => navigatorKey.currentState!.pushNamed(
            practicumFirstFormRoute,
            arguments: const PracticumFormPageArgs(action: 'Edit'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Palette.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  SvgAsset(
                    AssetPath.getVector('bg_attribute_3.svg'),
                    height: 44,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Row(
                      children: [
                        const PracticumBadgeImage(
                          badgeUrl: 'https://placehold.co/138x150/png',
                          width: 48,
                          height: 52,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mata Kuliah',
                                style: textTheme.bodySmall!.copyWith(
                                  color: Palette.secondaryText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Pemrograman Mobile',
                                style: textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
              child: Text(
                'Kelas',
                style: textTheme.titleLarge!.copyWith(
                  color: Palette.purple2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...List<Container>.generate(
              4,
              (index) => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: EdgeInsets.only(
                  bottom: index == 3 ? 0 : 8,
                ),
                decoration: BoxDecoration(
                  color: Palette.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kelas A',
                      style: textTheme.titleMedium!.copyWith(
                        color: Palette.purple2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Setiap Sabtu 07.30 - 09.30',
                      style: textTheme.bodySmall!.copyWith(
                        color: Palette.purple3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
              child: Text(
                'Asisten',
                style: textTheme.titleLarge!.copyWith(
                  color: Palette.purple2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...List<Padding>.generate(
              4,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == 3 ? 0 : 8,
                ),
                child: const UserCard(showBadge: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
