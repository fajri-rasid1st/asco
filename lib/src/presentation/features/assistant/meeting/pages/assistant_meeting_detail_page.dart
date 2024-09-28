// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/attendance_type.dart';
import 'package:asco/core/enums/score_type.dart';
import 'package:asco/core/enums/user_badge_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/number_extension.dart';
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/classrooms/classroom.dart';
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/meetings/meeting_post.dart';
import 'package:asco/src/presentation/features/admin/meeting/providers/meeting_actions_provider.dart';
import 'package:asco/src/presentation/features/assistant/meeting/providers/insert_meeting_attendances_provider.dart';
import 'package:asco/src/presentation/providers/manual_providers/query_provider.dart';
import 'package:asco/src/presentation/shared/features/meeting/providers/meeting_attendances_provider.dart';
import 'package:asco/src/presentation/shared/features/meeting/providers/meeting_detail_provider.dart';
import 'package:asco/src/presentation/shared/features/score/pages/score_input_page.dart';
import 'package:asco/src/presentation/shared/widgets/animated_fab.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/attendance_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/attendance_status_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/file_upload_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/search_field.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';
import 'package:asco/src/presentation/shared/widgets/mentor_list_tile.dart';
import 'package:asco/src/presentation/shared/widgets/section_title.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class AssistantMeetingDetailPage extends ConsumerStatefulWidget {
  final AssistantMeetingDetailPageArgs args;

  const AssistantMeetingDetailPage({super.key, required this.args});

  @override
  ConsumerState<AssistantMeetingDetailPage> createState() => _AssistantMeetingDetailPageState();
}

