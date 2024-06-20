// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/shared/widgets/asco_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20 + kBottomNavigationBarHeight),
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
            const SectionContainer(title: 'Asisten'),
            const SizedBox(height: 16),
            const SectionContainer(title: 'Praktikan'),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SectionContainer extends StatelessWidget {
  final String title;

  const SectionContainer({super.key, required this.title});

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
            5,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index == 4 ? 0 : 12,
              ),
              child: Row(
                children: [
                  const CircleNetworkImage(
                    imageUrl: 'https://placehold.co/100x100/png',
                    size: 50,
                    withBorder: true,
                    borderColor: Palette.purple3,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Muh. Sultan Nazhim Latenri Tatta S.H',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleSmall!.copyWith(
                            color: Palette.purple2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'H071211074',
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
