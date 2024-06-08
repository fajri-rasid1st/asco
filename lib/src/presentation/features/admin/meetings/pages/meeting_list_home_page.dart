// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/features/admin/meetings/pages/meeting_form_page.dart';
import 'package:asco/src/presentation/shared/providers/manual_providers/search_provider.dart';
import 'package:asco/src/presentation/shared/widgets/cards/meeting_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_fab.dart';
import 'package:asco/src/presentation/shared/widgets/custom_icon_button.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/search_field.dart';

class MeetingListHomePage extends ConsumerWidget {
  const MeetingListHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(queryProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Pemrograman Mobile',
      ),
      body: CustomScrollView(
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
                      hintText: 'Cari nama atau username',
                      onChanged: (value) => ref.read(queryProvider.notifier).state = value,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomIconButton(
                    'arrow_sort_outlined.svg',
                    onPressed: () {},
                    tooltip: 'Urutkan',
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
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 10,
                (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == 9 ? 0 : 10,
                    ),
                    child: MeetingCard(
                      showDeleteButton: true,
                      onTap: () => navigatorKey.currentState!.pushNamed(meetingDetailRoute),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => navigatorKey.currentState!.pushNamed(
          meetingFormRoute,
          arguments: const MeetingFormPageArgs(action: 'Tambah'),
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
