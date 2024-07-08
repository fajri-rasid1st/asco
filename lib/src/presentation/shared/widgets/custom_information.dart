// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';

class CustomInformation extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool withScaffold;

  const CustomInformation({
    super.key,
    required this.title,
    this.subtitle,
    this.withScaffold = false,
  });

  @override
  Widget build(BuildContext context) {
    return withScaffold
        ? Scaffold(
            body: buildCustomInformation(),
          )
        : buildCustomInformation();
  }

  Center buildCustomInformation() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall!.copyWith(
                color: Palette.secondaryText,
              ),
            ),
            const SizedBox(height: 4),
            if (subtitle != null)
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall!.copyWith(
                  color: Palette.secondaryText,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
