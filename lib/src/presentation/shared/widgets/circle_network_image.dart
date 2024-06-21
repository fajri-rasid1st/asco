// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';

class CircleNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final double? placeholderSize;
  final bool withBorder;
  final double borderWidth;
  final Color borderColor;
  final BoxFit fit;

  const CircleNetworkImage({
    super.key,
    required this.imageUrl,
    required this.size,
    this.placeholderSize,
    this.withBorder = false,
    this.borderWidth = 1.0,
    this.borderColor = const Color(0xFF000000),
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 200),
      imageBuilder: (context, imageProvider) => Container(
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
}
