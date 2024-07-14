// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/presentation/features/admin/practicum/providers/practicums_provider.dart';
import 'package:asco/src/presentation/shared/widgets/cards/practicum_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';

class SelectPracticumPage extends StatelessWidget {
  final SelectPracticumPageArgs args;

  const SelectPracticumPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Pilih Praktikum',
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final practicums = ref.watch(practicumsProvider);

          ref.listen(practicumsProvider, (_, state) {
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

          return practicums.when(
            loading: () => const LoadingIndicator(),
            error: (_, __) => const SizedBox(),
            data: (practicums) {
              if (practicums == null) return const SizedBox();

              if (practicums.isEmpty) {
                return const CustomInformation(
                  title: 'Data praktikum belum ada',
                  subtitle: 'Silahkan tambah praktikum pada menu data praktikum',
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) => PracticumCard(
                  practicum: practicums[index],
                  showClassroomAndMeetingButtons: args.showClassroomAndMeetingButtons,
                  onTap: args.onItemTapped,
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemCount: practicums.length,
              );
            },
          );
        },
      ),
    );
  }
}

class SelectPracticumPageArgs {
  final bool showClassroomAndMeetingButtons;
  final VoidCallback? onItemTapped;

  const SelectPracticumPageArgs({
    this.showClassroomAndMeetingButtons = false,
    this.onItemTapped,
  });
}
