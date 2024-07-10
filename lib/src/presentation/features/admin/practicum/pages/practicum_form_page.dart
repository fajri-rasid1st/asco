// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:after_layout/after_layout.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:path/path.dart' as p;

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/enums/user_badge_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/services/file_service.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/data/models/practicums/practicum_post.dart';
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/features/admin/practicum/providers/practicum_actions_provider.dart';
import 'package:asco/src/presentation/shared/pages/select_users_page.dart';
import 'package:asco/src/presentation/shared/widgets/cards/classroom_card.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/classroom_form_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/file_upload_field.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';

final badgePathProvider = StateProvider.autoDispose<String?>((ref) => null);
final courseContractPathProvider = StateProvider.autoDispose<String?>((ref) => null);

class PracticumFirstFormPage extends ConsumerStatefulWidget {
  final PracticumFormPageArgs args;

  const PracticumFirstFormPage({super.key, required this.args});

  @override
  ConsumerState<PracticumFirstFormPage> createState() => _PracticumFirstFormPageState();
}

class _PracticumFirstFormPageState extends ConsumerState<PracticumFirstFormPage>
    with AfterLayoutMixin {
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    if (widget.args.practicum != null) {
      context.showLoadingDialog();

      ref.read(badgePathProvider.notifier).state =
          await FileService.downloadFile(widget.args.practicum!.badgePath!);

      if (widget.args.practicum!.courseContractPath != null) {
        ref.read(courseContractPathProvider.notifier).state =
            await FileService.downloadFile(widget.args.practicum!.courseContractPath!);
      }

      navigatorKey.currentState!.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final badgePath = ref.watch(badgePathProvider);
    final courseContractPath = ref.watch(courseContractPathProvider);

    if (badgePath != null) {
      formKey.currentState?.fields['badgePath']!.didChange(badgePath);
    }

    if (courseContractPath != null) {
      formKey.currentState?.fields['courseContractPath']!.didChange(courseContractPath);
    }

    ref.listen(practicumActionsProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data.message != null) {
            navigatorKey.currentState!.pushReplacementNamed(
              practicumSecondFormRoute,
              arguments: PracticumFormPageArgs(
                title: widget.args.title,
                practicum: widget.args.practicum,
                id: data.message?.split(':').last,
              ),
            );
          }
        },
      );
    });

    return Scaffold(
      appBar: CustomAppBar(
        title: '${widget.args.title} Praktikum (1/2)',
        action: IconButton(
          onPressed: createOrEditPracticum,
          icon: const Icon(Icons.chevron_right_rounded),
          iconSize: 30,
          tooltip: 'Selanjutnya',
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
              CustomTextField(
                name: 'course',
                label: 'Mata kuliah',
                hintText: 'Masukkan nama mata kuliah',
                initialValue: widget.args.practicum?.course,
                textCapitalization: TextCapitalization.words,
                validators: [
                  FormBuilderValidators.required(
                    errorText: 'Field wajib diisi',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FileUploadField(
                name: 'badgePath',
                label: 'Badge',
                extensions: const [],
                validator: FormBuilderValidators.required(),
                onPressedFilePickerButton: () async {
                  final result = await navigatorKey.currentState!.pushNamed(
                    practicumBadgeGeneratorRoute,
                  );

                  if (result != null && context.mounted) {
                    context.showSnackBar(
                      title: 'Berhasil',
                      message: 'File badge berhasil dibuat dan dimasukkan.',
                    );
                  }

                  return result as String?;
                },
              ),
              const SizedBox(height: 12),
              const FileUploadField(
                name: 'courseContractPath',
                label: 'Kontrak Kuliah',
                extensions: ['pdf', 'doc', 'docx'],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createOrEditPracticum() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final String badgeValue = formKey.currentState!.value['badgePath'];
      final String? courseContractValue = formKey.currentState!.value['courseContractPath'];

      if (widget.args.practicum != null) {
        final badgeArgsValue = widget.args.practicum!.badgePath!;
        final courseContractArgsValue = widget.args.practicum!.courseContractPath;

        final isBadgeUpdated = p.basename(badgeArgsValue) != p.basename(badgeValue);
        final isCourseContractUpdated = courseContractValue != null &&
            p.basename(courseContractArgsValue ?? '') != p.basename(courseContractValue);

        final badge =
            isBadgeUpdated ? await FileService.uploadFile(badgeValue) : p.basename(badgeArgsValue);
        final courseContract = isCourseContractUpdated
            ? await FileService.uploadFile(courseContractValue)
            : courseContractArgsValue != null
                ? p.basename(courseContractArgsValue)
                : null;

        if (badge != null) {
          final practicum = PracticumPost(
            course: formKey.currentState!.value['course'],
            badgePath: badge,
            courseContractPath: courseContract,
          );

          ref
              .read(practicumActionsProvider.notifier)
              .editPracticum(widget.args.practicum!.id!, practicum);
        }
      } else {
        final badge = await FileService.uploadFile(badgeValue);
        final courseContract =
            courseContractValue != null ? await FileService.uploadFile(courseContractValue) : null;

        if (badge != null) {
          final practicum = PracticumPost(
            course: formKey.currentState!.value['course'],
            badgePath: badge,
            courseContractPath: courseContract,
          );

          ref.read(practicumActionsProvider.notifier).createPracticum(practicum);
        }
      }
    } else {
      context.showSnackBar(
        title: 'Terjadi Kesalahan',
        message: 'Matakuliah & badge wajib diisi',
        type: SnackBarType.error,
      );
    }
  }
}

class PracticumSecondFormPage extends StatefulWidget {
  final PracticumFormPageArgs args;

  const PracticumSecondFormPage({super.key, required this.args});

  @override
  State<PracticumSecondFormPage> createState() => _PracticumSecondFormPageState();
}

class _PracticumSecondFormPageState extends State<PracticumSecondFormPage> {
  late List<Profile> assistants;

  @override
  void initState() {
    assistants = [...widget.args.practicum?.assistants ?? []];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '${widget.args.title} Praktikum (2/2)',
        action: IconButton(
          onPressed: () => updatePracticum(assistants),
          icon: const Icon(Icons.check_rounded),
          tooltip: 'Submit',
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
            SectionHeader(
              title: 'Kelas',
              padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
              showDivider: true,
              showActionButton: true,
              onPressedActionButton: () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const ClassroomFormDialog(action: 'Tambah'),
              ),
            ),
            ...List<Padding>.generate(
              4,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == 3 ? 0 : 10,
                ),
                child: const ClassroomCard(showActionButtons: true),
              ),
            ),
            SectionHeader(
              title: 'Asisten',
              padding: const EdgeInsets.fromLTRB(4, 16, 0, 8),
              showDivider: true,
              showActionButton: true,
              onPressedActionButton: () async {
                final result = await navigatorKey.currentState!.pushNamed(
                  selectUsersRoute,
                  arguments: SelectUsersPageArgs(
                    title: 'Pilih Asisten',
                    role: 'ASSISTANT',
                    selectedUsers: assistants,
                  ),
                );

                if (result != null) setState(() => assistants = result as List<Profile>);
              },
            ),
            ...List<Padding>.generate(
              assistants.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == 3 ? 0 : 10,
                ),
                child: UserCard(
                  user: assistants[index],
                  badgeType: UserBadgeType.text,
                  showDeleteButton: true,
                  onPressedDeleteButton: () => setState(() => assistants.remove(assistants[index])),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updatePracticum(List<Profile> assistants) {
    debugPrint(assistants.toString());
  }
}

class PracticumFormPageArgs {
  final String title;
  final Practicum? practicum;
  final String? id;

  const PracticumFormPageArgs({
    required this.title,
    this.practicum,
    this.id,
  });
}
