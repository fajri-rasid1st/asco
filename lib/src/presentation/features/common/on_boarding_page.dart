// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/src/presentation/shared/widgets/input_fields/markdown_field.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: MarkdownField(
            name: '',
            label: 'Informasi',
            onChanged: (text) {},
            hintText: 'Masukkan informasi selengkap mungkin',
          ),
        ),
      ),
    );
  }
}
