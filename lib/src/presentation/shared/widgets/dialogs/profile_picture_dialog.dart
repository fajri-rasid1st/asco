// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';

class ProfilePictureDialog extends StatelessWidget {
  final String imageUrl;

  const ProfilePictureDialog({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: const SizedBox(),
                ),
              ),
              Center(
                child: CircleNetworkImage(
                  imageUrl: imageUrl,
                  size: AppSize.getAppWidth(context) - 80,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
