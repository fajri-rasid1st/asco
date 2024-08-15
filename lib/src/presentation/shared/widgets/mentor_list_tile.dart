// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';

class MentorListTile extends StatelessWidget {
  final String name;
  final String role;
  final String? imageUrl;

  const MentorListTile({
    super.key,
    required this.name,
    required this.role,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 12,
      leading: CircleNetworkImage(
        imageUrl: imageUrl,
        size: 40,
      ),
      title: Text(
        name,
        style: textTheme.titleSmall!.copyWith(
          color: Palette.background,
        ),
      ),
      subtitle: Text(
        role,
        style: textTheme.bodySmall!.copyWith(
          color: Palette.scaffoldBackground,
        ),
      ),
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
      ),
    );
  }
}
