// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String time;
  final String badgePath;
  final Color backgroundColor;

  const CourseCard({
    super.key,
    required this.title,
    required this.time,
    required this.badgePath,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => navigatorKey.currentState!.pushNamedAndRemoveUntil(
          mainMenuRoute,
          (route) => false,
        ),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 180,
              color: backgroundColor,
            ),
            Positioned(
              right: 0,
              child: SizedBox(
                width: 200,
                height: 180,
                child: SvgAsset(
                  AssetPath.getVector('bg_attribute_2.svg'),
                  color: Palette.black1.withOpacity(.1),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: SizedBox(
                width: 180,
                height: 180,
                child: SvgAsset(
                  AssetPath.getVector('bg_attribute_2.svg'),
                  color: Palette.black1.withOpacity(.1),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            title,
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Palette.background,
                              height: 1.25,
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 44,
                          height: 48,
                          child: SvgAsset(badgePath),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: textTheme.bodySmall?.copyWith(
                        color: Palette.scaffoldBackground,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: List<Transform>.generate(
                        4,
                        (index) => Transform.translate(
                          offset: Offset((-18 * index).toDouble(), 0),
                          child: Builder(
                            builder: (context) {
                              if (index == 3) {
                                return Container(
                                  width: 28,
                                  height: 28,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Palette.purple5,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '+24',
                                      style: textTheme.labelSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return const CircleNetworkImage(
                                imageUrl: 'https://placehold.co/300x300/png',
                                size: 32,
                                withBorder: true,
                                borderWidth: 1,
                                borderColor: Palette.background,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
