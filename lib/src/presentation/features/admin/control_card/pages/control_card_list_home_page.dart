// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/sliver_grouped_list.dart';

// Project imports:
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/providers/manual_providers/query_provider.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/search_field.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';

class ControlCardListHomePage extends StatelessWidget {
  const ControlCardListHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const groups = [1, 3, 3, 2, 1, 2, 1, 3, 1, 2];

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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Consumer(
                builder: (context, ref, child) {
                  return SearchField(
                    text: ref.watch(queryProvider),
                    hintText: 'Cari nama atau username',
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
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            sliver: SliverGroupedListView<int, int>(
              elements: groups,
              groupBy: (e) => e,
              groupHeaderBuilder: (e) => SectionHeader(
                title: 'Grup #$e',
                showDivider: true,
                padding: EdgeInsets.fromLTRB(4, e == 1 ? 4 : 12, 0, 6),
              ),
              itemBuilder: (context, index) => UserCard(
                user: CredentialSaver.credential!,
                badgeText: 'Kelas A',
                onTap: () => navigatorKey.currentState!.pushNamed(controlCardDetailRoute),
              ),
              separator: const SizedBox(height: 10),
            ),
          ),
        ],
      ),
    );
  }
}
