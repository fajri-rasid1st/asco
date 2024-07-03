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
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/features/score/pages/score_input_page.dart';
import 'package:asco/src/presentation/shared/providers/manual_providers/query_provider.dart';
import 'package:asco/src/presentation/shared/widgets/animated_fab.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/attendance_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/attendance_status_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/file_upload_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/search_field.dart';
import 'package:asco/src/presentation/shared/widgets/mentor_list_tile.dart';
import 'package:asco/src/presentation/shared/widgets/section_title.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class AssistantMeetingDetailPage extends StatefulWidget {
  const AssistantMeetingDetailPage({super.key});

  @override
  State<AssistantMeetingDetailPage> createState() => _AssistantMeetingDetailPageState();
}

class _AssistantMeetingDetailPageState extends State<AssistantMeetingDetailPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController fabAnimationController;
  late final ScrollController scrollController;

  @override
  void initState() {
    fabAnimationController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
    )..forward();

    scrollController = ScrollController()..addListener(() {});

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
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Pertemuan 1',
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
                              'Tipe Data dan Attribute',
                              style: textTheme.headlineSmall!.copyWith(
                                color: Palette.background,
                              ),
                            ),
                          ),
                          const MentorListTile(
                            name: 'Muhammad Fajri Rasid',
                            role: 'Pemateri',
                            imageUrl: 'https://placehold.co/100x100/png',
                          ),
                          const MentorListTile(
                            name: 'Wd. Ananda Lesmono',
                            role: 'Pendamping',
                            imageUrl: 'https://placehold.co/100x100/png',
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
                        labelStyle: textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        extensions: const ['pdf', 'doc', 'docx'],
                        onChanged: (value) => debugPrint(value),
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
                            onChanged: (value) => ref.read(queryProvider.notifier).state = value,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            itemBuilder: (context, index) => UserCard(
              badgeType: UserBadgeType.text,
              badgeText: 'Waktu absensi 10:15',
              trailing: const CircleBorderContainer(
                size: 28,
                borderColor: Palette.pink2,
                fillColor: Palette.error,
                child: Icon(
                  Icons.remove_rounded,
                  color: Palette.background,
                  size: 18,
                ),
              ),
              onTap: () => showAttendanceDialog(
                context,
                meetingNumber: 1,
              ),
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: 10,
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
