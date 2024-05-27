// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/src/presentation/shared/widgets/input_fields/search_field.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SearchField(
            text: 'sss',
            hintText: 'Cari nama atau username',
          ),
        ),
      ),
    );
  }
}
