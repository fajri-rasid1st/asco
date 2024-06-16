// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';

class LoadingIndicator extends StatelessWidget {
  final bool withScaffold;

  const LoadingIndicator({super.key, this.withScaffold = false});

  @override
  Widget build(BuildContext context) {
    return withScaffold
        ? Scaffold(
            body: buildLoadingIndicator(),
          )
        : buildLoadingIndicator();
  }

  Center buildLoadingIndicator() {
    return const Center(
      child: SpinKitCubeGrid(
        color: Palette.primary,
        size: 50.0,
        duration: Duration(milliseconds: 1000),
      ),
    );
  }
}
