// Flutter imports:
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ScoreDetailPage extends StatelessWidget {
  const ScoreDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Wd. Ananda Lesmono',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
