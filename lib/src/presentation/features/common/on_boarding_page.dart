// Flutter imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FilledButton(
          onPressed: () => context.showSnackBar(
            title: 'Login Gagal Pfpsa audpasos psaa!',
            message: 'Username atau password yang kamu masukkan salah aofhs hfasofh oafhaso',
            type: SnackBarType.success,
          ),
          child: const Text('Press Me!'),
        ),
      ),
    );
  }
}
