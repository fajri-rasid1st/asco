// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/features/admin/assistance_group/assistance_group_form_page.dart';
import 'package:asco/src/presentation/shared/widgets/animated_fab.dart';
import 'package:asco/src/presentation/shared/widgets/cards/assistance_group_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/practicum_badge_image.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class AssistanceGroupListHomePage extends StatefulWidget {
  const AssistanceGroupListHomePage({super.key});

  @override
  State<AssistanceGroupListHomePage> createState() => _AssistanceGroupListHomePageState();
}

class _AssistanceGroupListHomePageState extends State<AssistanceGroupListHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController fabAnimationController;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    fabAnimationController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
    )..forward();

    scrollController = ScrollController()..addListener(() {});
  }

  @override
  void dispose() {
    super.dispose();

    fabAnimationController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Grup Asistensi',
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) => FunctionHelper.handleFabVisibilityOnScroll(
          fabAnimationController,
          notification,
        ),
        child: SingleChildScrollView(
          controller: scrollController,
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
                            'Pemrograman Mobile',
                            style: textTheme.headlineSmall!.copyWith(
                              color: Palette.purple2,
                            ),
                          ),
                          Text(
                            '3 Kelas',
                            style: textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Palette.purple3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '100 Peserta',
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
              const SectionHeader(title: 'Grup Asistensi'),
              ...List<Padding>.generate(
                10,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    bottom: index == 9 ? 0 : 10,
                  ),
                  child: AssistanceGroupCard(
                    onTap: () => navigatorKey.currentState!.pushNamed(assistanceGroupDetailRoute),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedFloatingActionButton(
        animationController: fabAnimationController,
        onPressed: () => navigatorKey.currentState!.pushNamed(
          assistanceGroupFormRoute,
          arguments: const AssistanceGroupFormPageArgs(action: 'Tambah'),
        ),
        tooltip: 'Tambah',
        child: const Icon(
          Icons.add_rounded,
          size: 28,
        ),
      ),
    );
  }
}
