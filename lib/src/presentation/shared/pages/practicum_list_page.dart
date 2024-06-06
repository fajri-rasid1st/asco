// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/src/presentation/shared/widgets/cards/practicum_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';

class PracticumListPage extends StatelessWidget {
  final PracticumListPageArgs args;

  const PracticumListPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Pilih Praktikum',
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) {
          return PracticumCard(
            onTap: args.onItemTapped,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: 3,
      ),
    );
  }
}

class PracticumListPageArgs {
  final VoidCallback? onItemTapped;
  final bool showClassroomAndMeetingButtons;

  PracticumListPageArgs({
    this.onItemTapped,
    this.showClassroomAndMeetingButtons = false,
  });
}
