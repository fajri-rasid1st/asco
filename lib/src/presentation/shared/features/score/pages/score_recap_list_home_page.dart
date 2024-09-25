// Dart imports:
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:excel/excel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/enums/user_badge_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/helpers/excel_helper.dart';
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/services/file_service.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/data/models/scores/score_recap.dart';
import 'package:asco/src/presentation/providers/manual_providers/query_provider.dart';
import 'package:asco/src/presentation/shared/features/score/providers/scores_provider.dart';
import 'package:asco/src/presentation/shared/widgets/animated_fab.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/search_field.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class ScoreRecapListHomePage extends StatefulWidget {
  final Practicum practicum;

  const ScoreRecapListHomePage({super.key, required this.practicum});

  @override
  State<ScoreRecapListHomePage> createState() => _ScoreRecapListHomePageState();
}

class _ScoreRecapListHomePageState extends State<ScoreRecapListHomePage>
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
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Rekap Nilai - Pemrograman Mobile',
        action: IconButton(
          onPressed: () => context.showSortingDialog(
            items: ['Nilai', 'NIM', 'Nama Lengkap'],
            values: ['score', 'username', 'fullname'],
            onSubmitted: (value) {},
          ),
          icon: const Icon(Icons.filter_list_rounded),
          tooltip: 'Urutkan',
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
          ),
        ),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) => MapHelper.getRoleId(CredentialSaver.credential?.role) == 0
            ? FunctionHelper.handleFabVisibilityOnScroll(fabAnimationController, notification)
            : false,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              backgroundColor: Palette.scaffoldBackground,
              surfaceTintColor: Palette.scaffoldBackground,
              flexibleSpace: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Consumer(
                  builder: (context, ref, child) {
                    return SearchField(
                      text: ref.watch(queryProvider),
                      hintText: 'Cari nama atau NIM',
                      onChanged: (value) => ref.read(queryProvider.notifier).state = value,
                    );
                  },
                ),
              ),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(20),
                child: SizedBox(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              sliver: Consumer(
                builder: (context, ref, child) {
                  final query = ref.watch(queryProvider);
                  final scores = ref.watch(ScoresProvider(widget.practicum.id!));

                  ref.listen(ScoresProvider(widget.practicum.id!), (_, state) {
                    state.whenOrNull(error: context.responseError);
                  });

                  return scores.when(
                    loading: () => const SliverFillRemaining(
                      child: LoadingIndicator(),
                    ),
                    error: (_, __) => const SliverFillRemaining(),
                    data: (scores) {
                      if (scores == null) return const SliverFillRemaining();

                      if (scores.isEmpty && query.isNotEmpty) {
                        return const SliverFillRemaining(
                          child: CustomInformation(
                            title: 'User tidak ditemukan',
                            subtitle: 'Silahkan cari dengan keyword lain',
                          ),
                        );
                      }

                      if (scores.isEmpty) {
                        return const SliverFillRemaining(
                          child: CustomInformation(
                            title: 'Data rekap nilai kosong',
                            subtitle: 'Daftar rekap nilai belum tersedia',
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => Padding(
                            padding: EdgeInsets.only(
                              bottom: index == scores.length - 1 ? 0 : 10,
                            ),
                            child: UserCard(
                              user: scores[index].student!,
                              badgeType: UserBadgeType.text,
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(
                                  '${scores[index].finalScore?.toStringAsFixed(1)}',
                                  style: textTheme.titleLarge!.copyWith(
                                    color: Palette.purple2,
                                  ),
                                ),
                              ),
                              onTap: () => navigatorKey.currentState!.pushNamed(
                                scoreRecapDetailRoute,
                                arguments: scores[index].student?.username,
                              ),
                            ),
                          ),
                          childCount: scores.length,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: MapHelper.getRoleId(CredentialSaver.credential?.role) == 0
          ? Consumer(
              builder: (context, ref, child) {
                final scores = ref.watch(ScoresProvider(widget.practicum.id!)).valueOrNull;

                return AnimatedFloatingActionButton(
                  animationController: fabAnimationController,
                  onPressed: scores != null ? () => exportScoreToExcel(context, ref, scores) : null,
                  tooltip: 'Export ke Excel',
                  child: SvgAsset(
                    AssetPath.getIcon('file_excel_outlined.svg'),
                    width: 26,
                  ),
                );
              },
            )
          : null,
    );
  }

  Future<void> exportScoreToExcel(
    BuildContext context,
    WidgetRef ref,
    List<ScoreRecap> scores,
  ) async {
    context.showLoadingDialog();

    final excel = Excel.createExcel();

    for (var i = 0; i < scores.length; i++) {
      ExcelHelper.insertScoreToExcel(
        excel: excel,
        scores: scores,
      );
    }

    final excelBytes = excel.save();

    if (excelBytes == null) return;

    if (await FileService.saveFileFromRawBytes(
      Uint8List.fromList(excelBytes),
      name: 'Rekap Nilai ${widget.practicum.course}.xlsx',
    )) {
      if (!context.mounted) return;

      context.showSnackBar(
        title: 'Berhasil',
        message: 'Rekap nilai praktikum berhasil diekspor pada folder Download.',
      );
    } else {
      if (!context.mounted) return;

      context.showSnackBar(
        title: 'Terjadi Kesalahan',
        message: 'Rekap nilai praktikum gagal diekspor.',
        type: SnackBarType.error,
      );
    }

    navigatorKey.currentState!.pop();
  }
}
