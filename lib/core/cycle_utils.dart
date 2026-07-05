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

ConfidenceSummary confidenceSummary(CycleProfile profile) {
  final periodLevel = profile.cycles >= 3 && profile.variance <= 2
      ? '较可信'
      : profile.cycles >= 2
          ? '参考'
          : '初始估算';
  final start =
      _addDaysLabel(profile.lastPeriodStart, profile.cycleLength - profile.variance);
  final end =
      _addDaysLabel(profile.lastPeriodStart, profile.cycleLength + profile.variance);
  return ConfidenceSummary(
    periodLevel: periodLevel,
    ovulationLevel: '参考',
    window: '$start - $end',
    reason: '基于 ${profile.cycles} 个完整周期，近期波动约 ±${profile.variance} 天',
  );
}

int periodDayOnDate(CycleProfile profile, DateTime date) {
  final start = DateTime.parse('${profile.lastPeriodStart}T00:00:00');
  final diff = date.difference(start).inDays + 1;
  if (diff >= 1 && diff <= profile.periodLength + 2) return diff;
  return 0;
}

bool isPeriodDay(CycleProfile profile, DateTime date) {
  final start = DateTime.parse('${profile.lastPeriodStart}T00:00:00');
  final diff = date.difference(start).inDays;
  return diff >= 0 && diff < profile.periodLength;
}

bool isFertileWindow(CycleProfile profile, DateTime date) {
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

InsightMetrics insightMetrics(CycleProfile profile, Map<String, DailyRecord> history) {
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
    topSymptoms.addAll(record.symptoms.take(2));
  }
  return InsightMetrics(
    dataCompleteness: dataCompleteness,
    cycleStability: cycleStability,
    bbtContinuity: bbtContinuity,
    symptomContinuity: symptomContinuity,
    bbtNote: bbtStreak >= 10 ? '连续 $bbtStreak 天' : '排卵仍参考',
    symptomNote: topSymptoms.isEmpty ? '暂无' : topSymptoms.take(2).join('、'),
  );
}

String formatChineseDate(DateTime date) {
  return '${date.year}年${date.month}月${date.day}日';
}

String formatChineseDateKey(String key) {
  final parts = key.split('-');
  if (parts.length != 3) return key;
  return '${parts[0]}年${int.parse(parts[1])}月${int.parse(parts[2])}日';
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

HistoryStats historyStats(Map<String, DailyRecord> history) {
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
    topSymptom: symptoms.isEmpty ? '暂无' : '${symptoms.first.label} ${symptoms.first.count} 次',
    topFactor: factors.isEmpty ? '暂无' : '${factors.first.label} ${factors.first.count} 次',
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
}) {
  return [
    TrendCardData(
      title: '常见症状',
      badge: stats.topSymptom,
      body: stats.symptoms.isEmpty
          ? '继续记录后，这里会显示最常出现的身体信号。'
          : '过去 ${stats.totalDays} 天记录里，${stats.symptoms.take(3).map((e) => '${e.label}(${e.count})').join('、')} 较常见。',
      colorValue: 0xFF7C5CFF,
    ),
    TrendCardData(
      title: '生活因素',
      badge: stats.topFactor,
      body: stats.factors.isEmpty
          ? '记录熬夜、压力、运动等因素，可观察与症状的关系。'
          : '最常伴随记录的是 ${stats.factors.take(3).map((e) => e.label).join('、')}，仅作生活方式观察。',
      colorValue: 0xFFFFA340,
    ),
    TrendCardData(
      title: '体温连续性',
      badge: metrics.bbtNote,
      body: metrics.bbtContinuity >= 0.6
          ? '基础体温记录较连续，排卵窗口判断会更可靠。'
          : '缺少连续 BBT 时，排卵窗口只适合做身体观察，不建议作为避孕依据。',
      colorValue: 0xFF31B59A,
    ),
    TrendCardData(
      title: '下次提醒',
      badge: confidence.window,
      body: '提前 2 天温和提醒补充用品，并提示热敷或轻运动。',
      colorValue: 0xFF31B59A,
    ),
  ];
}
