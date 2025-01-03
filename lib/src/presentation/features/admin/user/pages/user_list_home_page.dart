// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/model_attributes.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/features/admin/user/providers/user_actions_provider.dart';
import 'package:asco/src/presentation/features/admin/user/providers/users_provider.dart';
import 'package:asco/src/presentation/providers/manual_providers/ascending_provider.dart';
import 'package:asco/src/presentation/providers/manual_providers/query_provider.dart';
import 'package:asco/src/presentation/providers/manual_providers/user_attribute_provider.dart';
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

class _UserListHomePageState extends ConsumerState<UserListHomePage> with SingleTickerProviderStateMixin {
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
    final labels = MapHelper.roleFilterMap.keys.toList();

    ref.listen(userActionsProvider, (_, state) {
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

            ref.invalidate(usersProvider);
            ref.invalidate(userAttributeProvider);
            ref.invalidate(ascendingProvider);
            ref.invalidate(queryProvider);
            ref.invalidate(selectedRoleProvider);

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
        title: 'Data Pengguna',
        action: Consumer(
          builder: (context, ref, child) {
            final userAttribute = ref.watch(userAttributeProvider);
            final asc = ref.watch(ascendingProvider);

            return IconButton(
              onPressed: () => context.showSortingDialog(
                items: [
                  'Username',
                  'Nama Lengkap',
                ],
                values: [
                  UserAttribute.username,
                  UserAttribute.fullname,
                ],
                sortedBy: userAttribute,
                asc: asc,
                onSubmitted: (value) => sortUsers(value),
              ),
              icon: const Icon(Icons.filter_list_rounded),
              tooltip: 'Urutkan',
              style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: const CircleBorder(),
              ),
            );
          },
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
                      onChanged: (query) => searchUsers(query),
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
                        final userRole = MapHelper.roleFilterMap[labels[index]]!;

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
                  final role = ref.watch(selectedRoleProvider);
                  final query = ref.watch(queryProvider);
                  final sortedBy = ref.watch(userAttributeProvider);
                  final asc = ref.watch(ascendingProvider);

                  final users = ref.watch(
                    UsersProvider(
                      role: role,
                      query: query,
                      sortedBy: sortedBy,
                      asc: asc,
                    ),
                  );

                  ref.listen(
                    UsersProvider(
                      role: role,
                      query: query,
                      sortedBy: sortedBy,
                      asc: asc,
                    ),
                    (_, state) => state.whenOrNull(error: context.responseError),
                  );

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
                            title: 'User tidak ditemukan',
                            subtitle: 'Silahkan cari dengan keyword lain',
                          ),
                        );
                      }

                      if (users.isEmpty) {
                        return const SliverFillRemaining(
                          child: CustomInformation(
                            title: 'Data user kosong',
                            subtitle: 'Tambahkan user dengan menekan tombol "Tambah"',
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => Padding(
                            padding: EdgeInsets.only(
                              bottom: index == users.length - 1 ? 0 : 10,
                            ),
                            child: UserCard(
                              user: users[index],
                              onTap: () => navigatorKey.currentState!.pushNamed(
                                userDetailRoute,
                                arguments: users[index].username,
                              ),
                              showDeleteButton: true,
                              onPressedDeleteButton: () => context.showConfirmDialog(
                                title: 'Hapus Pengguna?',
                                message: 'Anda yakin ingin menghapus user ini?',
                                primaryButtonText: 'Hapus',
                                onPressedPrimaryButton: () =>
                                    ref.read(userActionsProvider.notifier).deleteUser(users[index].username!),
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
        onPressed: () => navigatorKey.currentState!.pushNamed(userFormRoute),
        tooltip: 'Tambah',
        child: const Icon(
          Icons.add_rounded,
          size: 28,
        ),
      ),
    );
  }

  void sortUsers(Map<String, dynamic> value) {
    ref.read(userAttributeProvider.notifier).state = value['sortedBy'];
    ref.read(ascendingProvider.notifier).state = value['asc'];
    ref.invalidate(queryProvider);
    ref.invalidate(selectedRoleProvider);
  }

  void searchUsers(String query) {
    ref.read(queryProvider.notifier).state = query;
    ref.invalidate(userAttributeProvider);
    ref.invalidate(ascendingProvider);
    ref.invalidate(selectedRoleProvider);
  }

  void filterUsers(String role) {
    ref.read(selectedRoleProvider.notifier).state = role;
    ref.invalidate(userAttributeProvider);
    ref.invalidate(ascendingProvider);
    ref.invalidate(queryProvider);
  }
}
