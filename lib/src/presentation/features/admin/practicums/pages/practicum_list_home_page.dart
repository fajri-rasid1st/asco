// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/cards/practicum_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_fab.dart';

class PracticumListHomePage extends StatelessWidget {
  const PracticumListHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Data Praktikum',
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) {
          return PracticumCard(
            showDeleteButton: true,
            onTap: () => navigatorKey.currentState!.pushNamed(practicumDetailRoute),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: 3,
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {},
        tooltip: 'Tambah',
        child: const Icon(
          Icons.add_rounded,
          size: 28,
        ),
      ),
    );
  }
}
