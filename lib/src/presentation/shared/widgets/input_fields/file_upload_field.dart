// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path/path.dart' as p;

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/services/file_service.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class FileUploadField extends StatefulWidget {
  final String label;
  final List<String> extensions;
  final VoidCallback? onPressedFilePickerButton;
  final ValueChanged<String?>? onFileChanged;

  const FileUploadField({
    super.key,
    required this.label,
    required this.extensions,
    this.onPressedFilePickerButton,
    this.onFileChanged,
  });

  @override
  State<FileUploadField> createState() => _FileUploadFieldState();
}

class _FileUploadFieldState extends State<FileUploadField> {
  late final ValueNotifier<String?> filePathNotifier;

  @override
  void initState() {
    super.initState();

    filePathNotifier = ValueNotifier(null);
  }

  @override
  void dispose() {
    super.dispose();

    filePathNotifier.dispose();
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
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        ValueListenableBuilder(
          valueListenable: filePathNotifier,
          builder: (context, path, child) {
            return Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      if (path != null) {
                        await OpenFile.open(path);
                      } else {
                        context.showSnackBar(
                          title: 'File Tidak Ada',
                          message: 'File ${widget.label.toLowerCase()} belum dimasukkan!',
                          type: SnackBarType.info,
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Palette.azure2,
                    ),
                    child: Text(
                      path != null ? p.basename(path) : 'Tampilkan',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: widget.onPressedFilePickerButton ??
                      () async {
                        final path = await FileService.pickFile(extensions: widget.extensions);

                        filePathNotifier.value = path;

                        if (widget.onFileChanged != null) {
                          widget.onFileChanged!(path);
                        }
                      },
                  icon: SvgAsset(
                    AssetPath.getIcon('upload_outlined.svg'),
                    width: 20,
                  ),
                ),
                IconButton(
                  onPressed: () => context.showConfirmDialog(
                    title: 'Hapus File?',
                    message: 'Hapus file ${widget.label.toLowerCase()} yang telah diupload?',
                    primaryButtonText: 'Hapus',
                    onPressedPrimaryButton: () {
                      filePathNotifier.value = null;

                      if (widget.onFileChanged != null) {
                        widget.onFileChanged!(null);
                      }

                      navigatorKey.currentState!.pop();
                    },
                  ),
                  icon: SvgAsset(
                    AssetPath.getIcon('trash_outlined.svg'),
                    width: 20,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Palette.error,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
