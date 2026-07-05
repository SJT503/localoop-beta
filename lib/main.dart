import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'features/period_tracking/period_tracking_screen.dart';
import 'core/l10n/supported_locales.dart';
import 'ui/mobile_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  for (final item in supportedLocales) {
    await initializeDateFormatting(item.code);
  }
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
