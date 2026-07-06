import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app_shell.dart';

void main() {
  runApp(const ProviderScope(child: SoundDetectiveApp()));
}

class SoundDetectiveApp extends StatelessWidget {
  const SoundDetectiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sound Detective',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const AppShell(),
    );
  }
}
