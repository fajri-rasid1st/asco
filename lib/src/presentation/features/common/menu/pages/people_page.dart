// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/dummies_data.dart';
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/shared/widgets/asco_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 76),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AscoAppBar(),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 12,
              ),
              child: Text(
                'People',
                style: textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SectionContainer(
              title: 'Asisten',
              profiles: assistantDummies,
            ),
            const SizedBox(height: 16),
            const SectionContainer(
              title: 'Praktikan',
              profiles: studentDummies,
            ),
          ],
        ),
      ),
    );
  }
}

class SectionContainer extends StatelessWidget {
  final String title;
  final List<Profile> profiles;

  const SectionContainer({
    super.key,
    required this.title,
    required this.profiles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: Palette.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: title,
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 8,
            ),
          ),
          ...List<Padding>.generate(
            profiles.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index == profiles.length - 1 ? 0 : 12,
              ),
              child: Row(
                children: [
                  CircleNetworkImage(
                    imageUrl: profiles[index].profilePicturePath,
                    size: 50,
                    withBorder: true,
                    borderColor: Palette.purple3,
                    showPreviewWhenPressed: true,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${profiles[index].fullname}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleSmall!.copyWith(
                            color: Palette.purple2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${profiles[index].username}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall!.copyWith(
                            color: Palette.purple3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
