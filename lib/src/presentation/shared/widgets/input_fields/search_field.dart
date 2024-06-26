// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class SearchField extends StatefulWidget {
  final String text;
  final String? hintText;
  final bool delayOnChanged;
  final Duration delay;
  final ValueChanged<String> onChanged;

  const SearchField({
    super.key,
    required this.text,
    this.hintText,
    this.delayOnChanged = true,
    this.delay = const Duration(milliseconds: 750),
    required this.onChanged,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController controller;
  late final ValueNotifier<bool> isFocus;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.text);
    isFocus = ValueNotifier(false);
  }

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
    isFocus.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) => isFocus.value = value,
      child: SizedBox(
        height: 44,
        child: TextField(
          controller: controller,
          textInputAction: TextInputAction.search,
          textAlignVertical: TextAlignVertical.center,
          style: textTheme.bodyMedium,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Palette.background,
            contentPadding: EdgeInsets.zero,
            hintText: widget.hintText,
            hintStyle: textTheme.bodyMedium!.copyWith(
              color: Palette.hint,
              height: 1,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 10,
              ),
              child: ValueListenableBuilder(
                valueListenable: isFocus,
                builder: (context, isFocus, child) => SvgAsset(
                  AssetPath.getIcon('search_outlined.svg'),
                  color: isFocus ? Palette.purple2 : Palette.hint,
                  width: 10,
                ),
              ),
            ),
            suffixIcon: widget.text.isEmpty
                ? const SizedBox()
                : IconButton(
                    onPressed: resetQuery,
                    icon: SvgAsset(
                      AssetPath.getIcon('close_outlined.svg'),
                      color: Palette.primaryText,
                      width: 20,
                    ),
                  ),
          ),
          onChanged: widget.delayOnChanged
              ? (text) => debounce(() => widget.onChanged(text))
              : widget.onChanged,
        ),
      ),
    );
  }

  void debounce(VoidCallback callback) {
    timer?.cancel();
    timer = Timer(widget.delay, callback);
  }

  void resetQuery() {
    controller.clear();
    widget.onChanged('');
  }
}
