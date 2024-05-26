// Flutter imports:
import 'package:asco/core/utils/credential_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init credential saver
  await CredentialSaver.init();

  // Prevent landscape orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const ProviderScope(
      child: AscoApp(),
    ),
  );
}
