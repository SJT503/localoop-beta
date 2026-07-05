import 'package:intl/intl.dart';

import 'models/cycle_models.dart';
import 'l10n/string_catalog.dart';
import 'l10n/supported_locales.dart';
import 'l10n/symptom_aliases.dart';

class AppStrings {
  AppStrings(this.locale);

  final String locale;

  factory AppStrings.fromCode(String code) =>
      AppStrings(normalizeLocaleCode(code));

  String _t(String key) => StringCatalog.get(locale, key);
  List<String> _l(String key) => StringCatalog.list(locale, key);

  bool get isEn => locale == 'en';
  bool get isZh => locale == 'zh';

  String get appName => 'Localoop';
  String get appTagline => _t('appTagline');
  String get tabHome => _t('tabHome');
  String get tabCalendar => _t('tabCalendar');
  String get tabInsights => _t('tabInsights');
  String get tabPrivacy => _t('tabPrivacy');
  String get logToday => _t('logToday');
  String get savedToday => _t('savedToday');
  String get savedProfile => _t('savedProfile');
  String get updatedProfile => _t('updatedProfile');
  String get exportCopied => _t('exportCopied');
  String get exportDownloaded => _t('exportDownloaded');
  String get localSaved => _t('localSaved');
  String get inPeriodDay => _t('inPeriodDay');
  String get notInPeriod => _t('notInPeriod');
  String get keepLogging => _t('keepLogging');
  String get periodPrediction => _t('periodPrediction');
  String get expectedWindow => _t('expectedWindow');
  String get varianceDays => _t('varianceDays');
  String get todayRecord => _t('todayRecord');
  String get edit => _t('edit');
  String get recentLogs => _t('recentLogs');
  String get noLogThisDay => _t('noLogThisDay');
  String get reminderTitle => _t('reminderTitle');
  String get reminderBody => _t('reminderBody');
  String get privacyReminderCopy => _t('privacyReminderCopy');
  String get language => _t('language');
  String get goalLabel => _t('goalLabel');
  String get profileCreateTitle => _t('profileCreateTitle');
  String get profileEditTitle => _t('profileEditTitle');
  String get profileCreateSubtitle => _t('profileCreateSubtitle');
  String get profileEditSubtitle => _t('profileEditSubtitle');
  String get profileLastPeriodStart => _t('profileLastPeriodStart');
  String get profileCycleLength => _t('profileCycleLength');
  String get profilePeriodLength => _t('profilePeriodLength');
  String get profileCyclesRecorded => _t('profileCyclesRecorded');
  String get profileVariance => _t('profileVariance');
  String get profileSave => _t('profileSave');
  String get profileUpdate => _t('profileUpdate');
  String get reminderScheduled => _t('reminderScheduled');
  String get reminderPreviewSent => _t('reminderPreviewSent');
  String get reminderPreviewWeb => _t('reminderPreviewWeb');
  String get testReminder => _t('testReminder');
  String get logQuickHint => _t('logQuickHint');
  String get logBack => _t('logBack');
  String get logNext => _t('logNext');
  String get logSave => _t('logSave');
  String get factorDisclaimer => _t('factorDisclaimer');
  String get noteHint => _t('noteHint');
  String get privacyHeroTitle => _t('privacyHeroTitle');
  String get privacyHeroSubtitle => _t('privacyHeroSubtitle');
  String get threatModelTitle => _t('threatModelTitle');
  String get floMigrationTitle => _t('floMigrationTitle');
  String get floMigrationIntro => _t('floMigrationIntro');
  String get sendFeedbackTitle => _t('sendFeedbackTitle');
  String get sendFeedbackSubtitle => _t('sendFeedbackSubtitle');
  String get betaLinksTitle => _t('betaLinksTitle');
  String get betaWebLink => _t('betaWebLink');
  String get betaApkLink => _t('betaApkLink');
  String get privacySettingsTitle => _t('privacySettingsTitle');
  String get privacySettingsSubtitle => _t('privacySettingsSubtitle');
  String get periodFertileWindow => _t('periodFertileWindow');
  String get painTemperature => _t('painTemperature');
  String get recordLogSuffix => _t('recordLogSuffix');
  String get remindersOff => _t('remindersOff');
  String get remindersOffBody => _t('remindersOffBody');
  String get notificationPrivacyMode => _t('notificationPrivacyMode');
  String get hideSensitiveWords => _t('hideSensitiveWords');
  String get hideSensitiveSubtitle => _t('hideSensitiveSubtitle');
  String get exportJsonTitle => _t('exportJsonTitle');
  String get exportJsonSubtitle => _t('exportJsonSubtitle');
  String get localFirstStorage => _t('localFirstStorage');
  String get localFirstSubtitle => _t('localFirstSubtitle');
  String get noCommunityFeed => _t('noCommunityFeed');
  String get noCommunitySubtitle => _t('noCommunitySubtitle');
  String get dayWord => _t('dayWord');
  String get flowShort => _t('flowShort');
  String get bbtShort => _t('bbtShort');
  String get moodShort => _t('moodShort');
  String get symptomsShort => _t('symptomsShort');
  String get none => _t('none');
  String get factorsShort => _t('factorsShort');
  String get predictionBasis => _t('predictionBasis');
  String get periodWord => _t('periodWord');
  String get ovulationReference => _t('ovulationReference');
  String get confidenceFactors => _t('confidenceFactors');
  String get dataCompleteness => _t('dataCompleteness');
  String get cyclesUnit => _t('cyclesUnit');
  String get cycleStability => _t('cycleStability');
  String get periodReliable => _t('periodReliable');
  String get bbtContinuity => _t('bbtContinuity');
  String get symptomContinuity => _t('symptomContinuity');
  String get improveForecast => _t('improveForecast');
  String get log3Cycles => _t('log3Cycles');
  String get addFlowDaily => _t('addFlowDaily');
  String get logBbtFixed => _t('logBbtFixed');
  String get lifestyleFactors => _t('lifestyleFactors');
  String get couldNotOpenLink => _t('couldNotOpenLink');
  String get onlyTodayEditable => _t('onlyTodayEditable');
  String get aroundDate => _t('aroundDate');
  String get periodSuppliesReminder => _t('periodSuppliesReminder');
  String get predictedWindowStarts => _t('predictedWindowStarts');

