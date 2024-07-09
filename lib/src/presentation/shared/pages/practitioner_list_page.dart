// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/keys.dart';
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
          user: CredentialSaver.credential!,
          badgeText: 'Kelas A',
          trailing: CustomIconButton(
            'github_filled.svg',
            color: Palette.purple2,
            tooltip: 'Github',
            onPressed: () => FunctionHelper.openUrl('https://github.com/fajri-rasid1st'),
          ),
          onTap: () => navigatorKey.currentState!.pushNamed(controlCardDetailRoute),
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: 10,
      ),
    );
  }
}
