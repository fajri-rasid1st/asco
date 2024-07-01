// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// Project imports:
import 'package:asco/core/enums/score_type.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/providers/manual_providers/field_value_provider.dart';
import 'package:asco/src/presentation/shared/providers/manual_providers/query_provider.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/search_field.dart';

class ScoreInputPage extends StatelessWidget {
  final ScoreInputPageArgs args;

  const ScoreInputPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Nilai ${args.title}',
      ),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              automaticallyImplyLeading: false,
              backgroundColor: Palette.background,
              surfaceTintColor: Palette.background,
              flexibleSpace: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Consumer(
                  builder: (context, ref, child) {
                    return Column(
                      children: [
                        child!,
                        const SizedBox(height: 10),
                        SearchField(
                          text: ref.watch(queryProvider),
                          hintText: 'Cari nama atau username',
                          onChanged: (value) => ref.read(queryProvider.notifier).state = value,
                        ),
                      ],
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [
                          Palette.purple3,
                          Palette.purple2,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Praktikum',
                                style: textTheme.bodySmall!.copyWith(
                                  color: Palette.background,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                args.practicumName,
                                textAlign: TextAlign.right,
                                style: textTheme.bodySmall!.copyWith(
                                  color: Palette.background,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (args.meetingName != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Pertemuan',
                                  style: textTheme.bodySmall!.copyWith(
                                    color: Palette.background,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  args.meetingName!,
                                  textAlign: TextAlign.right,
                                  style: textTheme.bodySmall!.copyWith(
                                    color: Palette.background,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(args.meetingName != null ? 86 : 60),
                child: const SizedBox(),
              ),
            ),
          ];
        },
        body: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (context, index) => const StudentScoreCard(score: 80.0),
          itemCount: 10,
        ),
      ),
    );
  }
}

class StudentScoreCard extends StatelessWidget {
  final double score;
  final int? poinPlus;

  const StudentScoreCard({
    super.key,
    required this.score,
    this.poinPlus,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 12,
      color: Palette.background,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      border: Border.all(
        color: Palette.purple2,
      ),
      boxShadow: const [
        BoxShadow(
          offset: Offset(3, 2),
          color: Palette.purple2,
        ),
      ],
      onTap: () => showScoreInputModalBottomSheet(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                CircularPercentIndicator(
                  percent: score / 100,
                  radius: 50,
                  lineWidth: 9,
                  progressColor: Palette.purple3,
                  backgroundColor: Colors.transparent,
                  circularStrokeCap: CircularStrokeCap.round,
                  center: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Palette.purple2,
                    ),
                    child: Center(
                      child: Text(
                        '$score',
                        style: textTheme.titleLarge!.copyWith(
                          color: Palette.background,
                        ),
                      ),
                    ),
                  ),
                ),
                if (poinPlus != null)
                  CircleBorderContainer(
                    size: 32,
                    borderColor: const Color(0xFFE3B640),
                    fillColor: const Color(0xFFF2CF74),
                    child: Text(
                      '+$poinPlus',
                      style: textTheme.bodySmall!.copyWith(
                        color: Palette.background,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'H071191051',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall!.copyWith(
              color: Palette.purple3,
            ),
          ),
          Text(
            'Wd. Ananda Lesmono',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleSmall!.copyWith(
              color: Palette.purple2,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showScoreInputModalBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      builder: (context) => BottomSheet(
        onClosing: () {},
        enableDrag: false,
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wd. Ananda Lesmono',
                  style: textTheme.titleMedium!.copyWith(
                    color: Palette.purple2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'H071191051',
                  style: textTheme.bodySmall!.copyWith(
                    color: Palette.purple3,
                  ),
                ),
                const SizedBox(height: 12),
                FormBuilder(
                  key: formKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Consumer(
                          builder: (context, ref, child) {
                            return FormBuilderTextField(
                              name: 'score',
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              textAlignVertical: TextAlignVertical.center,
                              style: textTheme.bodyMedium!.copyWith(
                                color: Palette.primaryText,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Palette.background,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                hintText: 'Masukkan nilai',
                                hintStyle: textTheme.bodyMedium!.copyWith(
                                  color: Palette.hint,
                                  height: 1,
                                ),
                              ),
                              onChanged: (value) {
                                ref.read(fieldValueProvider.notifier).state = value ?? '';
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.numeric(
                                  errorText: 'Field harus berupa angka',
                                ),
                                FormBuilderValidators.min(
                                  0,
                                  errorText: 'Nilai minimal adalah 0',
                                ),
                                FormBuilderValidators.max(
                                  100,
                                  errorText: 'Nilai maksimal adalah 100',
                                ),
                              ]),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Consumer(
                        builder: (context, ref, child) {
                          return IconButton(
                            onPressed: ref.watch(fieldValueProvider).isEmpty ? null : inputScore,
                            icon: const Icon(Icons.check_rounded),
                            style: IconButton.styleFrom(
                              disabledBackgroundColor: Palette.divider,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: const Size(48, 48),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void inputScore() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      debugPrint(formKey.currentState!.value.toString());

      navigatorKey.currentState!.pop();
    }
  }
}

class ScoreInputPageArgs {
  final String title;
  final ScoreType scoreType;
  final String practicumName;
  final String? meetingName;

  const ScoreInputPageArgs({
    required this.title,
    required this.scoreType,
    required this.practicumName,
    this.meetingName,
  });
}
