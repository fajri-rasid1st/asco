// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/sliver_grouped_list.dart';

// Project imports:
import 'package:asco/core/enums/user_badge_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/assistance_groups/assistance_group.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/presentation/features/admin/assistance_group/providers/assistance_groups_provider.dart';
import 'package:asco/src/presentation/providers/manual_providers/query_provider.dart';
import 'package:asco/src/presentation/shared/features/control_card/pages/control_card_detail_page.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/search_field.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';

class ControlCardListHomePage extends StatelessWidget {
  final Practicum practicum;

  const ControlCardListHomePage({super.key, required this.practicum});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '${practicum.course}',
      ),
      body: CustomScrollView(
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
                    hintText: 'Cari nama atau username',
                    onChanged: (query) => searchGroups(ref, query),
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
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            sliver: Consumer(
              builder: (context, ref, child) {
                final query = ref.watch(queryProvider);

                final groups = ref.watch(
                  AssistanceGroupsProvider(
                    practicum.id!,
                    query: query,
                  ),
                );

                ref.listen(
                  AssistanceGroupsProvider(
                    practicum.id!,
                    query: query,
                  ),
                  (_, state) => state.whenOrNull(error: context.responseError),
                );

                return groups.when(
                  loading: () => const SliverFillRemaining(
                    child: LoadingIndicator(),
                  ),
                  error: (_, __) => const SliverFillRemaining(),
                  data: (groups) {
                    if (groups == null) return const SliverFillRemaining();

                    if (groups.isEmpty && query.isNotEmpty) {
                      return const SliverFillRemaining(
                        child: CustomInformation(
                          title: 'Peserta tidak ditemukan',
                          subtitle: 'Silahkan cari dengan keyword lain',
                        ),
                      );
                    }

                    if (groups.isEmpty) {
                      return const SliverFillRemaining(
                        child: CustomInformation(
                          title: 'Data kartu kontrol kosong',
                          subtitle: 'Tidak ada kartu kontrol peserta yang dapat ditampilkan',
                        ),
                      );
                    }

                    return SliverGroupedListView<AssistanceGroup, int>(
                      elements: groups,
                      groupBy: (group) => group.number!,
                      groupHeaderBuilder: (group) => SectionHeader(
                        title: 'Grup #${group.number}',
                        showDivider: true,
                        padding: EdgeInsets.fromLTRB(4, group == groups.first ? 4 : 16, 0, 8),
                      ),
                      itemBuilder: (context, group) => Column(
                        children: List<Padding>.generate(
                          group.students!.length,
                          (index) => Padding(
                            padding: EdgeInsets.only(
                              bottom: index == group.students!.length - 1 ? 0 : 8,
                            ),
                            child: UserCard(
                              user: group.students![index],
                              badgeType: UserBadgeType.text,
                              onTap: () => navigatorKey.currentState!.pushNamed(
                                controlCardDetailRoute,
                                arguments: ControlCardDetailPageArgs(
                                  practicum: practicum,
                                  groupNumber: group.number!,
                                  student: group.students![index],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void searchGroups(WidgetRef ref, String query) {
    ref.read(queryProvider.notifier).state = query;
  }
}
