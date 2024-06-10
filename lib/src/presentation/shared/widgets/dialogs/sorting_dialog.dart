// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';

// Project imports:
import 'package:asco/src/presentation/shared/widgets/dialogs/custom_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_dropdown_field.dart';

class SortingDialog extends StatelessWidget {
  final List<String> items;
  final List<String> values;
  final void Function(Map<String, dynamic> value)? onSubmitted;

  const SortingDialog({
    super.key,
    required this.items,
    required this.values,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    final orders = {'Meningkat': 'asc', 'Menurun': 'desc'};

    return CustomDialog(
      title: 'Urutkan Data',
      onPressedPrimaryAction: () => submit(formKey),
      child: FormBuilder(
        key: formKey,
        child: Column(
          children: [
            CustomDropdownField(
              name: 'sortingBy',
              label: 'Urutkan Berdasarkan',
              isSmall: true,
              items: items,
              values: values,
              initialValue: values.first,
            ),
            const SizedBox(height: 12),
            CustomDropdownField(
              name: 'sortingOrder',
              label: 'Urutkan Secara',
              isSmall: true,
              items: orders.keys.toList(),
              values: orders.values.toList(),
              initialValue: orders.values.first,
            ),
          ],
        ),
      ),
    );
  }

  void submit(GlobalKey<FormBuilderState> formKey) {
    if (onSubmitted != null) {
      FocusManager.instance.primaryFocus?.unfocus();

      formKey.currentState!.save();

      onSubmitted!(formKey.currentState!.value);
    }
  }
}
