// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';

// Project imports:
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/custom_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class AttendanceDialog extends StatefulWidget {
  final int meetingNumber;

  const AttendanceDialog({super.key, required this.meetingNumber});

  @override
  State<AttendanceDialog> createState() => _AttendanceDialogState();
}

class _AttendanceDialogState extends State<AttendanceDialog> {
  late final List<FaceStatus> status;
  late final List<int> points;
  late final ValueNotifier<FaceStatus> statusNotifier;
  late final ValueNotifier<int?> pointNotifier;
  late final GlobalKey<FormBuilderState> formKey;

  @override
  void initState() {
    status = [
      const FaceStatus(
        name: 'Alpa',
        icon: 'face_dizzy.svg',
        color: Palette.error,
      ),
      const FaceStatus(
        name: 'Izin',
        icon: 'face_neutral.svg',
        color: Palette.info,
      ),
      const FaceStatus(
        name: 'Sakit',
        icon: 'face_sick.svg',
        color: Palette.warning,
      ),
      const FaceStatus(
        name: 'Hadir',
        icon: 'face_smile.svg',
        color: Palette.success,
      ),
    ];
    points = [5, 10, 15, 20, 25, 30];
    statusNotifier = ValueNotifier(status.last);
    pointNotifier = ValueNotifier(null);
    formKey = GlobalKey<FormBuilderState>();

    super.initState();
  }

  @override
  void dispose() {
    statusNotifier.dispose();
    pointNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Pertemuan ${widget.meetingNumber}',
      backgroundColor: Palette.background,
      onPressedPrimaryAction: submit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'H071191049',
            style: textTheme.bodyMedium!.copyWith(
              color: Palette.purple3,
            ),
          ),
          Text(
            'Muh. Ikhsan',
            style: textTheme.titleLarge!.copyWith(
              color: Palette.purple2,
            ),
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder(
            valueListenable: statusNotifier,
            builder: (context, currentStatus, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List<FaceStatusWidget>.generate(
                      status.length,
                      (index) => FaceStatusWidget(
                        status: status[index],
                        isSelected: currentStatus == status[index],
                        onTap: () => statusNotifier.value = status[index],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (currentStatus == status.last) ...[
                    Text(
                      'Beri Extra Poin',
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    ValueListenableBuilder(
                      valueListenable: pointNotifier,
                      builder: (context, currentPoint, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List<ExtraPointWidget>.generate(
                            points.length,
                            (index) => ExtraPointWidget(
                              point: points[index],
                              isSelected: currentPoint == points[index],
                              onTap: () => pointNotifier.value = points[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ] else ...[
                    Builder(
                      builder: (context) {
                        pointNotifier.value = null;

                        return FormBuilder(
                          key: formKey,
                          child: const CustomTextField(
                            name: 'note',
                            label: 'Catatan',
                            isSmall: true,
                            hintText: 'Tambahkan catatan',
                            maxLines: 4,
                            textInputAction: TextInputAction.newline,
                          ),
                        );
                      },
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void submit() {
    FocusManager.instance.primaryFocus?.unfocus();

    formKey.currentState?.save();

    // Update attendance meeting here ...

    navigatorKey.currentState!.pop<bool>(statusNotifier.value == status.last);
  }
}

class FaceStatusWidget extends StatelessWidget {
  final FaceStatus status;
  final bool isSelected;
  final VoidCallback? onTap;

  const FaceStatusWidget({
    super.key,
    required this.status,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Palette.secondaryBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? status.color : Colors.transparent,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgAsset(
                AssetPath.getIcon(status.icon),
                color: isSelected ? status.color : Palette.secondaryText,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            status.name,
            style: textTheme.bodyMedium!.copyWith(
              color: isSelected ? status.color : Palette.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class ExtraPointWidget extends StatelessWidget {
  final int point;
  final bool isSelected;
  final VoidCallback? onTap;

  const ExtraPointWidget({
    super.key,
    required this.point,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CircleBorderContainer(
      size: 32,
      borderColor: isSelected ? Palette.purple2 : null,
      fillColor: isSelected ? Palette.purple3 : null,
      onTap: onTap,
      child: Text(
        '+$point',
        style: textTheme.bodySmall!.copyWith(
          color: isSelected ? Palette.background : Palette.secondaryText,
        ),
      ),
    );
  }
}

class FaceStatus {
  final String name;
  final String icon;
  final Color color;

  const FaceStatus({
    required this.name,
    required this.icon,
    required this.color,
  });
}
