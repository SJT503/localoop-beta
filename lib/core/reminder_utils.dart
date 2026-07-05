import 'app_strings.dart';
import 'models/cycle_models.dart';

class ReminderPreview {
  const ReminderPreview({
    required this.enabled,
    required this.title,
    required this.body,
    required this.scheduledLabel,
    required this.scheduledAt,
  });

  final bool enabled;
  final String title;
  final String body;
  final String scheduledLabel;
  final DateTime? scheduledAt;
}

DateTime nextReminderDate(CycleProfile profile, [DateTime? from]) {
  final anchor = DateTime.parse('${profile.lastPeriodStart}T09:00:00');
  var reminder = anchor.add(Duration(days: profile.cycleLength - 2));
  final now = from ?? DateTime.now();
  while (!reminder.isAfter(now)) {
    reminder = reminder.add(Duration(days: profile.cycleLength));
  }
  return reminder;
}

ReminderPreview buildReminderPreview({
  required CycleProfile profile,
  required CycleSettings settings,
  required AppStrings strings,
}) {
  if (!settings.gentleReminder) {
    return ReminderPreview(
      enabled: false,
      title: strings.reminderTitle,
      body: strings.isEn ? 'Reminders are off' : '提醒已关闭',
      scheduledLabel: '',
      scheduledAt: null,
    );
  }

  final scheduledAt = nextReminderDate(profile);
  final label = strings.formatDate(scheduledAt);
  final copy = settings.privacyNotificationMode
      ? strings.privacyReminderCopy
      : (strings.isEn
          ? 'Period supplies reminder in 2 days'
          : '预计 2 天后进入经期窗口，记得补充用品');

  return ReminderPreview(
    enabled: true,
    title: strings.reminderTitle,
    body: copy,
    scheduledLabel: strings.isEn ? 'Around $label' : '约 $label',
    scheduledAt: scheduledAt,
  );
}
