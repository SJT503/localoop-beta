import 'app_strings.dart';
import 'models/cycle_models.dart';

class ConfidenceSummary {
  const ConfidenceSummary({
    required this.periodLevel,
    required this.ovulationLevel,
    required this.window,
    required this.reason,
  });

  final String periodLevel;
  final String ovulationLevel;
  final String window;
  final String reason;
}

class CalendarDay {
  const CalendarDay({
    required this.day,
    required this.dateKey,
    this.type = '',
  });

  final int day;
  final String dateKey;
  final String type;
}

String todayKey([DateTime? date]) {
  final d = date ?? DateTime.now();
  final month = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '${d.year}-$month-$day';
}

String dateKey(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

String _addDaysLabel(String dateText, int days) {
  final date = DateTime.parse('${dateText}T00:00:00').add(Duration(days: days));
  return '${date.month}/${date.day}';
}

ConfidenceSummary confidenceSummary(CycleProfile profile, AppStrings strings) {
  if (!profile.completed || profile.lastPeriodStart.isEmpty) {
    return ConfidenceSummary(
      periodLevel: strings.confidenceInitial,
      ovulationLevel: strings.confidenceReference,
      window: '—',
      reason: strings.keepLogging,
    );
  }
  final periodLevel = profile.cycles >= 3 && profile.variance <= 2
      ? strings.confidenceReliable
      : profile.cycles >= 2
          ? strings.confidenceReference
          : strings.confidenceInitial;
  final start =
      _addDaysLabel(profile.lastPeriodStart, profile.cycleLength - profile.variance);
  final end =
      _addDaysLabel(profile.lastPeriodStart, profile.cycleLength + profile.variance);
  return ConfidenceSummary(
    periodLevel: periodLevel,
    ovulationLevel: strings.confidenceReference,
    window: '$start - $end',
    reason: strings.confidenceReason(profile.cycles, profile.variance),
  );
}

int periodDayOnDate(CycleProfile profile, DateTime date) {
  if (!profile.completed || profile.lastPeriodStart.isEmpty) return 0;
  final start = DateTime.parse('${profile.lastPeriodStart}T00:00:00');
  final diff = date.difference(start).inDays + 1;
  if (diff >= 1 && diff <= profile.periodLength + 2) return diff;
  return 0;
}

bool isPeriodDay(CycleProfile profile, DateTime date) {
  if (!profile.completed || profile.lastPeriodStart.isEmpty) return false;
  final start = DateTime.parse('${profile.lastPeriodStart}T00:00:00');
  final diff = date.difference(start).inDays;
  return diff >= 0 && diff < profile.periodLength;
}

bool isFertileWindow(CycleProfile profile, DateTime date) {
  if (!profile.completed || profile.lastPeriodStart.isEmpty) return false;
  final ovulation =
      DateTime.parse('${profile.lastPeriodStart}T00:00:00')
          .add(Duration(days: profile.cycleLength - 14));
  final diff = date.difference(ovulation).inDays;
  return diff >= -2 && diff <= 2;
}

List<CalendarDay> makeCalendarDays({
  required int year,
  required int month,
  required Map<String, DailyRecord> history,
  required CycleProfile profile,
}) {
  final daysInMonth = DateTime(year, month + 1, 0).day;
  return List.generate(daysInMonth, (index) {
    final day = index + 1;
    final date = DateTime(year, month, day);
    final key = dateKey(date);
    if (history.containsKey(key)) {
      return CalendarDay(day: day, dateKey: key, type: 'logged');
    }
    if (isPeriodDay(profile, date)) {
      return CalendarDay(day: day, dateKey: key, type: 'period');
    }
    if (isFertileWindow(profile, date)) {
      return CalendarDay(day: day, dateKey: key, type: 'ovulation');
    }
    return CalendarDay(day: day, dateKey: key);
  });
}

class InsightMetrics {
  const InsightMetrics({
    required this.dataCompleteness,
    required this.cycleStability,
    required this.bbtContinuity,
    required this.symptomContinuity,
    required this.bbtNote,
    required this.symptomNote,
  });

  final double dataCompleteness;
  final double cycleStability;
  final double bbtContinuity;
  final double symptomContinuity;
  final String bbtNote;
  final String symptomNote;
}

InsightMetrics insightMetrics(
  CycleProfile profile,
  Map<String, DailyRecord> history,
  AppStrings strings,
) {
  final dataCompleteness = (profile.cycles / 5).clamp(0.0, 1.0);
  final cycleStability = profile.variance <= 2 ? 0.76 : 0.48;
  final sortedKeys = history.keys.toList()..sort();
  var bbtStreak = 0;
  for (final key in sortedKeys.reversed) {
    final record = history[key]!;
    if (record.bbt > 0) {
      bbtStreak++;
    } else {
      break;
    }
  }
  final bbtContinuity = (bbtStreak / 10).clamp(0.0, 1.0);
  final symptomDays =
      history.values.where((record) => record.symptoms.isNotEmpty).length;
  final symptomContinuity =
      history.isEmpty ? 0.0 : (symptomDays / history.length).clamp(0.0, 1.0);
  final topSymptoms = <String>{};
  for (final record in history.values) {
    topSymptoms.addAll(record.symptoms.take(2).map(strings.normalizeSymptom));
  }
  return InsightMetrics(
    dataCompleteness: dataCompleteness,
    cycleStability: cycleStability,
    bbtContinuity: bbtContinuity,
    symptomContinuity: symptomContinuity,
    bbtNote: bbtStreak >= 10
        ? strings.bbtStreakDays(bbtStreak)
        : strings.bbtOvulationReference,
    symptomNote: topSymptoms.isEmpty
        ? strings.none
        : strings.listJoin(topSymptoms.take(2)),
  );
}

class RankedItem {
  const RankedItem({required this.label, required this.count});

  final String label;
  final int count;
}

class HistoryStats {
  const HistoryStats({
    required this.totalDays,
    required this.symptoms,
    required this.factors,
    required this.topSymptom,
    required this.topFactor,
  });

  final int totalDays;
  final List<RankedItem> symptoms;
  final List<RankedItem> factors;
  final String topSymptom;
  final String topFactor;
}

HistoryStats historyStats(
  Map<String, DailyRecord> history,
  AppStrings strings,
) {
  final list = history.entries.toList();
  List<RankedItem> countValues(String key) {
    final counts = <String, int>{};
    for (final entry in list) {
      final values = key == 'symptoms' ? entry.value.symptoms : entry.value.factors;
      for (final value in values) {
        counts[value] = (counts[value] ?? 0) + 1;
      }
    }
    return counts.entries
        .map((e) => RankedItem(label: e.key, count: e.value))
        .toList()
      ..sort((a, b) => b.count.compareTo(a.count));
  }

  final symptoms = countValues('symptoms');
  final factors = countValues('factors');
  return HistoryStats(
    totalDays: list.length,
    symptoms: symptoms,
    factors: factors,
    topSymptom: symptoms.isEmpty
        ? strings.none
        : strings.topItemCount(
            strings.normalizeSymptom(symptoms.first.label),
            symptoms.first.count,
          ),
    topFactor: factors.isEmpty
        ? strings.none
        : strings.topItemCount(
            strings.normalizeFactor(factors.first.label),
            factors.first.count,
          ),
  );
}

class TrendCardData {
  const TrendCardData({
    required this.title,
    required this.badge,
    required this.body,
    required this.colorValue,
  });

  final String title;
  final String badge;
  final String body;
  final int colorValue;
}

List<TrendCardData> buildTrendCards({
  required HistoryStats stats,
  required ConfidenceSummary confidence,
  required InsightMetrics metrics,
  required AppStrings strings,
}) {
  final symptomItems = strings.listJoin(
    stats.symptoms.take(3).map(
      (item) =>
          '${strings.normalizeSymptom(item.label)}(${item.count})',
    ),
  );
  final factorItems = strings.listJoin(
    stats.factors.take(3).map((item) => strings.normalizeFactor(item.label)),
  );

  return [
    TrendCardData(
      title: strings.trendTitleSymptoms,
      badge: stats.topSymptom,
      body: stats.symptoms.isEmpty
          ? strings.trendSymptomsEmpty
          : strings.trendSymptomsBody(stats.totalDays, symptomItems),
      colorValue: 0xFF7C5CFF,
    ),
    TrendCardData(
      title: strings.trendTitleFactors,
      badge: stats.topFactor,
      body: stats.factors.isEmpty
          ? strings.trendFactorsEmpty
          : strings.trendFactorsBody(factorItems),
      colorValue: 0xFFFFA340,
    ),
    TrendCardData(
      title: strings.trendTitleBbt,
      badge: metrics.bbtNote,
      body: metrics.bbtContinuity >= 0.6
          ? strings.trendBbtGood
          : strings.trendBbtWeak,
      colorValue: 0xFF31B59A,
    ),
    TrendCardData(
      title: strings.trendTitleReminder,
      badge: confidence.window,
      body: strings.trendReminderBody,
      colorValue: 0xFF31B59A,
    ),
  ];
}
