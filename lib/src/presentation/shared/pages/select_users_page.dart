// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/enums/user_badge_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/features/admin/user/providers/users_provider.dart';
import 'package:asco/src/presentation/providers/manual_providers/query_provider.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/search_field.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';

class SelectUsersPage extends StatefulWidget {
  final SelectUsersPageArgs args;

  const SelectUsersPage({super.key, required this.args});

  @override
  State<SelectUsersPage> createState() => _SelectUsersPageState();
}

class _SelectUsersPageState extends State<SelectUsersPage> {
  List<Profile> selectedUsers = [];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        if (selectedUsers.isEmpty) {
          navigatorKey.currentState!.pop();
        } else {
          showCancelMessage(context);
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.args.title,
          leading: IconButton(
            onPressed: () => selectedUsers.isEmpty
                ? navigatorKey.currentState!.pop()
                : showCancelMessage(context),
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Batalkan',
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: const CircleBorder(),
            ),
          ),
          action: IconButton(
            onPressed: () => navigatorKey.currentState!.pop(selectedUsers),
            icon: const Icon(Icons.check_rounded),
            tooltip: 'Submit',
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
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              sliver: Consumer(
                builder: (context, ref, child) {
                  final query = ref.watch(queryProvider);
                  final users = ref.watch(
                    UsersProvider(
                      role: widget.args.role,
                      practicum: widget.args.practicum,
                    ),
                  );

                  ref.listen(
                    UsersProvider(
                      role: widget.args.role,
                      practicum: widget.args.practicum,
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

                  return users.when(
                    loading: () => const SliverFillRemaining(
                      child: LoadingIndicator(),
                    ),
                    error: (_, __) => const SliverFillRemaining(),
                    data: (users) {
                      if (users == null) return const SliverFillRemaining();

                      if (users.isEmpty && query.isNotEmpty) {
                        return SliverFillRemaining(
                          child: CustomInformation(
                            title: '${MapHelper.getReadableRole(widget.args.role)} tidak ditemukan',
                            subtitle: 'Silahkan cari dengan keyword lain',
                          ),
                        );
                      }

                      if (users.isEmpty) {
                        return SliverFillRemaining(
                          child: CustomInformation(
                            title: '${MapHelper.getReadableRole(widget.args.role)} tidak tersedia',
                            subtitle:
                                'Tidak ada data ${MapHelper.getReadableRole(widget.args.role)} yang dapat ditambahkan',
                          ),
                        );
                      }

                      for (var user in widget.args.removedUsers) {
                        users.removeWhere((e) => e.username == user.username);
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => Padding(
                            padding: EdgeInsets.only(
                              bottom: index == 9 ? 0 : 10,
                            ),
                            child: UserCard(
                              user: users[index],
                              badgeType: UserBadgeType.text,
                              trailing: selectedUsers
                                      .map((e) => e.username)
                                      .toList()
                                      .contains(users[index].username)
                                  ? const CircleBorderContainer(
                                      size: 28,
                                      borderColor: Palette.purple2,
                                      fillColor: Palette.purple3,
                                      child: Icon(
                                        Icons.check_rounded,
                                        color: Palette.background,
                                        size: 18,
                                      ),
                                    )
                                  : const CircleBorderContainer(size: 28),
                              onTap: () => updateSelectedUsers(users[index]),
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
    );
  }

  void updateSelectedUsers(Profile user) {
    setState(() {
      if (selectedUsers.map((e) => e.username).toList().contains(user.username)) {
        selectedUsers.removeWhere((e) => e.username == user.username);
      } else {
        selectedUsers.add(user);
      }
    });
  }

  void showCancelMessage(BuildContext context) {
    context.showConfirmDialog(
      title: 'Batalkan Pilih ${MapHelper.getReadableRole(widget.args.role)}?',
      message:
          'Daftar ${MapHelper.getReadableRole(widget.args.role)} yang telah dipilih tidak akan tersimpan. Harap tekan tombol Submit setelah selesai memilih.',
      primaryButtonText: 'Batalkan',
      onPressedPrimaryButton: () {
        navigatorKey.currentState!.pop();
        navigatorKey.currentState!.pop();
      },
    );
  }
}

class SelectUsersPageArgs {
  final String title;
  final String role;
  final String practicum;
  final List<Profile> removedUsers;

  const SelectUsersPageArgs({
    required this.title,
    required this.role,
    this.practicum = '',
    required this.removedUsers,
  });
}
