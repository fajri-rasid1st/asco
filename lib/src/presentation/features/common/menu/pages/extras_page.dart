// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/features/assistant/extra/pages/edit_extra_page.dart';
import 'package:asco/src/presentation/shared/widgets/asco_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class ExtrasPage extends StatefulWidget {
  const ExtrasPage({super.key});

  @override
  State<ExtrasPage> createState() => _ExtrasPageState();
}

class _ExtrasPageState extends State<ExtrasPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final extraCards = [
      ExtraCard(
        title: 'Quiz',
        description: 'Isian singkat di akhir kelas',
        iconName: 'game_controller_outlined.svg',
        iconBackgroundColor: Palette.purple3,
        onTap: roleId == 1
            ? () => FunctionHelper.openUrl('https://quizizz.com/?lng=id')
            : () => navigatorKey.currentState!.pushNamed(
                  editExtraRoute,
                  arguments: const EditExtraPageArgs(
                    title: 'Quiz',
                    fieldName: 'quizLink',
                    fieldLabel: 'Link Quiz',
                  ),
                ),
      ),
      ExtraCard(
        title: 'Kuesioner',
        description: 'Isi form seputar praktikum',
        iconName: 'form_outlined.svg',
        iconBackgroundColor: Palette.errorText,
        onTap: roleId == 1
            ? () => context.showSnackBar(
                  title: 'Segera Hadir',
                  message: 'Kuesioner belum tersedia.',
                  type: SnackBarType.info,
                )
            : () => navigatorKey.currentState!.pushNamed(
                  editExtraRoute,
                  arguments: const EditExtraPageArgs(
                    title: 'Kuesioner',
                    fieldName: 'questionnaireLink',
                    fieldLabel: 'Link Kuesioner',
                  ),
                ),
      ),
      ExtraCard(
        title: 'Ujian Lab',
        description: 'Informasi seputar ujian lab',
        iconName: 'test_passed_outlined.svg',
        iconBackgroundColor: Palette.violet1,
        onTap: () => navigatorKey.currentState!.pushNamed(labExamInfoRoute),
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20 + kBottomNavigationBarHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AscoAppBar(),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 12,
              ),
              child: Text(
                'Extras',
                style: textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) => extraCards[index],
              itemCount: extraCards.length,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ExtraCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconName;
  final Color iconBackgroundColor;
  final VoidCallback onTap;

  const ExtraCard({
    super.key,
    required this.title,
    required this.description,
    required this.iconName,
    required this.iconBackgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 12,
      color: Palette.background,
      clipBehavior: Clip.antiAlias,
      onTap: onTap,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: SvgAsset(
              AssetPath.getVector('bg_attribute_3.svg'),
              height: 48,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SvgAsset(
                    AssetPath.getIcon(iconName),
                    width: 18,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall!.copyWith(
                    color: Palette.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
