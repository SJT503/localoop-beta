import '../app_strings.dart';
import '../models/cycle_models.dart';

Future<void> initReminderService() async {}

Future<bool> syncPeriodReminder({
  required CycleProfile profile,
  required CycleSettings settings,
  required AppStrings strings,
}) async {
  return false;
}

Future<bool> previewReminder({
  required CycleSettings settings,
  required AppStrings strings,
}) async {
  return false;
}

bool get remindersSupported => false;
