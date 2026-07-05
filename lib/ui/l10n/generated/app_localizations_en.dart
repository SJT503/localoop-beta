// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Luna';

  @override
  String get tagline => 'Your cycle data, only you can unlock it';

  @override
  String get welcomeTitle => 'Welcome to Luna';

  @override
  String get welcomeBody =>
      'Your cycle data, only you can unlock it.\\n\\n• No account, no email or phone collected\\n• Data encrypted locally, cloud stores ciphertext only\\n• We can\'t sell your data because we don\'t have it\\n• Open source, third-party security audited';

  @override
  String get privacyTitle => 'How we protect your data';

  @override
  String get privacyLocalEncrypt => 'Local encryption';

  @override
  String get privacyLocalEncryptDesc =>
      'All data encrypted with AES-256 on your device, even we can\'t read it';

  @override
  String get privacyNoCloud => 'No cloud by default';

  @override
  String get privacyNoCloudDesc =>
      'Cloud backup is optional. When enabled, server only sees ciphertext';

  @override
  String get privacyNoAccount => 'No account';

  @override
  String get privacyNoAccountDesc =>
      'No email, phone, birthday, weight. Device keypair is your only identity';

  @override
  String get privacyMnemonic => 'Mnemonic recovery';

  @override
  String get privacyMnemonicDesc =>
      '24-word mnemonic derives master key. Lost mnemonic = data lost forever, write it offline';

  @override
  String get privacyOpenSource => 'Open source audit';

  @override
  String get privacyOpenSourceDesc =>
      'Source code + crypto algorithms public, third-party security audit public';

  @override
  String get generateMnemonic => 'Generate my mnemonic';

  @override
  String get mnemonicTitle => 'Your 24-word mnemonic';

  @override
  String get mnemonicWarning =>
      '⚠️ Write it down on paper immediately.\\n⚠️ No screenshots, no photos, no cloud sync.';

  @override
  String get mnemonicConfirmed => 'I\'ve written it down';

  @override
  String get backupConfirmTitle => 'Confirm you\'ve backed up offline';

  @override
  String get backupConfirmBody =>
      'Please confirm:\\n\\n✓ I wrote the mnemonic on paper\\n✓ I didn\'t screenshot, photo, or save to any cloud\\n✓ I know losing mnemonic = data lost forever\\n✓ I know anyone with mnemonic + my phone = can read my data';

  @override
  String get backupConfirmAction => 'I confirm backup is correct';

  @override
  String get mnemonicConfirmTitle => 'Enter your mnemonic to confirm';

  @override
  String get mnemonicConfirmHint =>
      'Enter all 24 words in order, separated by spaces';

  @override
  String get verify => 'Verify';

  @override
  String get mnemonicError => 'Mnemonic incorrect, please check';

  @override
  String get setupComplete => 'Setup complete';

  @override
  String get mnemonicFingerprintLabel =>
      'Your mnemonic fingerprint (doesn\'t reveal mnemonic):';

  @override
  String get mnemonicFingerprintHint =>
      'Use this fingerprint to verify your written mnemonic later.\\nYou can note the fingerprint, but never note the mnemonic to any cloud.';

  @override
  String get startUsing => 'Start using';

  @override
  String get tabHome => 'Luna';

  @override
  String get tabInsights => 'Insights';

  @override
  String get tabSettings => 'Settings';

  @override
  String get nextPeriod => 'Next period';

  @override
  String daysLeft(int count) {
    return '$count days left';
  }

  @override
  String get todayMaybeStart => 'May start today';

  @override
  String overdueDays(int count) {
    return '$count days overdue';
  }

  @override
  String get predictedOvulation => 'Predicted ovulation';

  @override
  String get currentPhase => 'Current phase';

  @override
  String get confidenceHigh => 'High';

  @override
  String get confidenceMedium => 'Medium';

  @override
  String get confidenceLow => 'Low';

  @override
  String get confidenceVeryLow => 'Very low';

  @override
  String get phaseMenstrual => 'Menstrual';

  @override
  String get phaseFollicular => 'Follicular';

  @override
  String get phaseOvulation => 'Ovulation';

  @override
  String get phaseLuteal => 'Luteal';

  @override
  String get markPeriodStartToday => 'Period started today';

  @override
  String get recordBbt => 'Record BBT';

  @override
  String get recordSymptom => 'Record symptom';

  @override
  String get flowLight => 'Light';

  @override
  String get flowModerate => 'Moderate';

  @override
  String get flowHeavy => 'Heavy';

  @override
  String get flowVeryHeavy => 'Very heavy';

  @override
  String get flowUnrecorded => 'Not recorded';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsAbout => 'About';

  @override
  String get mnemonicFingerprint => 'Mnemonic fingerprint';

  @override
  String get mnemonicFingerprintSubtitle =>
      'Verify your written mnemonic is correct';

  @override
  String get cloudSync => 'Cloud sync';

  @override
  String get cloudSyncSubtitle =>
      'Off by default. v2.0 enables encrypted cloud backup';

  @override
  String get exportJson => 'Export data (JSON)';

  @override
  String get exportJsonSubtitle =>
      'Data portability right, migrate to other devices';

  @override
  String get exportPdf => 'Export report (PDF)';

  @override
  String get exportPdfSubtitle => 'Doctor-friendly, printable for consultation';

  @override
  String get purgeAll => 'Destroy all data (cancel)';

  @override
  String get purgeAllSubtitle =>
      'Irreversible. Local data + credentials all cleared';

  @override
  String get openSource => 'Open source';

  @override
  String get openSourceSubtitle => 'View source + third-party security audit';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get algorithmInfo => 'Prediction algorithm';

  @override
  String get algorithmInfoSubtitle =>
      'Statistical prediction, not medical diagnosis';

  @override
  String get purgeConfirmTitle => 'Confirm destroy all data?';

  @override
  String get purgeConfirmBody =>
      'Irreversible:\\n\\n• Local encrypted database deleted\\n• SQLCipher key destroyed\\n• Mnemonic fingerprint cleared\\n• Device identity key destroyed\\n\\nIf cloud backup enabled, send tombstone to backend separately.\\n\\nIf you kept your mnemonic, you can restore on a new device.';

  @override
  String get purgeConfirmAction => 'I confirm destroy';

  @override
  String get purgeDone => 'All data destroyed, app will exit';

  @override
  String get disclaimerPrediction =>
      'Statistical prediction, not medical diagnosis';

  @override
  String get disclaimerPredictionBody =>
      'All predictions on this page are based on historical cycle statistics, not medical diagnosis.\\nAlgorithm is open source auditable. Consult a doctor for health issues.';
}
