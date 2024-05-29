import 'package:asco/src/presentation/shared/widgets/dialogs/practicum_score_dialog.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          onPressed: () => showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const PracticumScoreDialog(meetingNumber: 1),
          ),
          child: const Text('Press Me!'),
        ),
      ),
    );
  }
}
