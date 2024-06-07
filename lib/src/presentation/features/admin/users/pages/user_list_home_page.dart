// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/features/admin/users/pages/user_form_page.dart';
import 'package:asco/src/presentation/shared/providers/manual_providers/search_provider.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_fab.dart';
import 'package:asco/src/presentation/shared/widgets/custom_filter_chip.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/search_field.dart';

final selectedRoleProvider = StateProvider.autoDispose<String>((ref) => '');

class UserListHomePage extends ConsumerWidget {
  const UserListHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = userRole.keys.toList();

    final query = ref.watch(queryProvider);
    final selectedRole = ref.watch(selectedRoleProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Data Pengguna',
        action: IconButton(
          onPressed: () => context.showSortingDialog(
            items: ['Tanggal Ditambahkan', 'Nama Lengkap', 'Username'],
            values: ['dateCreated', 'fullname', 'username'],
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: Palette.scaffoldBackground,
            surfaceTintColor: Palette.scaffoldBackground,
            flexibleSpace: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: SearchField(
                text: query,
                hintText: 'Cari nama atau username',
                onChanged: (value) {
                  ref.read(queryProvider.notifier).state = value;
                  ref.read(selectedRoleProvider.notifier).state = '';
                },
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(66),
              child: SizedBox(
                height: 56,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CustomFilterChip(
                      label: labels[index],
                      selected: selectedRole == userRole[labels[index]],
                      onSelected: (_) {
                        ref.read(queryProvider.notifier).state = '';
                        ref.read(selectedRoleProvider.notifier).state = userRole[labels[index]]!;
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemCount: userRole.length,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 10,
                (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == 9 ? 0 : 10,
                    ),
                    child: UserCard(
                      onTap: () => navigatorKey.currentState!.pushNamed(userDetailRoute),
                      showDeleteButton: true,
                      onPressedDeleteButton: () => context.showConfirmDialog(
                        title: 'Hapus Pengguna?',
                        message: 'Anda yakin ingin menghapus user ini?',
                        primaryButtonText: 'Hapus',
                        onPressedPrimaryButton: () {},
                      ),
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
          userFormRoute,
          arguments: const UserFormPageArgs(action: 'Tambah'),
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
