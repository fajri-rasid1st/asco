// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:asco/src/presentation/shared/widgets/dialogs/github_repository_dialog.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [
          SystemUiOverlay.top,
          SystemUiOverlay.bottom,
        ],
      ),
      child: Scaffold(
        body: Center(
          child: OutlinedButton(
            onPressed: () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const GithubRepositoryDialog(),
            ),
            child: const Text('Press Me!'),
          ),
        ),
      ),
    );
  }
}
