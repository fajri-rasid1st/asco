// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';

// Project imports:
import 'package:asco/core/helpers/asset_path.dart';

class PracticumBadgeImage extends StatelessWidget {
  final String badgeUrl;
  final double width;
  final double height;

  const PracticumBadgeImage({
    super.key,
    required this.badgeUrl,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      imageUrl: badgeUrl,
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 200),
      placeholder: (context, url) => Image.asset(
        AssetPath.getImage('badge.png'),
        width: width,
        height: height,
      ),
      errorWidget: (context, url, error) => Image.asset(
        AssetPath.getImage('badge.png'),
        width: width,
        height: height,
      ),
    );
  }
}
