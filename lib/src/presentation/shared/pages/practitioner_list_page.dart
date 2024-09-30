// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/enums/user_badge_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/dummies_data.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_icon_button.dart';

class PractitionerListPage extends StatelessWidget {
  final String title;

  const PractitionerListPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) => UserCard(
          user: studentDummies[index],
          badgeType: UserBadgeType.text,
          trailing: CustomIconButton(
            'github_filled.svg',
            tooltip: 'Github',
            color: Palette.purple2,
            onPressed: () => context.openUrl(
              name: 'Github',
              url: 'https://github.com/${studentDummies[index].githubUsername}',
            ),
          ),
          // onTap: () => navigatorKey.currentState!.pushNamed(controlCardDetailRoute),
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: studentDummies.length,
      ),
    );
  }
}
