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
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/presentation/features/admin/meeting/pages/meeting_form_page.dart';
import 'package:asco/src/presentation/features/admin/meeting/providers/meeting_actions_provider.dart';
import 'package:asco/src/presentation/features/admin/meeting/providers/meetings_provider.dart';
import 'package:asco/src/presentation/providers/manual_providers/query_provider.dart';
import 'package:asco/src/presentation/providers/manual_providers/sorting_provider.dart';
import 'package:asco/src/presentation/shared/widgets/animated_fab.dart';
import 'package:asco/src/presentation/shared/widgets/cards/meeting_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_icon_button.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/search_field.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';

class MeetingListHomePage extends ConsumerStatefulWidget {
  final Practicum practicum;

  const MeetingListHomePage({super.key, required this.practicum});

  @override
  ConsumerState<MeetingListHomePage> createState() => _MeetingListHomePageState();
}

class _MeetingListHomePageState extends ConsumerState<MeetingListHomePage>
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
    final query = ref.watch(queryProvider);
    final ascendingOrder = ref.watch(ascendingOrderProvider);
    final meetings = ref.watch(
      MeetingsProvider(
        widget.practicum.id!,
        ascendingOrder: ascendingOrder,
      ),
    );

    ref.listen(
      MeetingsProvider(
        widget.practicum.id!,
        ascendingOrder: ascendingOrder,
      ),
      (_, state) {
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
      },
    );

    ref.listen(meetingActionsProvider, (_, state) {
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

            ref.invalidate(meetingsProvider);

            context.showSnackBar(
              title: 'Berhasil',
              message: data.message!,
            );
          }
        },
      );
    });

    return meetings.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (meetings) {
        if (meetings == null) return const Scaffold();

        return Scaffold(
          appBar: CustomAppBar(
            title: '${widget.practicum.course}',
          ),
          body: NotificationListener<UserScrollNotification>(
            onNotification: (notification) => FunctionHelper.handleFabVisibilityOnScroll(
              fabAnimationController,
              notification,
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: Palette.scaffoldBackground,
                  surfaceTintColor: Palette.scaffoldBackground,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: SearchField(
                            text: query,
                            hintText: 'Cari nama pertemuan',
                            onChanged: (value) => ref.read(queryProvider.notifier).state = value,
                          ),
                        ),
                        const SizedBox(width: 8),
                        CustomIconButton(
                          'arrow_sort_outlined.svg',
                          tooltip: 'Urutkan',
                          onPressed: sortMeeting,
                        ),
                      ],
                    ),
                  ),
                  bottom: const PreferredSize(
                    preferredSize: Size.fromHeight(20),
                    child: SizedBox(),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  sliver: Builder(
                    builder: (context) {
                      if (meetings.isEmpty && query.isNotEmpty) {
                        return const SliverFillRemaining(
                          child: CustomInformation(
                            title: 'Pertemuan tidak ditemukan',
                            subtitle: 'Silahkan cari dengan keyword lain',
                          ),
                        );
                      }

                      if (meetings.isEmpty) {
                        return const SliverFillRemaining(
                          child: CustomInformation(
                            title: 'Data pertemuan kosong',
                            subtitle: 'Tambahkan pertemuan dengan menekan tombol "Tambah"',
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => Padding(
                            padding: EdgeInsets.only(
                              bottom: index == meetings.length - 1 ? 0 : 10,
                            ),
                            child: MeetingCard(
                              meeting: meetings[index],
                              showDeleteButton: true,
                              onTap: () => navigatorKey.currentState!.pushNamed(meetingDetailRoute),
                            ),
                          ),
                          childCount: meetings.length,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: AnimatedFloatingActionButton(
            animationController: fabAnimationController,
            onPressed: () => navigatorKey.currentState!.pushNamed(
              meetingFormRoute,
              arguments: MeetingFormPageArgs(
                meetingNumber: meetings.isEmpty ? 1 : meetings.last.number! + 1,
                assistants: widget.practicum.assistants!,
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

  void sortMeeting() {
    ref.read(queryProvider.notifier).state = '';
    ref.read(ascendingOrderProvider.notifier).update((state) => !state);
  }
}
