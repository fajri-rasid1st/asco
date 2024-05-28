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
    final sortingOrders = {'asc': 'Meningkat', 'desc': 'Menurun'};

    return CustomDialog(
      title: 'Urutkan Data',
      onPressedPrimaryAction: () => submit(formKey),
      child: FormBuilder(
        key: formKey,
        child: Column(
          children: [
            CustomDropdownField(
              isSmall: true,
              name: 'sortingBy',
              label: 'Urutkan berdasarkan',
              items: items,
              values: values,
              initialValue: values.first,
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            CustomDropdownField(
              isSmall: true,
              name: 'sortingOrder',
              label: 'Urutkan Secara',
              items: sortingOrders.values.toList(),
              values: sortingOrders.keys.toList(),
              initialValue: sortingOrders.keys.first,
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    );
  }

  void submit(GlobalKey<FormBuilderState> formKey) {
    if (onSubmitted != null) {
      FocusManager.instance.primaryFocus?.unfocus();

      if (formKey.currentState!.saveAndValidate()) {
        onSubmitted!(formKey.currentState!.value);
      }
    }
  }
}
