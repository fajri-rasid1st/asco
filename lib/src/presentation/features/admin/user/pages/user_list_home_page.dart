// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/form_action_type.dart';
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/features/admin/user/pages/user_form_page.dart';
import 'package:asco/src/presentation/features/admin/user/providers/users_provider.dart';
import 'package:asco/src/presentation/providers/manual_providers/query_provider.dart';
import 'package:asco/src/presentation/shared/widgets/animated_fab.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_filter_chip.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/search_field.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';

final selectedRoleProvider = StateProvider.autoDispose<String>((ref) => '');

class UserListHomePage extends ConsumerStatefulWidget {
  const UserListHomePage({super.key});

  @override
  ConsumerState<UserListHomePage> createState() => _UserListHomePageState();
}

class _UserListHomePageState extends ConsumerState<UserListHomePage>
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
    final labels = userRoleFilter.keys.toList();

    ref.listen(usersProvider, (_, state) {
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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Consumer(
                  builder: (context, ref, child) {
                    return SearchField(
                      text: ref.watch(queryProvider),
                      hintText: 'Cari nama atau username',
                      onChanged: (value) {
                        ref.read(queryProvider.notifier).state = value;
                        ref.read(selectedRoleProvider.notifier).state = '';
                      },
                    );
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
                    itemBuilder: (context, index) => Consumer(
                      builder: (context, ref, child) {
                        final userRole = userRoleFilter[labels[index]]!;

                        return CustomFilterChip(
                          label: labels[index],
                          selected: ref.watch(selectedRoleProvider) == userRole,
                          onSelected: (_) => filterUsers(userRole),
                        );
                      },
                    ),
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemCount: labels.length,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              sliver: Consumer(
                builder: (context, ref, child) {
                  final users = ref.watch(usersProvider);
                  final query = ref.watch(queryProvider);

                  return users.when(
                    loading: () => const SliverFillRemaining(
                      child: LoadingIndicator(),
                    ),
                    error: (_, __) => const SliverFillRemaining(),
                    data: (users) {
                      if (users == null) return const SliverFillRemaining();

                      if (users.isEmpty && query.isNotEmpty) {
                        return const SliverFillRemaining(
                          child: CustomInformation(
                            title: 'Pengguna tidak ditemukan',
                            subtitle: 'Silahkan cari dengan keyword lain',
                          ),
                        );
                      }

                      if (users.isEmpty) {
                        return const SliverFillRemaining(
                          child: CustomInformation(
                            title: 'Data pengguna masih kosong',
                            subtitle: 'Tambahkan pengguna dengan menekan tombol "Tambah"',
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => Padding(
                            padding: EdgeInsets.only(
                              bottom: index == 9 ? 0 : 10,
                            ),
                            child: UserCard(
                              profile: users[index],
                              onTap: () => navigatorKey.currentState!.pushNamed(userDetailRoute),
                              showDeleteButton: true,
                              onPressedDeleteButton: () => context.showConfirmDialog(
                                title: 'Hapus Pengguna?',
                                message: 'Anda yakin ingin menghapus user ini?',
                                primaryButtonText: 'Hapus',
                                onPressedPrimaryButton: () {},
                              ),
                            ),
                          ),
                          childCount: users.length,
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
      floatingActionButton: AnimatedFloatingActionButton(
        animationController: fabAnimationController,
        onPressed: () => navigatorKey.currentState!.pushNamed(
          userFormRoute,
          arguments: const UserFormPageArgs(
            title: 'Tambah',
            action: FormActionType.create,
          ),
        ),
        tooltip: 'Tambah',
        child: const Icon(
          Icons.add_rounded,
          size: 28,
        ),
      ),
    );
  }

  void filterUsers(String role) {
    ref.read(queryProvider.notifier).state = '';
    ref.read(selectedRoleProvider.notifier).state = role;
    ref.read(usersProvider.notifier).filterUsers(role: role);
  }
}
