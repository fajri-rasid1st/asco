// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';

class MarkdownField extends StatefulWidget {
  final String name;
  final String label;
  final String? initialValue;
  final String? hintText;
  final int maxLines;
  final List<MarkdownType> actions;
  final ValueChanged<String> onChanged;

  const MarkdownField({
    super.key,
    required this.name,
    required this.label,
    this.initialValue,
    this.hintText,
    this.maxLines = 8,
    this.actions = MarkdownType.values,
    required this.onChanged,
  });

  @override
  State<MarkdownField> createState() => _MarkdownFieldState();
}

class _MarkdownFieldState extends State<MarkdownField> {
  late final TextEditingController controller;
  late final ValueNotifier<bool> isFocus;
  late TextSelection textSelection;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.initialValue);
    isFocus = ValueNotifier(false);
    textSelection = const TextSelection(baseOffset: 0, extentOffset: 0);

    controller.addListener(() {
      if (controller.selection.baseOffset != -1) {
        textSelection = controller.selection;
      }

      widget.onChanged(controller.text);
    });
  }

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
    isFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: textTheme.titleSmall!.copyWith(
            color: Palette.purple2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        ValueListenableBuilder(
          valueListenable: isFocus,
          builder: (context, isFocus, child) {
            final borderSide = BorderSide(
              color: isFocus ? Palette.purple2 : Palette.border,
            );

            final textFieldBorder = OutlineInputBorder(
              borderSide: borderSide,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            );

            return Column(
              children: [
                Focus(
                  onFocusChange: (value) => this.isFocus.value = value,
                  child: FormBuilderTextField(
                    controller: controller,
                    name: widget.name,
                    maxLines: widget.maxLines,
                    textInputAction: TextInputAction.newline,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      filled: true,
                      fillColor: Palette.background,
                      contentPadding: const EdgeInsets.all(16),
                      enabledBorder: textFieldBorder,
                      focusedBorder: textFieldBorder,
                      errorBorder: textFieldBorder,
                      focusedErrorBorder: textFieldBorder,
                    ),
                    validator: FormBuilderValidators.required(errorText: ''),
                  ),
                ),
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: borderSide,
                      left: borderSide,
                      right: borderSide,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                  child: Material(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List<Widget>.generate(
                        widget.actions.length,
                        (index) {
                          final type = widget.actions[index];

                          if (type == MarkdownType.title) {
                            return Row(
                              children: [
                                for (int i = 1; i <= 6; i++)
                                  InkWell(
                                    key: Key('H${i}_button'),
                                    onTap: () => onTap(
                                      MarkdownType.title,
                                      titleSize: i,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'H$i',
                                        style: TextStyle(
                                          fontSize: (18 - i).toDouble(),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }

                          return InkWell(
                            key: Key(type.key),
                            onTap: () => onTap(type),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                type.icon,
                                color: Palette.primaryText,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void onTap(MarkdownType type, {int titleSize = 1}) {
    final basePosition = textSelection.baseOffset;
    final noTextSelected = (textSelection.baseOffset - textSelection.extentOffset) == 0;

    final result = FormatMarkdown.convertToMarkdown(
      type,
      controller.text,
      textSelection.baseOffset,
      textSelection.extentOffset,
      titleSize: titleSize,
    );

    controller.value = controller.value.copyWith(
      text: result.data,
      selection: TextSelection.collapsed(
        offset: basePosition + result.cursorIndex,
      ),
    );

    if (noTextSelected) {
      controller.selection = TextSelection.collapsed(
        offset: controller.selection.end - result.replaceCursorIndex,
      );

      FocusScope.of(context).requestFocus();
    }
  }
}
