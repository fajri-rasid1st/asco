// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// Project imports:
import 'package:asco/core/enums/attendance_type.dart';
import 'package:asco/core/enums/user_badge_type.dart';
import 'package:asco/core/extensions/button_extension.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/datetime_extension.dart';
import 'package:asco/core/extensions/number_extension.dart';
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/control_cards/control_card.dart';
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/meetings/meeting_post.dart';
import 'package:asco/src/presentation/features/admin/meeting/providers/meeting_actions_provider.dart';
import 'package:asco/src/presentation/features/assistant/assistance/providers/meeting_control_cards_provider.dart';
import 'package:asco/src/presentation/features/assistant/assistance/providers/update_assistance_provider.dart';
import 'package:asco/src/presentation/shared/features/meeting/providers/meeting_detail_provider.dart';
import 'package:asco/src/presentation/shared/widgets/assistance_status_icon.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/assistance_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/attendance_status_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/file_upload_field.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';
import 'package:asco/src/presentation/shared/widgets/section_title.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class AssistantAssistanceDetailPage extends ConsumerWidget {
  final String id;

  const AssistantAssistanceDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meeting = ref.watch(MeetingDetailProvider(id));

    ref.listen(MeetingDetailProvider(id), (_, state) {
      state.whenOrNull(error: context.responseError);
    });

    ref.listen(meetingActionsProvider, (_, state) {
      state.when(
        loading: () => context.showLoadingDialog(),
        error: (error, stackTrace) {
          navigatorKey.currentState!.pop();

          context.responseError(error, stackTrace);
        },
        data: (data) {
          if (data.message != null) {
            navigatorKey.currentState!.pop();

            ref.invalidate(meetingDetailProvider);

            context.showSnackBar(
              title: 'Berhasil',
              message: data.message!,
            );
          }
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
          ),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    color: Palette.purple2,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        RotatedBox(
                          quarterTurns: -2,
                          child: SvgAsset(
                            AssetPath.getVector('bg_attribute.svg'),
                            width: AppSize.getAppWidth(context) / 2,
                          ),
                        ),
                        Positioned.fill(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  '${meeting.lesson}',
                                  style: textTheme.headlineSmall!.copyWith(
                                    color: Palette.background,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverAppBar(
                  elevation: 0,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  toolbarHeight: 6,
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Palette.violet2,
                          Palette.violet4,
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FileUploadField(
                    name: 'assignmentPath',
                    label: 'Soal Praktikum',
                    extensions: const ['pdf', 'doc', 'docx'],
                    withDeleteButton: false,
                    initialValue: meeting.assignmentPath,
                    onChanged: (path) => uploadAssignment(ref, path, meeting),
                    labelStyle: textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const SectionTitle(text: 'Batas Waktu Asistensi'),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            LinearPercentIndicator(
                              percent: calculateAssistanceDeadline(
                                meeting.date!,
                                meeting.assistanceDeadline!,
                                DateTime.now().secondsSinceEpoch,
                              ),
                              animation: true,
                              animationDuration: 1000,
                              curve: Curves.easeOut,
                              padding: EdgeInsets.zero,
                              lineHeight: 24,
                              barRadius: const Radius.circular(12),
                              backgroundColor: Palette.background,
                              linearGradient: const LinearGradient(
                                colors: [
                                  Palette.purple3,
                                  Palette.purple2,
                                ],
                              ),
                              clipLinearGradient: true,
                              widgetIndicator: Container(
                                width: 20,
                                height: 20,
                                margin: const EdgeInsets.only(top: 14, right: 45),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Palette.background,
                                ),
                                child: const Icon(
                                  Icons.schedule_rounded,
                                  color: Palette.purple2,
                                  size: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Deadline: ${meeting.assistanceDeadline!.toDateTimeFormat('d MMMM yyyy')}',
                              style: textTheme.labelSmall!.copyWith(
                                color: Palette.pink1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      FormBuilder(
                        key: formKey,
                        child: IconButton(
                          onPressed: () => updateAssistanceDeadline(context, ref, meeting),
                          icon: const Icon(
                            Icons.edit_calendar_outlined,
                            size: 20,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Palette.violet3,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SectionTitle(text: 'Nilai Tugas Praktikum'),
                  FilledButton(
                    onPressed: () => navigatorKey.currentState!.pushNamed(
                      assistantAssistanceScoreRoute,
                      arguments: null,
                    ),
                    style: FilledButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Input Nilai'),
                  ).fullWidth(),
                  const SectionTitle(text: 'Asistensi'),
                  Consumer(
                    builder: (context, ref, child) {
                      ref.listen(MeetingControlCardsProvider(id), (_, state) {
                        state.whenOrNull(error: context.responseError);
                      });

                      ref.listen(updateAssistanceProvider, (_, state) {
                        state.whenOrNull(
                          loading: () => context.showLoadingDialog(),
                          error: (error, stackTrace) {
                            navigatorKey.currentState!.pop();
                            navigatorKey.currentState!.pop();
                            context.responseError(error, stackTrace);
                          },
                          data: (data) {
                            navigatorKey.currentState!.pop();
                            navigatorKey.currentState!.pop<bool?>(data);
                            ref.invalidate(meetingControlCardsProvider);
                          },
                        );
                      });

                      final cards = ref.watch(MeetingControlCardsProvider(id));

                      return cards.when(
                        loading: () => const LoadingIndicator(),
                        error: (_, __) => const SizedBox(),
                        data: (cards) {
                          if (cards == null) return const SizedBox();

                          if (cards.isEmpty) {
                            return const CustomInformation(
                              title: 'Kartu kontrol kosong',
                              subtitle: 'Anda belum memiliki grup asistensi',
                            );
                          }

                          return Column(
                            children: List<Padding>.generate(
                              cards.length,
                              (index) => Padding(
                                padding: EdgeInsets.only(
                                  bottom: index == cards.length - 1 ? 0 : 10,
                                ),
                                child: UserCard(
                                  user: cards[index].student!,
                                  badgeType: UserBadgeType.text,
                                  badgeText: getBadgeText(
                                    cards[index].firstAssistance?.status ?? false,
                                    cards[index].secondAssistance?.status ?? false,
                                  ),
                                  trailing: Row(
                                    children: [
                                      const SizedBox(width: 8),
                                      AssistanceStatusIcon(
                                        isAttend: cards[index].firstAssistance?.status,
                                        onTap: () => showAssistanceDialog(
                                          context,
                                          number: 1,
                                          meeting: meeting,
                                          card: cards[index],
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      AssistanceStatusIcon(
                                        isAttend: cards[index].secondAssistance?.status,
                                        onTap: () => showAssistanceDialog(
                                          context,
                                          number: 2,
                                          meeting: meeting,
                                          card: cards[index],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void uploadAssignment(
    WidgetRef ref,
    String? path,
    Meeting meeting,
  ) {
    final updatedMeeting = MeetingPost(
      number: meeting.number!,
      lesson: meeting.lesson!,
      date: meeting.date!,
      assistantId: meeting.assistant!.id!,
      coAssistantId: meeting.coAssistant!.id!,
      assignmentPath: path,
    );

    ref.read(meetingActionsProvider.notifier).editMeeting(meeting, updatedMeeting);
  }

  void updateAssistanceDeadline(
    BuildContext context,
    WidgetRef ref,
    Meeting meeting,
  ) async {
    final dueDate = DateTime.fromMillisecondsSinceEpoch(meeting.assistanceDeadline! * 1000);

    final date = await context.showCustomDatePicker(
      initialdate: dueDate,
      firstDate: DateTime.now(),
      lastDate: dueDate.add(const Duration(days: 120)),
      formKey: formKey,
      fieldKey: 'assistanceDeadline',
    );

    if (date != null) {
      final updatedMeeting = MeetingPost(
        number: meeting.number!,
        lesson: meeting.lesson!,
        date: meeting.date!,
        assistantId: meeting.assistant!.id!,
        coAssistantId: meeting.coAssistant!.id!,
        assistanceDeadline: date.secondsSinceEpoch,
      );

      ref.read(meetingActionsProvider.notifier).editMeeting(meeting, updatedMeeting);
    }
  }

  double calculateAssistanceDeadline(
    int meetingDate,
    int deadlineDate,
    int currentDate,
  ) {
    final totalDuration = (meetingDate - deadlineDate).abs();
    final elapsedTime = currentDate - meetingDate;
    final percentage = elapsedTime / totalDuration;

    return percentage.clamp(0.1, 1.0);
  }

  Future<void> showAssistanceDialog(
    BuildContext context, {
    required int number,
    required Meeting meeting,
    required ControlCard card,
  }) async {
    final status = await showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AssistanceDialog(
        number: number,
        dueDate: meeting.assistanceDeadline!,
        card: card,
      ),
    );

    if (!context.mounted) return;

    if (status != null) {
      Timer? timer = Timer(
        const Duration(seconds: 3),
        () => navigatorKey.currentState!.pop(),
      );

      showDialog(
        context: context,
        builder: (context) => AttendanceStatusDialog(
          student: card.student!,
          meeting: meeting,
          attendanceType: AttendanceType.assistance,
          isAttend: status,
        ),
      ).then((_) {
        timer?.cancel();
        timer = null;
      });
    }
  }

  String getBadgeText(
    bool firstAssistance,
    bool secondAssistance,
  ) {
    if (firstAssistance && secondAssistance) return 'Selesai';

    if (firstAssistance || secondAssistance) return '1x asistensi lagi';

    return 'Belum asistensi';
  }
}
