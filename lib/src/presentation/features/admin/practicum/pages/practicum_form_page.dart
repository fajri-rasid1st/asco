// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/enums/user_badge_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/classrooms/classroom.dart';
import 'package:asco/src/data/models/classrooms/classroom_post.dart';
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

class PracticumFirstFormPage extends ConsumerWidget {
  final PracticumFormPageArgs? args;

  const PracticumFirstFormPage({super.key, required this.args});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(practicumActionsProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data.message != null) {
            navigatorKey.currentState!.pushReplacementNamed(
              practicumSecondFormRoute,
              arguments: PracticumFormPageArgs(
                id: data.message?.split(':').last,
                practicum: args?.practicum,
              ),
            );
          }
        },
      );
    });

    return Scaffold(
      appBar: CustomAppBar(
        title: '${args?.practicum != null ? 'Edit' : 'Tambah'} Praktikum (1/2)',
        action: IconButton(
          onPressed: () => createOrEditPracticum(context, ref),
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
                initialValue: args?.practicum?.course,
                textCapitalization: TextCapitalization.words,
                validators: [
                  FormBuilderValidators.required(
                    errorText: 'Field wajib diisi',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FileUploadField(
                name: 'badge',
                label: 'Badge',
                extensions: const [],
                initialValue: args?.practicum?.badgePath,
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
              FileUploadField(
                name: 'courseContract',
                label: 'Kontrak Kuliah',
                extensions: const ['pdf', 'doc', 'docx'],
                initialValue: args?.practicum?.courseContractPath,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createOrEditPracticum(BuildContext context, WidgetRef ref) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!formKey.currentState!.saveAndValidate()) {
      context.showSnackBar(
        title: 'Terjadi Kesalahan',
        message: 'Matakuliah & badge wajib diisi.',
        type: SnackBarType.error,
      );

      return;
    }

    final practicum = PracticumPost.fromJson(formKey.currentState!.value);

    if (args?.practicum != null) {
      ref.read(practicumActionsProvider.notifier).editPracticum(args!.practicum!, practicum);
    } else {
      ref.read(practicumActionsProvider.notifier).createPracticum(practicum);
    }
  }
}

class PracticumSecondFormPage extends ConsumerStatefulWidget {
  final PracticumFormPageArgs args;

  const PracticumSecondFormPage({super.key, required this.args});

  @override
  ConsumerState<PracticumSecondFormPage> createState() => _PracticumSecondFormPageState();
}

class _PracticumSecondFormPageState extends ConsumerState<PracticumSecondFormPage> {
  List<Classroom> classrooms = [];
  List<Profile> assistants = [];

  late int currentClassroomsLength;
  late int currentAssistantsLength;

  @override
  void initState() {
    classrooms = [...?widget.args.practicum?.classrooms];
    currentClassroomsLength = classrooms.length;

    assistants = [...?widget.args.practicum?.assistants];
    currentAssistantsLength = assistants.length;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(practicumActionsProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data.message != null) navigatorKey.currentState!.pop();
        },
      );
    });

    return Scaffold(
      appBar: CustomAppBar(
        title: '${widget.args.practicum != null ? 'Edit' : 'Tambah'} Praktikum (2/2)',
        action: IconButton(
          onPressed: addClassroomsAndAssistants,
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
              onPressedActionButton: () async {
                final result = await showDialog<Classroom>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => ClassroomFormDialog(
                    lastClassroomName: classrooms.isEmpty ? null : classrooms.last.name,
                  ),
                );

                if (result != null) setState(() => classrooms.add(result));
              },
            ),
            ...List<Padding>.generate(
              classrooms.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == classrooms.length - 1 ? 0 : 10,
                ),
                child: ClassroomCard(
                  classroom: classrooms[index],
                  showActionButtons: true,
                  onUpdate: () async {
                    final result = await showDialog<Classroom>(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => ClassroomFormDialog(classroom: classrooms[index]),
                    );

                    if (result != null) setState(() => classrooms[index] = result);
                  },
                  onDelete: index < currentClassroomsLength
                      ? null
                      : () => setState(() => classrooms.remove(classrooms[index])),
                ),
              ),
            ),
            SectionHeader(
              title: 'Asisten',
              padding: const EdgeInsets.fromLTRB(4, 16, 0, 8),
              showDivider: true,
              showActionButton: true,
              onPressedActionButton: () async {
                final removedUsers = [...assistants];

                final result = await navigatorKey.currentState!.pushNamed(
                  selectUsersRoute,
                  arguments: SelectUsersPageArgs(
                    title: 'Pilih Asisten',
                    role: 'ASSISTANT',
                    removedUsers: removedUsers,
                  ),
                );

                if (result != null) setState(() => assistants.addAll(result as List<Profile>));
              },
            ),
            ...List<Padding>.generate(
              assistants.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == assistants.length - 1 ? 0 : 10,
                ),
                child: UserCard(
                  user: assistants[index],
                  badgeType: UserBadgeType.text,
                  showDeleteButton: true,
                  onPressedDeleteButton: index < currentAssistantsLength
                      ? null
                      : () => setState(() => assistants.remove(assistants[index])),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addClassroomsAndAssistants() {
    final classroomPosts = List<ClassroomPost>.generate(
      classrooms.length,
      (index) => ClassroomPost.fromJson(classrooms[index].toJson()),
    );

    ref.read(practicumActionsProvider.notifier).createClassroomsAndAssistants(
          widget.args.id!,
          classrooms: classroomPosts,
          assistants: assistants,
        );
  }
}

class PracticumFormPageArgs {
  final String? id;
  final Practicum? practicum;

  const PracticumFormPageArgs({
    this.id,
    this.practicum,
  });
}
