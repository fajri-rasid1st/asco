// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/action_type.dart';
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/features/admin/practicum/providers/practicum_actions_provider.dart';
import 'package:asco/src/presentation/features/admin/practicum/providers/practicums_provider.dart';
import 'package:asco/src/presentation/shared/widgets/animated_fab.dart';
import 'package:asco/src/presentation/shared/widgets/cards/practicum_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';

class PracticumListHomePage extends ConsumerStatefulWidget {
  const PracticumListHomePage({super.key});

  @override
  ConsumerState<PracticumListHomePage> createState() => _PracticumListHomePageState();
}

class _PracticumListHomePageState extends ConsumerState<PracticumListHomePage>
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
    ref.listen(practicumActionsProvider, (_, state) {
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
            if (data.action == ActionType.delete) {
              navigatorKey.currentState!.pop();
            }

            navigatorKey.currentState!.pop();

            ref.invalidate(practicumsProvider);

            context.showSnackBar(
              title: 'Berhasil',
              message: data.message!.split(':').first,
            );
          }
        },
      );
    });

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Data Praktikum',
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) => FunctionHelper.handleFabVisibilityOnScroll(
          fabAnimationController,
          notification,
        ),
        child: Consumer(
          builder: (context, ref, child) {
            final practicums = ref.watch(practicumsProvider);

            ref.listen(practicumsProvider, (_, state) {
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

            return practicums.when(
              loading: () => const LoadingIndicator(),
              error: (_, __) => const SizedBox(),
              data: (practicums) {
                if (practicums == null) return const SizedBox();

                if (practicums.isEmpty) {
                  return const CustomInformation(
                    title: 'Data praktikum tidak ada',
                    subtitle: 'Tambahkan praktikum dengan menekan tombol "Tambah"',
                  );
                }

                return ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (context, index) => PracticumCard(
                    practicum: practicums[index],
                    showDeleteButton: true,
                    onTap: () => navigatorKey.currentState!.pushNamed(
                      practicumDetailRoute,
                      arguments: practicums[index].id,
                    ),
                  ),
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemCount: practicums.length,
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: AnimatedFloatingActionButton(
        animationController: fabAnimationController,
        onPressed: () => navigatorKey.currentState!.pushNamed(practicumFirstFormRoute),
        tooltip: 'Tambah',
        child: const Icon(
          Icons.add_rounded,
          size: 28,
        ),
      ),
    );
  }
}
