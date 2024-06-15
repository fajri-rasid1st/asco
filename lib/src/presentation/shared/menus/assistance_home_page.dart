// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/src/presentation/shared/widgets/asco_app_bar.dart';

class AssistanceHomePage extends StatelessWidget {
  const AssistanceHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const AscoAppBar(),
            const SizedBox(height: 20),
            Container(),
          ],
        ),
      ),
    );
  }
}
