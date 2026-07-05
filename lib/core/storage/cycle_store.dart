import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/cycle_models.dart';

const _recordKey = 'localoop_record_v1';
const _profileKey = 'localoop_profile_v1';
const _historyKey = 'localoop_history_v1';
const _settingsKey = 'localoop_settings_v1';

const _defaultProfile = CycleProfile();
const _defaultRecord = DailyRecord();

final _seedHistory = <String, DailyRecord>{
  '2026-07-03': _defaultRecord,
  '2026-07-04': const DailyRecord(
    flow: 1,
    bbt: 36.62,
    mood: '敏感',
    symptoms: ['腹痛', '疲惫'],
    factors: ['压力', '热敷'],
  ),
};

class CycleStore {
  CycleStore._(this._prefs);

  final SharedPreferences _prefs;
  late CycleProfile profile;
  late DailyRecord todayRecord;
  late Map<String, DailyRecord> history;
  late CycleSettings settings;

  static Future<CycleStore> create() async {
    final prefs = await SharedPreferences.getInstance();
    final store = CycleStore._(prefs);
    store._load();
    return store;
  }

  void _load() {
    profile = _readProfile();
    todayRecord = _readRecord();
    history = _readHistory();
    settings = _readSettings();
  }

  CycleProfile _readProfile() {
    final raw = _prefs.getString(_profileKey);
    if (raw == null) return _defaultProfile;
    return CycleProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  DailyRecord _readRecord() {
    final raw = _prefs.getString(_recordKey);
    if (raw == null) return _defaultRecord;
    return DailyRecord.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Map<String, DailyRecord> _readHistory() {
    final raw = _prefs.getString(_historyKey);
    if (raw == null) return Map<String, DailyRecord>.from(_seedHistory);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (key, value) => MapEntry(
        key,
        DailyRecord.fromJson(value as Map<String, dynamic>),
      ),
    );
  }

  CycleSettings _readSettings() {
    final raw = _prefs.getString(_settingsKey);
    if (raw == null) return const CycleSettings();
    return CycleSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<CycleProfile> saveProfile(CycleProfile next) async {
    profile = next.copyWith(completed: true);
    await _prefs.setString(_profileKey, jsonEncode(profile.toJson()));
    return profile;
  }

  Future<CycleSettings> saveSettings(CycleSettings next) async {
    settings = next;
    await _prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
    return settings;
  }

  List<HistoryEntry> historyList() {
    final keys = history.keys.toList()..sort();
    return keys
        .map((key) => HistoryEntry(dateKey: key, record: history[key]!))
        .toList()
        .reversed
        .toList();
  }

  Future<DailyRecord> saveRecord(DailyRecord next, {String? dateKey}) async {
    todayRecord = next;
    await _prefs.setString(_recordKey, jsonEncode(todayRecord.toJson()));
    await _saveHistory(dateKey ?? _todayKey(), todayRecord);
    return todayRecord;
  }

  Future<void> _saveHistory(String key, DailyRecord record) async {
    history = {...history, key: record};
    final encoded = history.map((k, v) => MapEntry(k, v.toJson()));
    await _prefs.setString(_historyKey, jsonEncode(encoded));
  }

  String _todayKey() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
  }

  DailyRecord? recordForDate(String key) => history[key];

  String exportJson() {
    return const JsonEncoder.withIndent('  ').convert({
      'profile': profile.toJson(),
      'settings': settings.toJson(),
      'todayRecord': todayRecord.toJson(),
      'history': history.map((k, v) => MapEntry(k, v.toJson())),
      'exportedAt': DateTime.now().toIso8601String(),
      'app': 'Localoop',
    });
  }
}

class HistoryEntry {
  const HistoryEntry({required this.dateKey, required this.record});

  final String dateKey;
  final DailyRecord record;
}
