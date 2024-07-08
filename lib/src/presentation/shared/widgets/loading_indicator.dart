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
    return Center(
      child: SpinKitCubeGrid(
        color: withScaffold ? Palette.purple3 : Palette.violet3,
        size: 50.0,
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }
}
