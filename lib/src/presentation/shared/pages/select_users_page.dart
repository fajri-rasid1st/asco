// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/user_badge_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/providers/manual_providers/query_provider.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/search_field.dart';

class SelectUsersPage extends StatefulWidget {
  final SelectUsersPageArgs args;

  const SelectUsersPage({super.key, required this.args});

  @override
  State<SelectUsersPage> createState() => _SelectUsersPageState();
}

class _SelectUsersPageState extends State<SelectUsersPage> {
  List<int> selectedUsers = [];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        showCancelMessage(context);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.args.title,
          leading: IconButton(
            onPressed: () => showCancelMessage(context),
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
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 10,
                  (context, index) => Padding(
                    padding: EdgeInsets.only(
                      bottom: index == 9 ? 0 : 10,
                    ),
                    child: UserCard(
                      badgeType: UserBadgeType.text,
                      trailing: selectedUsers.contains(index)
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
                      onTap: () {
                        setState(() {
                          if (selectedUsers.contains(index)) {
                            selectedUsers.remove(index); // Unselect
                          } else {
                            selectedUsers.add(index); // Select
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCancelMessage(BuildContext context) {
    context.showConfirmDialog(
      title: 'Batalkan Pilih ${widget.args.role}?',
      message:
          'Daftar ${widget.args.role} yang telah dipilih tidak akan tersimpan. Harap tekan tombol Submit setelah selesai memilih ${widget.args.role}.',
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

  const SelectUsersPageArgs({
    required this.title,
    required this.role,
  });
}
