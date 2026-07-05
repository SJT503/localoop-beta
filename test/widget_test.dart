import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:localoop/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Localoop app smoke test', (WidgetTester tester) async {
    await initializeDateFormatting('en');
    SharedPreferences.setMockInitialValues({
      'localoop_profile_v1':
          '{"completed":true,"lastPeriodStart":"2026-07-02","cycleLength":29,"periodLength":5,"cycles":3,"variance":2,"goal":"Track cycle"}',
      'localoop_settings_v1':
          '{"gentleReminder":true,"privacyNotificationMode":true,"hideSensitiveWords":false,"localeCode":"en","onboardingCompleted":true}',
    });
    await tester.pumpWidget(const LocaloopApp());
    await tester.pumpAndSettle();
    expect(find.text('Localoop'), findsOneWidget);
  });
}