class _AssistantMeetingDetailPageState extends ConsumerState<AssistantMeetingDetailPage>
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // If meeting already begin
      if (widget.args.meeting.date! < DateTime.now().millisecondsSinceEpoch ~/ 1000) {
        // If attendances still empty
        if (await isAttendancesEmpty(ref)) {
          // Insert attendances
          await insertAttendances(ref);
        }
      }
    });
  }

  @override
  void dispose() {
    fabAnimationController.dispose();
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meeting = ref.watch(MeetingDetailProvider(widget.args.meeting.id!));

    ref.listen(MeetingDetailProvider(widget.args.meeting.id!), (_, state) {
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
            ref.invalidate(queryProvider);

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
          body: NotificationListener<UserScrollNotification>(
            onNotification: (notification) => FunctionHelper.handleFabVisibilityOnScroll(
              fabAnimationController,
              notification,
            ),
            child: NestedScrollView(
              controller: scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Container(
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                                child: Text(
                                  '${meeting.lesson}',
                                  style: textTheme.headlineSmall!.copyWith(
                                    color: Palette.background,
                                  ),
                                ),
                              ),
                              MentorListTile(
                                name: '${meeting.assistant?.fullname}',
                                role: 'Pemateri',
                                imageUrl: meeting.assistant?.profilePicturePath,
                              ),
                              MentorListTile(
                                name: '${meeting.coAssistant?.fullname}',
                                role: 'Pendamping',
                                imageUrl: meeting.coAssistant?.profilePicturePath,
                              ),
                              const SizedBox(height: 16),
                            ],
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
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      color: Palette.scaffoldBackground,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FileUploadField(
                            name: 'modulePath',
                            label: 'Modul',
                            extensions: const ['pdf', 'doc', 'docx'],
                            withDeleteButton: false,
                            initialValue: meeting.modulePath,
                            onChanged: (path) => uploadModule(path, meeting),
                            labelStyle: textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const SectionTitle(text: 'Respon & Quiz'),
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton(
                                  onPressed: () => navigatorKey.currentState!.pushNamed(
                                    scoreInputRoute,
                                    arguments: const ScoreInputPageArgs(
                                      title: 'Respon',
                                      scoreType: ScoreType.response,
                                      practicumName: 'Pemrograman Mobile A',
                                      meetingName: '1. Tipe Data & Attribute',
                                    ),
                                  ),
                                  style: FilledButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: Palette.secondary,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text('Nilai Respon'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: FilledButton(
                                  onPressed: () => navigatorKey.currentState!.pushNamed(
                                    scoreInputRoute,
                                    arguments: const ScoreInputPageArgs(
                                      title: 'Quiz',
                                      scoreType: ScoreType.quiz,
                                      practicumName: 'Pemrograman Mobile A',
                                      meetingName: '1. Tipe Data & Attribute',
                                    ),
                                  ),
                                  style: FilledButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text('Nilai Quiz'),
                                ),
                              ),
                            ],
                          ),
                          const SectionTitle(text: 'Absensi'),
                          Consumer(
                            builder: (context, ref, child) {
                              return SearchField(
                                text: ref.watch(queryProvider),
                                hintText: 'Cari nama atau username',
                                onChanged: (query) => searchStudents(query),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: Consumer(
                builder: (context, ref, child) {
                  final query = ref.watch(queryProvider);

                  final attendances = ref.watch(
                    MeetingAttendancesProvider(
                      widget.args.meeting.id!,
                      classroom: widget.args.classroom.id!,
                      query: query,
                    ),
                  );

                  ref.listen(
                    MeetingAttendancesProvider(
                      widget.args.meeting.id!,
                      classroom: widget.args.classroom.id!,
                      query: query,
                    ),
                    (_, state) => state.whenOrNull(error: context.responseError),
                  );

                  return attendances.when(
                    loading: () => const LoadingIndicator(),
                    error: (_, __) => const SizedBox(),
                    data: (attendances) {
                      if (attendances == null) return const SizedBox();

                      if (attendances.isEmpty) {
                        return const CustomInformation(
                          title: 'Data absensi kosong',
                          subtitle: 'Belum ada data absensi pada pertemuan ini.',
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        itemBuilder: (context, index) {
                          final attendance = attendances[index];
                          final isAttend = attendance.status == 'ATTEND';

                          return UserCard(
                            user: attendance.student!,
                            badgeType: UserBadgeType.text,
                            badgeText: isAttend
                                ? 'Waktu absensi ${attendance.time?.to24TimeFormat()}'
                                : attendance.note != null && attendance.note!.isNotEmpty
                                    ? attendance.note!
                                    : 'Tidak ada keterangan',
                            trailing: CircleBorderContainer(
                              size: 28,
                              borderColor: isAttend ? Palette.purple2 : Palette.pink2,
                              fillColor: isAttend ? Palette.success : Palette.error,
                              child: Icon(
                                isAttend ? Icons.check_rounded : Icons.remove_rounded,
                                color: Palette.background,
                                size: 18,
                              ),
                            ),
                            onTap: () => showAttendanceDialog(
                              context,
                              meetingNumber: 1,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemCount: attendances.length,
                      );
                    },
                  );
                },
              ),
            ),
          ),
          floatingActionButton: AnimatedFloatingActionButton(
            animationController: fabAnimationController,
            onPressed: () => navigatorKey.currentState!.pushNamed(assistantMeetingScannerRoute),
            tooltip: 'Scan QR',
            child: const Icon(Icons.qr_code_scanner_outlined),
          ),
        );
      },
    );
  }

  void uploadModule(String? path, Meeting meeting) {
    final updatedMeeting = MeetingPost(
      number: meeting.number!,
      lesson: meeting.lesson!,
      date: meeting.date!,
      assistantId: meeting.assistant!.id!,
      coAssistantId: meeting.coAssistant!.id!,
      modulePath: path,
      assignmentPath: meeting.assignmentPath,
    );

    ref.read(meetingActionsProvider.notifier).editMeeting(meeting, updatedMeeting);
  }

  void searchStudents(String query) {
    ref.read(queryProvider.notifier).state = query;
  }

  Future<bool> isAttendancesEmpty(WidgetRef ref) async {
    try {
      final attendances = await ref.watch(
        MeetingAttendancesProvider(
          widget.args.meeting.id!,
          classroom: widget.args.classroom.id!,
        ).future,
      );

      if (attendances == null || attendances.isEmpty) return true;

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> insertAttendances(WidgetRef ref) async {
    try {
      await ref.watch(InsertMeetingAttendancesProvider(widget.args.meeting.id!).future);
    } catch (e) {
      return;
    }
  }

  Future<void> showAttendanceDialog(
    BuildContext context, {
    required int meetingNumber,
  }) async {
    final isAttend = await showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AttendanceDialog(meetingNumber: meetingNumber),
    );

    if (!context.mounted) return;

    if (isAttend != null) {
      Timer? timer = Timer(
        const Duration(seconds: 3),
        () => navigatorKey.currentState!.pop(),
      );

      showDialog(
        context: context,
        builder: (context) => AttendanceStatusDialog(
          attendanceType: AttendanceType.meeting,
          isAttend: isAttend,
        ),
      ).then((_) {
        timer?.cancel();
        timer = null;
      });
    }
  }
}

class AssistantMeetingDetailPageArgs {
  final Meeting meeting;
  final Classroom classroom;

  const AssistantMeetingDetailPageArgs({
    required this.meeting,
    required this.classroom,
  });
}
