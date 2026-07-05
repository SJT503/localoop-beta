class CycleProfile {
  const CycleProfile({
    this.completed = false,
    this.lastPeriodStart = '',
    this.cycleLength = 28,
    this.periodLength = 5,
    this.cycles = 0,
    this.variance = 2,
    this.goal = 'Track cycle',
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
      lastPeriodStart: json['lastPeriodStart'] as String? ?? '',
      cycleLength: (json['cycleLength'] as num?)?.toInt() ?? 28,
      periodLength: (json['periodLength'] as num?)?.toInt() ?? 5,
      cycles: (json['cycles'] as num?)?.toInt() ?? 0,
      variance: (json['variance'] as num?)?.toInt() ?? 2,
      goal: json['goal'] as String? ?? 'Track cycle',
    );
  }
}

class CycleSettings {
  const CycleSettings({
    this.gentleReminder = true,
    this.privacyNotificationMode = true,
    this.hideSensitiveWords = false,
    this.localeCode = 'en',
    this.onboardingCompleted = false,
  });

  final bool gentleReminder;
  final bool privacyNotificationMode;
  final bool hideSensitiveWords;
  final String localeCode;
  final bool onboardingCompleted;

  CycleSettings copyWith({
    bool? gentleReminder,
    bool? privacyNotificationMode,
    bool? hideSensitiveWords,
    String? localeCode,
    bool? onboardingCompleted,
  }) {
    return CycleSettings(
      gentleReminder: gentleReminder ?? this.gentleReminder,
      privacyNotificationMode:
          privacyNotificationMode ?? this.privacyNotificationMode,
      hideSensitiveWords: hideSensitiveWords ?? this.hideSensitiveWords,
      localeCode: localeCode ?? this.localeCode,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'gentleReminder': gentleReminder,
        'privacyNotificationMode': privacyNotificationMode,
        'hideSensitiveWords': hideSensitiveWords,
        'localeCode': localeCode,
        'onboardingCompleted': onboardingCompleted,
      };

  factory CycleSettings.fromJson(Map<String, dynamic> json) {
    return CycleSettings(
      gentleReminder: json['gentleReminder'] as bool? ?? true,
      privacyNotificationMode: json['privacyNotificationMode'] as bool? ?? true,
      hideSensitiveWords: json['hideSensitiveWords'] as bool? ?? false,
      localeCode: json['localeCode'] as String? ?? 'en',
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
    );
  }
}

class DailyRecord {
  const DailyRecord({
    this.flow = 0,
    this.bbt = 0,
    this.mood = '',
    this.symptoms = const [],
    this.factors = const [],
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
      flow: (json['flow'] as num?)?.toInt() ?? 0,
      bbt: (json['bbt'] as num?)?.toDouble() ?? 0,
      mood: json['mood'] as String? ?? '',
      symptoms: (json['symptoms'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      factors: (json['factors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      note: json['note'] as String? ?? '',
    );
  }
}
