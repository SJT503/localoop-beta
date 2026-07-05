class CycleProfile {
  const CycleProfile({
    this.completed = false,
    this.lastPeriodStart = '2026-07-02',
    this.cycleLength = 29,
    this.periodLength = 5,
    this.cycles = 3,
    this.variance = 2,
    this.goal = '记录周期',
  });

  final bool completed;
  final String lastPeriodStart;
  final int cycleLength;
  final int periodLength;
  final int cycles;
  final int variance;
  final String goal;

  CycleProfile copyWith({
    bool? completed,
    String? lastPeriodStart,
    int? cycleLength,
    int? periodLength,
    int? cycles,
    int? variance,
    String? goal,
  }) {
    return CycleProfile(
      completed: completed ?? this.completed,
      lastPeriodStart: lastPeriodStart ?? this.lastPeriodStart,
      cycleLength: cycleLength ?? this.cycleLength,
      periodLength: periodLength ?? this.periodLength,
      cycles: cycles ?? this.cycles,
      variance: variance ?? this.variance,
      goal: goal ?? this.goal,
    );
  }

  Map<String, dynamic> toJson() => {
        'completed': completed,
        'lastPeriodStart': lastPeriodStart,
        'cycleLength': cycleLength,
        'periodLength': periodLength,
        'cycles': cycles,
        'variance': variance,
        'goal': goal,
      };

  factory CycleProfile.fromJson(Map<String, dynamic> json) {
    return CycleProfile(
      completed: json['completed'] as bool? ?? false,
      lastPeriodStart: json['lastPeriodStart'] as String? ?? '2026-07-02',
      cycleLength: (json['cycleLength'] as num?)?.toInt() ?? 29,
      periodLength: (json['periodLength'] as num?)?.toInt() ?? 5,
      cycles: (json['cycles'] as num?)?.toInt() ?? 3,
      variance: (json['variance'] as num?)?.toInt() ?? 2,
      goal: json['goal'] as String? ?? '记录周期',
    );
  }
}

class CycleSettings {
  const CycleSettings({
    this.gentleReminder = true,
    this.privacyNotificationMode = true,
    this.hideSensitiveWords = false,
    this.localeCode = 'en',
  });

  final bool gentleReminder;
  final bool privacyNotificationMode;
  final bool hideSensitiveWords;
  final String localeCode;

  CycleSettings copyWith({
    bool? gentleReminder,
    bool? privacyNotificationMode,
    bool? hideSensitiveWords,
    String? localeCode,
  }) {
    return CycleSettings(
      gentleReminder: gentleReminder ?? this.gentleReminder,
      privacyNotificationMode:
          privacyNotificationMode ?? this.privacyNotificationMode,
      hideSensitiveWords: hideSensitiveWords ?? this.hideSensitiveWords,
      localeCode: localeCode ?? this.localeCode,
    );
  }

  Map<String, dynamic> toJson() => {
        'gentleReminder': gentleReminder,
        'privacyNotificationMode': privacyNotificationMode,
        'hideSensitiveWords': hideSensitiveWords,
        'localeCode': localeCode,
      };

  factory CycleSettings.fromJson(Map<String, dynamic> json) {
    return CycleSettings(
      gentleReminder: json['gentleReminder'] as bool? ?? true,
      privacyNotificationMode: json['privacyNotificationMode'] as bool? ?? true,
      hideSensitiveWords: json['hideSensitiveWords'] as bool? ?? false,
      localeCode: json['localeCode'] as String? ?? 'en',
    );
  }
}

class DailyRecord {
  const DailyRecord({
    this.flow = 2,
    this.bbt = 36.58,
    this.mood = '平静',
    this.symptoms = const ['腹痛', '腰酸'],
    this.factors = const ['熬夜', '热敷'],
    this.note = '',
  });

  final int flow;
  final double bbt;
  final String mood;
  final List<String> symptoms;
  final List<String> factors;
  final String note;

  DailyRecord copyWith({
    int? flow,
    double? bbt,
    String? mood,
    List<String>? symptoms,
    List<String>? factors,
    String? note,
  }) {
    return DailyRecord(
      flow: flow ?? this.flow,
      bbt: bbt ?? this.bbt,
      mood: mood ?? this.mood,
      symptoms: symptoms ?? List<String>.from(this.symptoms),
      factors: factors ?? List<String>.from(this.factors),
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() => {
        'flow': flow,
        'bbt': bbt,
        'mood': mood,
        'symptoms': symptoms,
        'factors': factors,
        'note': note,
      };

  factory DailyRecord.fromJson(Map<String, dynamic> json) {
    return DailyRecord(
      flow: (json['flow'] as num?)?.toInt() ?? 2,
      bbt: (json['bbt'] as num?)?.toDouble() ?? 36.58,
      mood: json['mood'] as String? ?? '平静',
      symptoms: (json['symptoms'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['腹痛', '腰酸'],
      factors: (json['factors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['熬夜', '热敷'],
      note: json['note'] as String? ?? '',
    );
  }
}
