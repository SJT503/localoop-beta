import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'features/period_tracking/period_tracking_screen.dart';
import 'ui/mobile_shell.dart';

void main() {
  runApp(const LocaloopApp());
}

class LocaloopApp extends StatelessWidget {
  const LocaloopApp({super.key});

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Localoop',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE84B7A)),
        fontFamily: 'Roboto',
      ),
      home: const PeriodTrackingScreen(),
    );
    if (kIsWeb) {
      return MobileShell(child: app);
    }
    return app;
  }
}
