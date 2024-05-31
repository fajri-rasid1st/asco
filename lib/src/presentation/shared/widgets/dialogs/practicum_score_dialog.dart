// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/custom_dialog.dart';

class PracticumScoreDialog extends StatefulWidget {
  final int meetingNumber;

  const PracticumScoreDialog({super.key, required this.meetingNumber});

  @override
  State<PracticumScoreDialog> createState() => _PracticumScoreDialogState();
}

class _PracticumScoreDialogState extends State<PracticumScoreDialog> {
  late final ValueNotifier<PracticumScoreType> scoreNotifier;

  @override
  void initState() {
    super.initState();

    scoreNotifier = ValueNotifier(practicumScoreTypes.first);
  }

  @override
  void dispose() {
    super.dispose();

    scoreNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Tugas Praktikum ${widget.meetingNumber}',
      onPressedPrimaryAction: submit,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'H071191001',
            style: textTheme.bodyMedium!.copyWith(
              color: Palette.purple3,
            ),
          ),
          Text(
            'Siti Nisrina Nabilah Putri Sulfi Yudo',
            style: textTheme.titleLarge!.copyWith(
              color: Palette.purple2,
            ),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder(
            valueListenable: scoreNotifier,
            builder: (context, scoreType, child) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RatingBar(
                      initialRating: scoreType.rate.toDouble(),
                      minRating: 1,
                      itemCount: 7,
                      itemSize: 34,
                      glow: false,
                      updateOnDrag: true,
                      ratingWidget: RatingWidget(
                        full: Icon(
                          Icons.star_rounded,
                          color: scoreType.color,
                        ),
                        half: const SizedBox(),
                        empty: Icon(
                          Icons.star_outline_rounded,
                          color: scoreType.color,
                        ),
                      ),
                      onRatingUpdate: (value) {
                        scoreNotifier.value = practicumScoreTypes[value.toInt() - 1];
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"${scoreType.description}"',
                      style: textTheme.titleMedium!.copyWith(
                        color: scoreType.color,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void submit() {
    debugPrint(scoreNotifier.value.toString());
  }
}

class PracticumScoreType {
  final int rate;
  final Color color;
  final double value;
  final String description;

  const PracticumScoreType(
    this.rate,
    this.color,
    this.value,
    this.description,
  );
}
