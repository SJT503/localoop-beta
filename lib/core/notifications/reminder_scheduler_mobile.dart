import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../app_strings.dart';
import '../models/cycle_models.dart';
import '../reminder_utils.dart';

const _notificationId = 1001;

final FlutterLocalNotificationsPlugin _plugin =
    FlutterLocalNotificationsPlugin();

bool _initialized = false;

Future<void> initReminderService() async {
  if (_initialized) return;
  try {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    tz_data.initializeTimeZones();
    _initialized = true;
  } catch (_) {
    _initialized = false;
  }
}

bool get remindersSupported => _initialized;

Future<bool> _ensurePermission() async {
  try {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted != false;
    }
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted != false;
    }
  } catch (_) {
    return false;
  }
  return true;
}

NotificationDetails _details() {
  return const NotificationDetails(
    android: AndroidNotificationDetails(
      'localoop_gentle_reminder',
      'Localoop gentle reminders',
      channelDescription: 'Cycle reminders with privacy-friendly copy',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    ),
    iOS: DarwinNotificationDetails(),
  );
}

Future<bool> syncPeriodReminder({
  required CycleProfile profile,
  required CycleSettings settings,
  required AppStrings strings,
}) async {
  try {
    await initReminderService();
    if (!_initialized) return false;
    if (!settings.gentleReminder) {
      await _plugin.cancel(_notificationId);
      return false;
    }
    if (!await _ensurePermission()) return false;

    final when = nextReminderDate(profile);
    final title = settings.privacyNotificationMode
        ? strings.privacyReminderCopy
        : strings.reminderTitle;
    final body = settings.privacyNotificationMode
        ? strings.reminderBody
        : '${strings.predictedWindowStarts} ${strings.formatDate(when)}';

    await _plugin.zonedSchedule(
      _notificationId,
      title,
      body,
      tz.TZDateTime.from(when, tz.local),
      _details(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> previewReminder({
  required CycleSettings settings,
  required AppStrings strings,
}) async {
  try {
    await initReminderService();
    if (!_initialized) return false;
    if (!await _ensurePermission()) return false;

    final title = settings.privacyNotificationMode
        ? strings.privacyReminderCopy
        : strings.reminderTitle;
    await _plugin.show(
      1002,
      title,
      strings.reminderBody,
      _details(),
    );
    return true;
  } catch (_) {
    return false;
  }
}
