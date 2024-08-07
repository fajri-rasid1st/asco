// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';

class CircleNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final double? placeholderSize;
  final bool withBorder;
  final double borderWidth;
  final Color borderColor;
  final BoxFit fit;
  final bool showPreviewWhenPressed;

  const CircleNetworkImage({
    super.key,
    this.imageUrl,
    required this.size,
    this.placeholderSize,
    this.withBorder = false,
    this.borderWidth = 1.0,
    this.borderColor = const Color(0xFF000000),
    this.fit = BoxFit.cover,
    this.showPreviewWhenPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 200),
        imageBuilder: (context, imageProvider) => buildImage(context, imageProvider),
        placeholder: (context, url) => CircleAvatar(
          radius: size / 2,
          backgroundColor: Palette.purple5,
          child: Center(
            child: SizedBox(
              width: placeholderSize ?? size / 2.5,
              height: placeholderSize ?? size / 2.5,
              child: const SpinKitRing(
                lineWidth: 2,
                color: Palette.secondaryText,
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          radius: size / 2,
          backgroundColor: Palette.purple5,
          child: Center(
            child: Icon(
              Icons.hide_source_rounded,
              color: Palette.secondaryText,
              size: placeholderSize ?? size / 2.5,
            ),
          ),
        ),
      );
    }

    return buildImage(context, AssetImage(AssetPath.getImage('no-profile.png')));
  }

  GestureDetector buildImage(
    BuildContext context,
    ImageProvider<Object> imageProvider,
  ) {
    return GestureDetector(
      onTap: showPreviewWhenPressed ? () => context.showProfilePictureDialog(imageUrl) : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: withBorder
              ? Border.all(
                  width: borderWidth,
                  color: borderColor,
                )
              : null,
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
    );
  }
}
