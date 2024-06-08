// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/cards/classroom_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';

class ClassroomListHomePage extends StatelessWidget {
  const ClassroomListHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Pemrograman Mobile',
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) {
          return ClassroomCard(
            onTap: () => navigatorKey.currentState!.pushNamed(classroomDetailRoute),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: 3,
      ),
    );
  }
}
