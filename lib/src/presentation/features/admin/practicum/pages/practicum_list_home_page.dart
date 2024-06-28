// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/enums/form_action_type.dart';
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/features/admin/practicum/pages/practicum_form_page.dart';
import 'package:asco/src/presentation/shared/widgets/animated_fab.dart';
import 'package:asco/src/presentation/shared/widgets/cards/practicum_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';

class PracticumListHomePage extends StatefulWidget {
  const PracticumListHomePage({super.key});

  @override
  State<PracticumListHomePage> createState() => _PracticumListHomePageState();
}

class _PracticumListHomePageState extends State<PracticumListHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController fabAnimationController;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    fabAnimationController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
    )..forward();

    scrollController = ScrollController()..addListener(() {});
  }

  @override
  void dispose() {
    super.dispose();

    fabAnimationController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Data Praktikum',
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) => FunctionHelper.handleFabVisibilityOnScroll(
          fabAnimationController,
          notification,
        ),
        child: ListView.separated(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          itemBuilder: (context, index) => PracticumCard(
            showDeleteButton: true,
            onTap: () => navigatorKey.currentState!.pushNamed(practicumDetailRoute),
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: 3,
        ),
      ),
      floatingActionButton: AnimatedFloatingActionButton(
        animationController: fabAnimationController,
        onPressed: () => navigatorKey.currentState!.pushNamed(
          practicumFirstFormRoute,
          arguments: const PracticumFormPageArgs(
            title: 'Tambah',
            action: FormActionType.create,
          ),
        ),
        tooltip: 'Tambah',
        child: const Icon(
          Icons.add_rounded,
          size: 28,
        ),
      ),
    );
  }
}
