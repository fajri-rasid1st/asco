// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:path/path.dart' as p;

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/services/file_service.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class FileUploadField extends StatelessWidget {
  final String name;
  final String label;
  final List<String> extensions;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final Future<String?> Function()? onPressedFilePickerButton;
  final String? Function(String?)? validator;
  final TextStyle? labelStyle;
  final bool withDeleteButton;

  const FileUploadField({
    super.key,
    required this.name,
    required this.label,
    required this.extensions,
    this.initialValue,
    this.onChanged,
    this.onPressedFilePickerButton,
    this.validator,
    this.labelStyle,
    this.withDeleteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: labelStyle ??
              textTheme.titleSmall!.copyWith(
                color: Palette.purple2,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 6),
        FormBuilderField<String?>(
          name: name,
          initialValue: initialValue,
          onChanged: onChanged,
          validator: validator,
          builder: (field) {
            final path = field.value;

            return Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () => context.openFile(
                      name: label,
                      path: path,
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: Palette.azure2,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      path != null ? p.basename(path) : 'Tampilkan',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  onPressed: () async {
                    final path = onPressedFilePickerButton != null
                        ? await onPressedFilePickerButton!()
                        : await FileService.pickFile(extensions: extensions);

                    if (path != null) field.didChange(path);
                  },
                  icon: SvgAsset(
                    AssetPath.getIcon('upload_outlined.svg'),
                    width: 20,
                  ),
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                if (withDeleteButton) ...[
                  const SizedBox(width: 6),
                  IconButton(
                    onPressed: () => context.showConfirmDialog(
                      title: 'Hapus File?',
                      message: 'Hapus file ${label.toLowerCase()} yang telah dipilih?',
                      primaryButtonText: 'Hapus',
                      onPressedPrimaryButton: () {
                        field.didChange(null);

                        navigatorKey.currentState!.pop();
                      },
                    ),
                    icon: SvgAsset(
                      AssetPath.getIcon('trash_outlined.svg'),
                      width: 20,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Palette.error,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
