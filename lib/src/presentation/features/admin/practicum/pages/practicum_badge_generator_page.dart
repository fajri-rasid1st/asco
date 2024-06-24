// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/extensions/button_extension.dart';
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/services/file_service.dart';
import 'package:asco/core/services/image_service.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

final selectedIconProvider =
    StateProvider.autoDispose<BadgeIcon>((ref) => BadgeIcon.getIcons.first);
final selectedPaletteProvider =
    StateProvider.autoDispose<BadgePalette>((ref) => BadgePalette.getPalettes.last);

class PracticumBadgeGeneratorPage extends StatelessWidget {
  const PracticumBadgeGeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repaintKey = GlobalKey();

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Badge Praktikum',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: AppSize.getAppWidth(context) - 60,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(
                vertical: 28,
                horizontal: 46,
              ),
              decoration: BoxDecoration(
                color: Palette.background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: RepaintBoundary(
                key: repaintKey,
                child: Consumer(
                  builder: (context, ref, child) {
                    final selectedIcon = ref.watch(selectedIconProvider);
                    final selectedPalette = ref.watch(selectedPaletteProvider);

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgAsset(
                          AssetPath.getVector('badge_layer_3.svg'),
                          color: selectedPalette.tertiaryColor,
                          width: 220,
                        ),
                        SvgAsset(
                          AssetPath.getVector('badge_layer_2.svg'),
                          color: selectedPalette.secondaryColor,
                          width: 220,
                        ),
                        SvgAsset(
                          AssetPath.getVector('badge_layer.svg'),
                          color: selectedPalette.primaryColor,
                          width: 220,
                        ),
                        SvgAsset(
                          selectedIcon.path,
                          color: selectedPalette.tertiaryColor,
                          width: 100,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SectionHeader(
              title: 'Icon',
              padding: EdgeInsets.fromLTRB(24, 4, 0, 6),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List<Padding>.generate(
                  BadgeIcon.getIcons.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      right: index == BadgeIcon.getIcons.length - 1 ? 0 : 10,
                    ),
                    child: Consumer(
                      builder: (context, ref, child) {
                        return BadgeIconContainer(
                          badgeIcon: BadgeIcon.getIcons[index],
                          isSelected: BadgeIcon.getIcons[index].name ==
                              ref.watch(selectedIconProvider).name,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SectionHeader(
              title: 'Color',
              padding: EdgeInsets.fromLTRB(24, 16, 0, 6),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List<Padding>.generate(
                  BadgePalette.getPalettes.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      right: index == BadgePalette.getPalettes.length - 1 ? 0 : 10,
                    ),
                    child: Consumer(
                      builder: (context, ref, child) {
                        return BadgePaletteContainer(
                          badgePalette: BadgePalette.getPalettes[index],
                          isSelected:
                              BadgePalette.getPalettes[index] == ref.watch(selectedPaletteProvider),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FilledButton(
                onPressed: () => generateBadgePng(repaintKey),
                child: const Text('Generate'),
              ).fullWidth(),
            ),
          ],
        ),
      ),
    );
  }

  void generateBadgePng(GlobalKey repaintKey) async {
    final imageBytes = await ImageService.capturePngImage(repaintKey.currentContext!);

    if (imageBytes.isEmpty) {
      throw Exception('Capture image failed!');
    } else {
      final imagePath = await FileService.createFile(imageBytes, extension: 'png');

      navigatorKey.currentState!.pop(imagePath);
    }
  }
}

class BadgeIconContainer extends ConsumerWidget {
  final BadgeIcon badgeIcon;
  final bool isSelected;

  const BadgeIconContainer({
    super.key,
    required this.badgeIcon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        InkWellContainer(
          width: 64,
          height: 64,
          radius: 12,
          color: isSelected ? Palette.divider.withOpacity(.5) : Palette.background,
          onTap: () => ref.read(selectedIconProvider.notifier).state = badgeIcon,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SvgAsset(badgeIcon.path),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          badgeIcon.name,
          style: textTheme.bodySmall!.copyWith(
            color: Palette.disabledText,
          ),
        ),
      ],
    );
  }
}

class BadgePaletteContainer extends ConsumerWidget {
  final BadgePalette badgePalette;
  final bool isSelected;

  const BadgePaletteContainer({
    super.key,
    required this.badgePalette,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWellContainer(
      width: 64,
      height: 64,
      radius: 12,
      color: isSelected ? Palette.divider.withOpacity(.5) : Palette.background,
      onTap: () => ref.read(selectedPaletteProvider.notifier).state = badgePalette,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: badgePalette.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class BadgeIcon {
  final String name;
  final String path;

  const BadgeIcon(
    this.name,
    this.path,
  );

  static List<BadgeIcon> get getIcons => [
        BadgeIcon('Default', AssetPath.getIcon('code_outlined.svg')),
        BadgeIcon('Mobile', AssetPath.getIcon('android_filled.svg')),
        BadgeIcon('Web', AssetPath.getIcon('web_outlined.svg')),
        BadgeIcon('Database', AssetPath.getIcon('database_filled.svg')),
        BadgeIcon('OOP', AssetPath.getIcon('data_object_outlined.svg')),
      ];
}

class BadgePalette {
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;

  const BadgePalette(
    this.primaryColor,
    this.secondaryColor,
    this.tertiaryColor,
  );

  static List<BadgePalette> get getPalettes => [
        const BadgePalette(Color(0xFF744BE4), Color(0xFFBBAEF2), Color(0xFFE5DBFF)),
        const BadgePalette(Color(0xFFEF65A3), Color(0xFFFFABD3), Color(0xFFFFCBE3)),
        const BadgePalette(Color(0xFF6573EF), Color(0xFFABBDFF), Color(0xFFCBDAFF)),
        const BadgePalette(Color(0xFFEFD165), Color(0xFFFFEDAB), Color(0xFFFEFFCB)),
        const BadgePalette(Color(0xFF71DA9B), Color(0xFF90E8B3), Color(0xFFB3FAD0)),
        const BadgePalette(Color(0xFFEF8235), Color(0xFFFDBA74), Color(0xFFFFE7C8)),
        const BadgePalette(Color(0xFFD1D5DB), Color(0xFFE5E7EB), Color(0xFFF3F4F6)),
      ];
}