  List<String> get goalOptions => _l('goalOptions');
  List<String> get logStepTitles => _l('logStepTitles');
  List<String> get symptomOptions => _l('symptomOptions');
  List<String> get factorOptions => _l('factorOptions');
  List<String> get moodOptions => _l('moodOptions');
  List<String> get threatModelBullets => _l('threatModelBullets');
  List<String> get floMigrationSteps => _l('floMigrationSteps');

  List<({int level, String title, String subtitle})> get flowOptions => [
        (
          level: 1,
          title: _t('flow1Title'),
          subtitle: _t('flow1Sub'),
        ),
        (
          level: 2,
          title: _t('flow2Title'),
          subtitle: _t('flow2Sub'),
        ),
        (
          level: 3,
          title: _t('flow3Title'),
          subtitle: _t('flow3Sub'),
        ),
        (
          level: 4,
          title: _t('flow4Title'),
          subtitle: _t('flow4Sub'),
        ),
      ];

  String get calendarPageSubtitle => _t('calendarPageSubtitle');
  String get insightsPageSubtitle => _t('insightsPageSubtitle');
  String get flowChangeHint => _t('flowChangeHint');
  String get painTrackHint => _t('painTrackHint');
  String get bbtContinuousHint => _t('bbtContinuousHint');
  String get moreLogsNarrowWindow => _t('moreLogsNarrowWindow');
  String get withoutBbtContraception => _t('withoutBbtContraception');
  String get log3CyclesDetail => _t('log3CyclesDetail');
  String get addFlowDailyDetail => _t('addFlowDailyDetail');
  String get logBbtFixedDetail => _t('logBbtFixedDetail');
  String get lifestyleFactorsDisclaimer => _t('lifestyleFactorsDisclaimer');
  String get dayPrefix => _t('dayPrefix');
  String get daySuffix => _t('daySuffix');
  String get dayLabelCaps => _t('dayLabelCaps');
  String get confidenceReliable => _t('confidenceReliable');
  String get confidenceReference => _t('confidenceReference');
  String get confidenceInitial => _t('confidenceInitial');
  String get calendarLegendPeriod => _t('calendarLegendPeriod');
  String get calendarLegendFertile => _t('calendarLegendFertile');
  String get calendarLegendLogged => _t('calendarLegendLogged');
  String get bbtOvulationReference => _t('bbtOvulationReference');
  String get trendTitleSymptoms => _t('trendTitleSymptoms');
  String get trendTitleFactors => _t('trendTitleFactors');
  String get trendTitleBbt => _t('trendTitleBbt');
  String get trendTitleReminder => _t('trendTitleReminder');
  String get trendSymptomsEmpty => _t('trendSymptomsEmpty');
  String get trendFactorsEmpty => _t('trendFactorsEmpty');
  String get trendBbtGood => _t('trendBbtGood');
  String get trendBbtWeak => _t('trendBbtWeak');
  String get trendReminderBody => _t('trendReminderBody');
  String get onboardingTitle1 => _t('onboardingTitle1');
  String get onboardingBody1 => _t('onboardingBody1');
  String get onboardingTitle2 => _t('onboardingTitle2');
  String get onboardingBody2 => _t('onboardingBody2');
  String get onboardingTitle3 => _t('onboardingTitle3');
  String get onboardingBody3 => _t('onboardingBody3');
  String get onboardingNext => _t('onboardingNext');
  String get onboardingStart => _t('onboardingStart');
  String get clearDataTitle => _t('clearDataTitle');
  String get clearDataSubtitle => _t('clearDataSubtitle');
  String get clearDataConfirmTitle => _t('clearDataConfirmTitle');
  String get clearDataConfirmBody => _t('clearDataConfirmBody');
  String get clearDataConfirmAction => _t('clearDataConfirmAction');
  String get clearDataCancel => _t('clearDataCancel');
  String get clearDataDone => _t('clearDataDone');
  String get dataDisclosureTitle => _t('dataDisclosureTitle');
  String get dataDisclosureSubtitle => _t('dataDisclosureSubtitle');

