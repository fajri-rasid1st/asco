// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/presentation/features/admin/meeting/pages/meeting_detail_page.dart';
import 'package:asco/src/presentation/features/admin/meeting/pages/meeting_form_page.dart';
import 'package:asco/src/presentation/features/admin/meeting/providers/meeting_actions_provider.dart';
import 'package:asco/src/presentation/features/admin/meeting/providers/meetings_provider.dart';
import 'package:asco/src/presentation/providers/manual_providers/ascending_provider.dart';
import 'package:asco/src/presentation/providers/manual_providers/query_provider.dart';
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

class _MeetingListHomePageState extends ConsumerState<MeetingListHomePage> with SingleTickerProviderStateMixin {
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
    final meetings = ref.watch(MeetingsProvider(widget.practicum.id!)).valueOrNull;

    ref.listen(meetingActionsProvider, (_, state) {
      state.when(
        loading: () => context.showLoadingDialog(),
        error: (error, stackTrace) {
          navigatorKey.currentState!.pop();

          context.responseError(error, stackTrace);
        },
        data: (data) {
          if (data.message != null) {
            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop();

            ref.invalidate(meetingsProvider);
            ref.invalidate(queryProvider);
            ref.invalidate(ascendingProvider);

            context.showSnackBar(
              title: 'Berhasil',
              message: data.message!,
            );
          }
        },
      );
    });

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
                      child: Consumer(
                        builder: (context, ref, child) {
                          return SearchField(
                            text: ref.watch(queryProvider),
                            hintText: 'Cari nama pertemuan',
                            onChanged: (query) => searchMeetings(query),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    CustomIconButton(
                      'arrow_sort_outlined.svg',
                      tooltip: 'Urutkan',
                      onPressed: sortMeetings,
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
              sliver: Consumer(
                builder: (context, ref, child) {
                  final query = ref.watch(queryProvider);
                  final asc = ref.watch(ascendingProvider);

                  final meetings = ref.watch(
                    MeetingsProvider(
                      widget.practicum.id!,
                      query: query,
                      asc: asc,
                    ),
                  );

                  ref.listen(
                    MeetingsProvider(
                      widget.practicum.id!,
                      query: query,
                      asc: asc,
                    ),
                    (_, state) => state.whenOrNull(error: context.responseError),
                  );

                  return meetings.when(
                    loading: () => const SliverFillRemaining(
                      child: LoadingIndicator(),
                    ),
                    error: (_, __) => const SliverFillRemaining(),
                    data: (meetings) {
                      if (meetings == null) return const SliverFillRemaining();

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
                              onTap: () => navigatorKey.currentState!.pushNamed(
                                meetingDetailRoute,
                                arguments: MeetingDetailPageArgs(
                                  id: meetings[index].id!,
                                  practicum: widget.practicum,
                                ),
                              ),
                            ),
                          ),
                          childCount: meetings.length,
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
      floatingActionButton: meetings != null
          ? AnimatedFloatingActionButton(
              animationController: fabAnimationController,
              onPressed: () => navigatorKey.currentState!.pushNamed(
                meetingFormRoute,
                arguments: MeetingFormPageArgs(
                  practicumId: widget.practicum.id!,
                  meetingNumber: meetings.isEmpty ? 1 : meetings.last.number! + 1,
                ),
              ),
              tooltip: 'Tambah',
              child: const Icon(
                Icons.add_rounded,
                size: 28,
              ),
            )
          : null,
    );
  }

  void searchMeetings(String query) {
    ref.read(queryProvider.notifier).state = query;
    ref.invalidate(ascendingProvider);
  }

  void sortMeetings() {
    ref.read(ascendingProvider.notifier).update((state) => !state);
    ref.invalidate(queryProvider);
  }
}
