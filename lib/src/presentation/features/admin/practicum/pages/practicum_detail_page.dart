// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/user_badge_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/features/admin/practicum/pages/practicum_form_page.dart';
import 'package:asco/src/presentation/features/admin/practicum/providers/practicum_actions_provider.dart';
import 'package:asco/src/presentation/features/admin/practicum/providers/practicum_detail_provider.dart';
import 'package:asco/src/presentation/shared/widgets/cards/classroom_card.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';
import 'package:asco/src/presentation/shared/widgets/practicum_badge_image.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class PracticumDetailPage extends ConsumerWidget {
  final String id;

  const PracticumDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final practicum = ref.watch(PracticumDetailProvider(id));

    ref.listen(PracticumDetailProvider(id), (_, state) {
      state.whenOrNull(error: context.responseError);
    });

    ref.listen(practicumActionsProvider, (_, state) {
      state.whenOrNull(
        error: (_, __) => navigatorKey.currentState!.pop(),
        data: (data) {
          if (data.message != null) ref.invalidate(practicumDetailProvider);
        },
      );
    });

    return practicum.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (practicum) {
        if (practicum == null) return const Scaffold();

        return Scaffold(
          appBar: CustomAppBar(
            title: 'Detail Praktikum',
            action: IconButton(
              onPressed: () => navigatorKey.currentState!.pushNamed(
                practicumFirstFormRoute,
                arguments: PracticumFormPageArgs(practicum: practicum),
              ),
              icon: const Icon(Icons.edit_rounded),
              iconSize: 20,
              tooltip: 'Edit',
              style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: const CircleBorder(),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Palette.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      SvgAsset(
                        AssetPath.getVector('bg_attribute_3.svg'),
                        height: 44,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            PracticumBadgeImage(
                              badgeUrl: '${practicum.badgePath}',
                              width: 48,
                              height: 52,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mata Kuliah',
                                    style: textTheme.bodySmall!.copyWith(
                                      color: Palette.secondaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${practicum.course}',
                                    style: textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SectionHeader(title: 'Kelas'),
                if (practicum.classrooms!.isEmpty)
                  const CustomInformation(
                    title: 'Kelas masih kosong',
                    subtitle: 'Belum ada kelas pada praktikum ini',
                  )
                else
                  ...List<Padding>.generate(
                    practicum.classrooms!.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: index == practicum.classrooms!.length - 1 ? 0 : 10,
                      ),
                      child: ClassroomCard(
                        classroom: practicum.classrooms![index],
                        showActionButtons: true,
                        onDelete: () => context.showConfirmDialog(
                          title: 'Hapus Kelas?',
                          message: 'Anda yakin ingin menghapus kelas ini?',
                          primaryButtonText: 'Hapus',
                          onPressedPrimaryButton: () => ref
                              .read(practicumActionsProvider.notifier)
                              .removeClassroomFromPracticum(practicum.classrooms![index].id!),
                        ),
                      ),
                    ),
                  ),
                const SectionHeader(title: 'Asisten'),
                if (practicum.assistants!.isEmpty)
                  const CustomInformation(
                    title: 'Asisten masih kosong',
                    subtitle: 'Belum ada asisten pada praktikum ini',
                  )
                else
                  ...List<Padding>.generate(
                    practicum.assistants!.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: index == practicum.assistants!.length - 1 ? 0 : 10,
                      ),
                      child: UserCard(
                        user: practicum.assistants![index],
                        badgeType: UserBadgeType.text,
                        showDeleteButton: true,
                        onPressedDeleteButton: () => context.showConfirmDialog(
                          title: 'Keluarkan Asisten?',
                          message: 'Anda yakin ingin mengeluarkan asisten ini?',
                          primaryButtonText: 'Keluarkan',
                          onPressedPrimaryButton: () => ref
                              .read(practicumActionsProvider.notifier)
                              .removeAssistantFromPracticum(
                                id,
                                username: practicum.assistants![index].username!,
                              ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
