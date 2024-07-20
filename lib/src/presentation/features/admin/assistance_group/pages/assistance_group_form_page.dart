// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/enums/user_badge_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/assistance_groups/assistance_group.dart';
import 'package:asco/src/data/models/assistance_groups/assistance_group_post.dart';
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/features/admin/assistance_group/providers/assistance_group_actions_provider.dart';
import 'package:asco/src/presentation/features/admin/user/providers/users_provider.dart';
import 'package:asco/src/presentation/shared/pages/select_users_page.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_dropdown_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';

class AssistanceGroupFormPage extends StatefulWidget {
  final AssistanceGroupFormPageArgs args;

  const AssistanceGroupFormPage({super.key, required this.args});

  @override
  State<AssistanceGroupFormPage> createState() => _AssistanceGroupFormPageState();
}

class _AssistanceGroupFormPageState extends State<AssistanceGroupFormPage> {
  List<Profile> students = [];
  late List<String> currentStudents;

  @override
  void initState() {
    students = [...?widget.args.group?.students];
    currentStudents = [...students.map((e) => e.username!)];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '${widget.args.group != null ? 'Edit' : 'Tambah'} Grup Asistensi',
        action: Consumer(
          builder: (context, ref, child) {
            return IconButton(
              onPressed: () => createOrEditAssistanceGroup(ref, students),
              icon: const Icon(Icons.check_rounded),
              tooltip: 'Submit',
              style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: const CircleBorder(),
              ),
            );
          },
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final assistants = ref.watch(
            UsersProvider(
              role: 'ASSISTANT',
              practicum: widget.args.practicumId,
            ),
          );

          ref.listen(
            UsersProvider(
              role: 'ASSISTANT',
              practicum: widget.args.practicumId,
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

          return assistants.when(
            loading: () => const LoadingIndicator(),
            error: (_, __) => const SizedBox(),
            data: (assistants) {
              if (assistants == null) return const SizedBox();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: FormBuilder(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        name: 'number',
                        label: 'Grup (auto-generated)',
                        enabled: false,
                        initialValue: '${widget.args.group?.number ?? widget.args.groupNumber}',
                      ),
                      const SizedBox(height: 12),
                      CustomDropdownField(
                        name: 'assistantId',
                        label: 'Asisten',
                        items: assistants.map((e) => '${e.nickname} (${e.classOf})').toList(),
                        values: assistants.map((e) => e.id).toList(),
                        initialValue: widget.args.group?.assistant?.id ??
                            (assistants.isNotEmpty ? assistants.first.id : null),
                      ),
                      SectionHeader(
                        title: 'Peserta',
                        padding: const EdgeInsets.fromLTRB(4, 16, 0, 8),
                        showDivider: true,
                        showActionButton: true,
                        onPressedActionButton: () async {
                          final number = formKey.currentState!.instantValue['number'];
                          final removedUsers = [...students];

                          final result = await navigatorKey.currentState!.pushNamed(
                            selectUsersRoute,
                            arguments: SelectUsersPageArgs(
                              title: 'Pilih Peserta Grup $number',
                              role: 'STUDENT',
                              selectedUsers: [],
                              removedUsers: removedUsers,
                            ),
                          );

                          if (result != null) {
                            setState(() => students.addAll(result as List<Profile>));
                          }
                        },
                      ),
                      ...List<Padding>.generate(
                        students.length,
                        (index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: index == students.length - 1 ? 0 : 10,
                          ),
                          child: UserCard(
                            user: students[index],
                            badgeType: UserBadgeType.text,
                            showDeleteButton: true,
                            onPressedDeleteButton:
                                currentStudents.contains(students[index].username)
                                    ? null
                                    : () => setState(() => students.remove(students[index])),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void createOrEditAssistanceGroup(WidgetRef ref, List<Profile> students) {
    formKey.currentState!.save();

    final value = formKey.currentState!.value;

    final group = AssistanceGroupPost(
      number: int.parse(value['number']),
      assistantId: value['assistantId'],
      studentIds: students.map((e) => e.id!).toList(),
    );

    if (widget.args.group != null) {
      ref
          .read(assistanceGroupActionsProvider.notifier)
          .editAssistanceGroup(widget.args.group!, group);
    } else {
      ref
          .read(assistanceGroupActionsProvider.notifier)
          .createAssistanceGroup(widget.args.practicumId, assistanceGroup: group);
    }
  }
}

class AssistanceGroupFormPageArgs {
  final String practicumId;
  final int? groupNumber;
  final AssistanceGroup? group;

  const AssistanceGroupFormPageArgs({
    required this.practicumId,
    this.groupNumber,
    this.group,
  });
}
