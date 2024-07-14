// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';

// Project imports:
import 'package:asco/core/enums/action_type.dart';
import 'package:asco/core/enums/user_badge_type.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/pages/select_users_page.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_dropdown_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';

class AssistanceGroupFormPage extends StatelessWidget {
  final AssistanceGroupFormPageArgs args;

  const AssistanceGroupFormPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    List<int> selectedStudents = [];

    const assistants = [
      'Fajri - 2019',
      'Ikhsan - 2019',
      'Richard - 2019',
      'Ananda - 2021',
      'Erwin - 2021',
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: '${args.title} Grup Asistensi',
        action: IconButton(
          onPressed: () => createOrEditAssistanceGroup(selectedStudents),
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
        child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
              const CustomTextField(
                name: 'number',
                label: 'Grup (auto-generated)',
                enabled: false,
                initialValue: '10',
              ),
              const SizedBox(height: 12),
              CustomDropdownField(
                name: 'assistantId',
                label: 'Asisten',
                items: assistants,
                values: assistants,
                initialValue: assistants.first,
              ),
              SectionHeader(
                title: 'Peserta',
                padding: const EdgeInsets.fromLTRB(4, 16, 0, 8),
                showDivider: true,
                showActionButton: true,
                onPressedActionButton: () async {
                  final result = await navigatorKey.currentState!.pushNamed(
                    selectUsersRoute,
                    arguments: const SelectUsersPageArgs(
                      title: 'Pilih Peserta Grup 10',
                      role: 'Peserta',
                      selectedUsers: [],
                      removedUsers: [],
                    ),
                  );

                  if (result != null) selectedStudents = result as List<int>;
                },
              ),
              ...List<Padding>.generate(
                10,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    bottom: index == 9 ? 0 : 10,
                  ),
                  child: UserCard(
                    user: CredentialSaver.credential!,
                    badgeType: UserBadgeType.text,
                    showDeleteButton: true,
                    onPressedDeleteButton: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createOrEditAssistanceGroup(List<int> selectedStudents) {
    formKey.currentState!.save();

    debugPrint(formKey.currentState!.value.toString());
    debugPrint(selectedStudents.toString());
  }
}

class AssistanceGroupFormPageArgs {
  final String title;
  final ActionType action;

  const AssistanceGroupFormPageArgs({
    required this.title,
    required this.action,
  });
}
