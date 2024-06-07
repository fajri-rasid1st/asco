// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/providers/manual_providers/search_provider.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/search_field.dart';

class PracticumAssistantListPage extends ConsumerStatefulWidget {
  // final List<Assistant>? currentAssistants;

  const PracticumAssistantListPage({super.key});

  @override
  ConsumerState<PracticumAssistantListPage> createState() => _PracticumAssistantListPageState();
}

class _PracticumAssistantListPageState extends ConsumerState<PracticumAssistantListPage> {
  List<int> selectedAssistants = [];

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(queryProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        showCancelMessage(context);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Pilih Asisten',
          leading: IconButton(
            onPressed: () => showCancelMessage(context),
            icon: const Icon(Icons.close_rounded),
            iconSize: 22,
            tooltip: 'Batalkan',
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: const CircleBorder(),
            ),
          ),
          action: IconButton(
            onPressed: () => navigatorKey.currentState!.pop(selectedAssistants),
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
                child: SearchField(
                  text: query,
                  hintText: 'Cari nama atau username',
                  onChanged: (value) => ref.read(queryProvider.notifier).state = value,
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
                      child: UserCard(
                        showBadge: false,
                        trailing: selectedAssistants.contains(index)
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
                            if (selectedAssistants.contains(index)) {
                              selectedAssistants.remove(index); // Unselect
                            } else {
                              selectedAssistants.add(index); // Select
                            }
                          });
                        },
                      ),
                    );
                  },
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
      title: 'Batalkan Pilih Asisten?',
      message:
          'Daftar Asisten yang telah dipilih tidak akan tersimpan. Harap tekan tombol Submit setelah selesai memilih Asisten.',
      primaryButtonText: 'Batalkan',
      onPressedPrimaryButton: () {
        // Delete previously created practicum if exist
        navigatorKey.currentState!.pop();
        navigatorKey.currentState!.pop();
      },
    );
  }
}
