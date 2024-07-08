// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:asco/core/enums/extra_type.dart';
import 'package:asco/core/extensions/button_extension.dart';
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/themes/light_theme.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/providers/manual_providers/field_value_provider.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/markdown_field.dart';
import 'package:asco/src/presentation/shared/widgets/practicum_badge_image.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

final showMarkdownReviewProvider = StateProvider.autoDispose<bool>((ref) => false);

class EditExtraPage extends ConsumerWidget {
  final EditExtraPageArgs args;

  const EditExtraPage({super.key, required this.args});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(
        title: args.title,
        leading: IconButton(
          onPressed: () => navigatorKey.currentState!.pop(),
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Batalkan',
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
          ),
        ),
        action: IconButton(
          onPressed: updateExtra,
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
              if (args.type == ExtraType.labExam)
                Consumer(
                  builder: (context, ref, child) {
                    final value = ref.watch(fieldValueProvider);

                    if (ref.watch(showMarkdownReviewProvider)) {
                      return Column(
                        children: [
                          child!,
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            height: AppSize.getAppWidth(context) - 100,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Palette.background,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Scrollbar(
                              radius: const Radius.circular(8),
                              child: SingleChildScrollView(
                                child: MarkdownBody(
                                  data: value,
                                  selectable: true,
                                  styleSheet: MarkdownStyleSheet.fromTheme(lightTheme),
                                  onTapLink: (text, href, title) {
                                    if (href != null) FunctionHelper.openUrl(href);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return MarkdownField(
                      name: args.fieldName,
                      initialValue: value,
                      hintText: 'Masukkan ${args.fieldLabel.toLowerCase()}',
                      onChanged: (value) => ref.read(fieldValueProvider.notifier).state = value,
                    );
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Palette.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        SvgAsset(
                          AssetPath.getVector('bg_attribute_3.svg'),
                          height: 44,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          child: Row(
                            children: [
                              const PracticumBadgeImage(
                                badgeUrl: 'https://placehold.co/138x150/png',
                                width: 48,
                                height: 52,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Informasi Ujian Lab',
                                      style: textTheme.bodySmall!.copyWith(
                                        color: Palette.secondaryText,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Pemrograman Mobile',
                                      style: textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                CustomTextField(
                  name: args.fieldName,
                  label: args.fieldLabel,
                  initialValue: 'https://github.com/fajri-rasid1st',
                  hintText: 'Masukkan ${args.fieldLabel.toLowerCase()}',
                  textInputType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.none,
                  validators: [
                    FormBuilderValidators.url(
                      errorText: 'Field harus berupa URL',
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: args.type == ExtraType.labExam
                    ? () => ref.read(showMarkdownReviewProvider.notifier).update(
                          (state) => !state,
                        )
                    : () => FunctionHelper.openUrl(
                          formKey.currentState!.instantValue[args.fieldName],
                        ),
                style: FilledButton.styleFrom(
                  backgroundColor: Palette.secondary,
                ),
                child: Consumer(
                  builder: (context, ref, child) {
                    return Text(
                      args.type == ExtraType.labExam
                          ? ref.watch(showMarkdownReviewProvider)
                              ? 'Kembali ke Editor'
                              : 'Lihat Preview'
                          : 'Buka Link',
                    );
                  },
                ),
              ).fullWidth(),
            ],
          ),
        ),
      ),
    );
  }

  void updateExtra() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      debugPrint(formKey.currentState!.value.toString());
    }
  }
}

class EditExtraPageArgs {
  final ExtraType type;
  final String title;
  final String fieldName;
  final String fieldLabel;

  const EditExtraPageArgs({
    required this.type,
    required this.title,
    required this.fieldName,
    required this.fieldLabel,
  });
}
