// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/presentation/features/admin/assistance_group/pages/assistance_group_detail_page.dart';
import 'package:asco/src/presentation/features/admin/assistance_group/pages/assistance_group_form_page.dart';
import 'package:asco/src/presentation/features/admin/assistance_group/providers/assistance_group_actions_provider.dart';
import 'package:asco/src/presentation/features/admin/assistance_group/providers/assistance_groups_provider.dart';
import 'package:asco/src/presentation/shared/widgets/animated_fab.dart';
import 'package:asco/src/presentation/shared/widgets/cards/assistance_group_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';
import 'package:asco/src/presentation/shared/widgets/practicum_badge_image.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class AssistanceGroupListHomePage extends ConsumerStatefulWidget {
  final Practicum practicum;

  const AssistanceGroupListHomePage({super.key, required this.practicum});

  @override
  ConsumerState<AssistanceGroupListHomePage> createState() => _AssistanceGroupListHomePageState();
}

class _AssistanceGroupListHomePageState extends ConsumerState<AssistanceGroupListHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController fabAnimationController;
  late final ScrollController scrollController;

  @override
  void initState() {
    fabAnimationController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
    )..forward();

    scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    fabAnimationController.dispose();
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(AssistanceGroupsProvider(widget.practicum.id!));

    ref.listen(AssistanceGroupsProvider(widget.practicum.id!), (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNoConnectionSnackBar();
          } else {
            context.showSnackBar(
              title: 'Terjadi Kesalahan',
              message: '$error',
              type: SnackBarType.error,
            );
          }
        },
      );
    });

    ref.listen(assistanceGroupActionsProvider, (_, state) {
      state.when(
        loading: () => context.showLoadingDialog(),
        error: (error, _) {
          navigatorKey.currentState!.pop();

          if ('$error' == kNoInternetConnection) {
            context.showNoConnectionSnackBar();
          } else {
            context.showSnackBar(
              title: 'Terjadi Kesalahan',
              message: '$error',
              type: SnackBarType.error,
            );
          }
        },
        data: (data) {
          if (data.message != null) {
            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop();

            ref.invalidate(assistanceGroupsProvider);

            context.showSnackBar(
              title: 'Berhasil',
              message: data.message!,
            );
          }
        },
      );
    });

    return groups.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (groups) {
        if (groups == null) return const Scaffold();

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
                              PracticumBadgeImage(
                                badgeUrl: '${widget.practicum.badgePath}',
                                width: 58,
                                height: 63,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '${widget.practicum.course}',
                                style: textTheme.headlineSmall!.copyWith(
                                  color: Palette.purple2,
                                ),
                              ),
                              Text(
                                '${widget.practicum.classroomsLength} Kelas',
                                style: textTheme.bodyLarge!.copyWith(
                                  color: Palette.purple3,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.practicum.classrooms!.map((e) => e.studentsLength!).sum} Peserta',
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
                  if (groups.isEmpty)
                    const CustomInformation(
                      title: 'Data grup asistensi kosong',
                      subtitle: 'Tambahkan grup asistensi dengan menekan tombol "Tambah"',
                    )
                  else
                    ...List<Padding>.generate(
                      groups.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          bottom: index == groups.length - 1 ? 0 : 10,
                        ),
                        child: AssistanceGroupCard(
                          group: groups[index],
                          onTap: () => navigatorKey.currentState!.pushNamed(
                            assistanceGroupDetailRoute,
                            arguments: AssistanceGroupDetailPageArgs(
                              id: groups[index].id!,
                              practicum: widget.practicum,
                            ),
                          ),
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
              arguments: AssistanceGroupFormPageArgs(
                practicumId: widget.practicum.id!,
                groupNumber: groups.isEmpty ? 1 : groups.last.number! + 1,
              ),
            ),
            tooltip: 'Tambah',
            child: const Icon(
              Icons.add_rounded,
              size: 28,
            ),
          ),
        );
      },
    );
  }
}