  String confidenceReason(int cycles, int variance) => _t('confidenceReason')
      .replaceAll('{cycles}', '$cycles')
      .replaceAll('{variance}', '$variance');

  String topItemCount(String label, int count) => _t('topItemCount')
      .replaceAll('{label}', label)
      .replaceAll('{count}', '$count');

  String bbtStreakDays(int days) =>
      _t('bbtStreakDays').replaceAll('{days}', '$days');

  String trendSymptomsBody(int days, String items) => _t('trendSymptomsBody')
      .replaceAll('{days}', '$days')
      .replaceAll('{items}', items);

  String trendFactorsBody(String items) =>
      _t('trendFactorsBody').replaceAll('{items}', items);

  String formatMonthYear(int year, int month) {
    if (locale == 'zh') {
      return '$year年$month月';
    }
    try {
      return DateFormat.yMMMM(locale).format(DateTime(year, month));
    } catch (_) {
      return DateFormat.yMMMM('en').format(DateTime(year, month));
    }
  }

  String cyclesLogged(int cycles) =>
      _t('cyclesLogged').replaceAll('{cycles}', '$cycles');

  String insightPreview(int cycles) =>
      _t('insightPreview').replaceAll('{cycles}', '$cycles');

  String todayFactorsRecorded(String list) =>
      _t('todayFactorsRecorded').replaceAll('{list}', list);

  String periodDayPill(int day) {
    if (dayPrefix.isNotEmpty) {
      return '$inPeriodDay · $dayPrefix$day$daySuffix'.trim();
    }
    if (daySuffix.isNotEmpty) {
      return '$inPeriodDay · $day$daySuffix';
    }
    return '$inPeriodDay · $dayWord $day';
  }

  String normalizeSymptom(String value) =>
      _normalizeListValue('symptomOptions', value);

  String normalizeFactor(String value) =>
      _normalizeListValue('factorOptions', value);

  String normalizeMood(String value) => _normalizeListValue('moodOptions', value);

  String _normalizeListValue(String listKey, String value) {
    if (value.isEmpty) return value;
    final target = _l(listKey);
    for (final item in supportedLocales) {
      final options = StringCatalog.list(item.code, listKey);
      final index = options.indexOf(value);
      if (index >= 0 && index < target.length) {
        return target[index];
      }
    }
    final aliasIndex = _aliasIndex(listKey, value);
    if (aliasIndex != null && aliasIndex < target.length) {
      return target[aliasIndex];
    }
    return value;
  }

  int? _aliasIndex(String listKey, String value) {
    switch (listKey) {
      case 'symptomOptions':
        return symptomAliasToIndex[value];
      case 'factorOptions':
        return factorAliasToIndex[value];
      case 'moodOptions':
        return moodAliasToIndex[value];
      default:
        return null;
    }
  }

  DailyRecord localizeRecord(DailyRecord record) {
    return DailyRecord(
      flow: record.flow,
      bbt: record.bbt,
      mood: record.mood.isEmpty ? record.mood : normalizeMood(record.mood),
      symptoms: record.symptoms.map(normalizeSymptom).toList(),
      factors: record.factors.map(normalizeFactor).toList(),
      note: record.note,
    );
  }

  String normalizeGoal(String goal) {
    const canonicalEn = ['Track cycle', 'Fertility watch', 'Ease cramps'];
    const canonicalZh = ['记录周期', '备孕观察', '改善痛经'];
    for (var i = 0; i < canonicalEn.length; i++) {
      for (final locale in supportedLocales) {
        final options = StringCatalog.list(locale.code, 'goalOptions');
        if (i < options.length &&
            (goal == options[i] ||
                goal == canonicalEn[i] ||
                goal == canonicalZh[i])) {
          return goalOptions[i];
        }
      }
    }
    return goalOptions.first;
  }

  String formatDate(DateTime date) {
    if (locale == 'zh') {
      return '${date.year}年${date.month}月${date.day}日';
    }
    try {
      return DateFormat.yMMMd(locale).format(date);
    } catch (_) {
      return DateFormat.yMMMd('en').format(date);
    }
  }

  String formatDateKey(String key) {
    final parts = key.split('-');
    if (parts.length != 3) return key;
    final date = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    return formatDate(date);
  }

  String listJoin(Iterable<String> values) =>
      values.join(_t('listSeparator'));

  String bbtLabel(double value) =>
      '${_t('basalTempLabel')} ${value.toStringAsFixed(2)}°C';

  String flowLabel(int flow) {
    final labels = [
      _t('flowNone'),
      _t('flowLight'),
      _t('flowMedium'),
      _t('flowHeavy'),
      _t('flowVeryHeavy'),
    ];
    return labels[flow.clamp(0, labels.length - 1)];
  }
}
