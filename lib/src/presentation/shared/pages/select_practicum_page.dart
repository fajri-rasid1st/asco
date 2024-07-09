// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';

class SelectPracticumPage extends StatelessWidget {
  final SelectPracticumPageArgs args;

  const SelectPracticumPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Pilih Praktikum',
      ),
      // body: ListView.separated(
      //   padding: const EdgeInsets.all(20),
      //   itemBuilder: (context, index) => PracticumCard(
      //     showClassroomAndMeetingButtons: args.showClassroomAndMeetingButtons,
      //     onTap: args.onItemTapped,
      //   ),
      //   separatorBuilder: (context, index) => const SizedBox(height: 10),
      //   itemCount: 3,
      // ),
    );
  }
}

class SelectPracticumPageArgs {
  final bool showClassroomAndMeetingButtons;
  final VoidCallback? onItemTapped;

  const SelectPracticumPageArgs({
    this.showClassroomAndMeetingButtons = false,
    this.onItemTapped,
  });
}
