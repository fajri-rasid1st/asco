// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
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
    this.delay = const Duration(milliseconds: 800),
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
      child: TextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: widget.hintText,
          isDense: true,
          filled: true,
          fillColor: Palette.background,
          contentPadding: EdgeInsets.zero,
          prefixIcon: buildPrefixIcon(),
          suffixIcon: buildSuffixIcon(),
        ),
        onChanged: widget.delayOnChanged
            ? (text) => debounce(() => widget.onChanged(text))
            : widget.onChanged,
      ),
    );
  }

  Padding buildPrefixIcon() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 10,
      ),
      child: ValueListenableBuilder(
        valueListenable: isFocus,
        builder: (context, isFocus, child) {
          return SvgAsset(
            assetName: AssetPath.getIcon('search_outlined.svg'),
            color: isFocus ? Palette.purple2 : Palette.hint,
          );
        },
      ),
    );
  }

  Widget buildSuffixIcon() {
    if (widget.text.isEmpty) return const SizedBox();

    return IconButton(
      onPressed: resetQuery,
      icon: SvgAsset(
        assetName: AssetPath.getIcon('close_outlined.svg'),
        color: Palette.primaryText,
        width: 20,
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
