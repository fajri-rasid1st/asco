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
  final double? borderWidth;
  final Color? borderColor;
  final BoxFit fit;

  const CircleNetworkImage({
    super.key,
    required this.imageUrl,
    required this.size,
    this.placeholderSize,
    this.withBorder = false,
    this.borderWidth,
    this.borderColor,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 200),
      imageBuilder: (context, imageProvider) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: withBorder
                ? Border.all(
                    width: borderWidth ?? 1,
                    color: borderColor ?? const Color(0xFF000000),
                  )
                : null,
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
            ),
          ),
        );
      },
      placeholder: (context, url) {
        return CircleAvatar(
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
        );
      },
      errorWidget: (context, url, error) {
        return CircleAvatar(
          radius: size / 2,
          backgroundColor: Palette.purple5,
          child: const Center(
            child: Icon(
              Icons.hide_source_rounded,
              color: Palette.secondaryText,
            ),
          ),
        );
      },
    );
  }
}
