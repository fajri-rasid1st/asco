// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/extensions/button_extension.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/number_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/services/file_service.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/presentation/features/admin/meeting/pages/meeting_form_page.dart';
import 'package:asco/src/presentation/features/admin/meeting/providers/meeting_actions_provider.dart';
import 'package:asco/src/presentation/features/admin/meeting/providers/meeting_detail_provider.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class MeetingDetailPage extends ConsumerWidget {
  final MeetingDetailPageArgs args;

  const MeetingDetailPage({super.key, required this.args});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meeting = ref.watch(MeetingDetailProvider(args.id));

    ref.listen(MeetingDetailProvider(args.id), (_, state) {
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

    ref.listen(meetingActionsProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data.message != null) ref.invalidate(meetingDetailProvider);
        },
      );
    });

    return meeting.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (meeting) {
        if (meeting == null) return const Scaffold();

        return Scaffold(
          appBar: CustomAppBar(
            title: 'Pertemuan ${meeting.number}',
            action: IconButton(
              onPressed: () => navigatorKey.currentState!.pushNamed(
                meetingFormRoute,
                arguments: MeetingFormPageArgs(
                  practicumId: args.practicum.id!,
                  meeting: meeting,
                ),
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
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Palette.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        child: SvgAsset(
                          AssetPath.getVector('bg_attribute_3.svg'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleBorderContainer(
                              size: 64,
                              withBorder: false,
                              fillColor: Palette.purple3,
                              child: Text(
                                '#${meeting.number}',
                                style: textTheme.titleLarge!.copyWith(
                                  color: Palette.background,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${meeting.lesson}',
                              style: textTheme.headlineSmall!.copyWith(
                                color: Palette.purple2,
                              ),
                            ),
                            Text(
                              '${args.practicum.course}',
                              style: textTheme.bodyLarge!.copyWith(
                                color: Palette.purple3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${meeting.date?.toDateTimeFormat('d MMMM yyyy')}',
                              style: textTheme.bodySmall!.copyWith(
                                color: Palette.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SectionHeader(title: 'Modul'),
                FilledButton.icon(
                  onPressed: () => openFile(
                    context,
                    name: 'Modul',
                    path: meeting.modulePath,
                  ),
                  icon: const Icon(Icons.menu_book_rounded),
                  label: const Text('Buka Modul'),
                  style: FilledButton.styleFrom(
                    foregroundColor: Palette.purple2,
                    backgroundColor: Palette.background,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ).fullWidth(),
                const SectionHeader(title: 'Soal Praktikum'),
                FilledButton.icon(
                  onPressed: () => openFile(
                    context,
                    name: 'Soal Praktikum',
                    path: meeting.assignmentPath,
                  ),
                  icon: const Icon(Icons.menu_book_rounded),
                  label: const Text('Buka Soal Praktikum'),
                  style: FilledButton.styleFrom(
                    foregroundColor: Palette.purple2,
                    backgroundColor: Palette.background,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ).fullWidth(),
                const SectionHeader(title: 'Mentor'),
                UserCard(
                  user: meeting.assistant!,
                  badgeText: 'Pemateri',
                ),
                const SizedBox(height: 10),
                UserCard(
                  user: meeting.coAssistant!,
                  badgeText: 'Pendamping',
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void openFile(
    BuildContext context, {
    required String name,
    String? path,
  }) {
    if (path != null) {
      final isUrl = Uri.tryParse(path)?.isAbsolute ?? false;

      FileService.openFile(path, isUrl);
    } else {
      context.showSnackBar(
        title: '$name Tidak Ada',
        message: 'File $name belum dimasukkan.',
        type: SnackBarType.info,
      );
    }
  }
}

class MeetingDetailPageArgs {
  final String id;
  final Practicum practicum;

  const MeetingDetailPageArgs({
    required this.id,
    required this.practicum,
  });
}
