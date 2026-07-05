import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../core/beta_links.dart';
import '../../core/cycle_utils.dart';
import '../../core/export_helper.dart';
import '../../core/app_strings.dart';
import '../../core/models/cycle_models.dart';
import '../../core/notifications/reminder_scheduler.dart';
import '../../core/reminder_utils.dart';
import '../../core/storage/cycle_store.dart';
import '../../ui/theme/luna_colors.dart';
import '../../ui/widgets/language_picker_button.dart';
import '../onboarding/onboarding_screen.dart';
import 'widgets/log_sheet.dart';
import 'widgets/profile_sheet.dart';
import 'widgets/record_detail_sheet.dart';

class PeriodTrackingScreen extends StatefulWidget {
  const PeriodTrackingScreen({super.key});

  @override
  State<PeriodTrackingScreen> createState() => _PeriodTrackingScreenState();
}

class _PeriodTrackingScreenState extends State<PeriodTrackingScreen> {
  CycleStore? _store;
  bool _loading = true;
  int _tab = 0;
  late int _calendarYear;
  late int _calendarMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _calendarYear = now.year;
    _calendarMonth = now.month;
    _initStore();
  }

  Future<void> _initStore() async {
    await initReminderService();
    final store = await CycleStore.create();
    if (!mounted) return;
    setState(() {
      _store = store;
      _loading = false;
    });
    if (store.profile.completed) {
      await _syncReminders();
    } else if (store.settings.onboardingCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openProfile(isFirstSetup: true);
      });
    }
  }

  AppStrings get _strings =>
      AppStrings.fromCode(_store?.settings.localeCode ?? 'en');

  void _refresh() => setState(() {});

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _openProfile({bool isFirstSetup = false}) async {
    final store = _store;
    if (store == null) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (_) => ProfileSheet(
        initial: store.profile,
        isFirstSetup: isFirstSetup,
        strings: _strings,
        onSave: (profile) async {
          await store.saveProfile(profile);
          _refresh();
          await _syncReminders();
          _snack(isFirstSetup ? _strings.savedProfile : _strings.updatedProfile);
        },
      ),
    );
  }

  Future<void> _openLog() async {
    final store = _store;
    if (store == null) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LogSheet(
        store: store,
        strings: _strings,
        onSaved: () async {
          _refresh();
          if (!mounted) return;
          Navigator.pop(context);
          _snack(_strings.savedToday);
        },
      ),
    );
  }

  void _onDayTap(String dateKey) {
    final store = _store;
    if (store == null) return;
    final raw = store.recordForDate(dateKey);
    showRecordDetailSheet(
      context: context,
      dateKey: dateKey,
      record: raw == null ? null : _strings.localizeRecord(raw),
      strings: _strings,
      onEdit: () {
        if (dateKey == todayKey()) {
          _openLog();
        } else {
          _snack(_strings.onlyTodayEditable);
        }
      },
    );
  }

  void _shiftCalendarMonth(int delta) {
    var month = _calendarMonth + delta;
    var year = _calendarYear;
    while (month < 1) {
      month += 12;
      year--;
    }
    while (month > 12) {
      month -= 12;
      year++;
    }
    setState(() {
      _calendarMonth = month;
      _calendarYear = year;
    });
  }

  Future<void> _toggleSetting(
    CycleSettings Function(CycleSettings) update, {
    bool notifyReminder = false,
  }) async {
    final store = _store;
    if (store == null) return;
    await store.saveSettings(update(store.settings));
    _refresh();
    await _syncReminders(notify: notifyReminder);
  }

  Future<void> _syncReminders({bool notify = false}) async {
    final store = _store;
    if (store == null) return;
    final scheduled = await syncPeriodReminder(
      profile: store.profile,
      settings: store.settings,
      strings: _strings,
    );
    if (!mounted || !notify || !scheduled) return;
    _snack(_strings.reminderScheduled);
  }

  Future<void> _previewReminder() async {
    final store = _store;
    if (store == null) return;
    if (kIsWeb || !remindersSupported) {
      final preview = buildReminderPreview(
        profile: store.profile,
        settings: store.settings,
        strings: _strings,
      );
      _snack(
        '${_strings.reminderPreviewWeb}\n${preview.title}: ${preview.body}',
      );
      return;
    }
    final sent = await previewReminder(
      settings: store.settings,
      strings: _strings,
    );
    _snack(sent ? _strings.reminderPreviewSent : _strings.reminderPreviewWeb);
  }

  Future<void> _switchLanguage(String localeCode) async {
    await _toggleSetting((s) => s.copyWith(localeCode: localeCode));
  }

  Future<void> _clearAllData() async {
    final store = _store;
    if (store == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_strings.clearDataConfirmTitle),
        content: Text(_strings.clearDataConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_strings.clearDataCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: C.primary),
            onPressed: () => Navigator.pop(context, true),
            child: Text(_strings.clearDataConfirmAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await store.clearAllData();
    _refresh();
    _snack(_strings.clearDataDone);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _openProfile(isFirstSetup: true);
    });
  }

  Future<void> _completeOnboarding() async {
    await _toggleSetting((s) => s.copyWith(onboardingCompleted: true));
    if (!mounted) return;
    final store = _store;
    if (store != null && !store.profile.completed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openProfile(isFirstSetup: true);
      });
    }
  }

  Future<void> _openExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _snack(_strings.couldNotOpenLink);
    }
  }

  Future<void> _exportData() async {
    final store = _store;
    if (store == null) return;
    final json = store.exportJson();
    if (kIsWeb) {
      downloadJsonFile('localoop_backup.json', json);
      _snack(_strings.exportDownloaded);
    } else {
      await Clipboard.setData(ClipboardData(text: json));
      _snack(_strings.exportCopied);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _store == null) {
      return const Scaffold(
        backgroundColor: C.bg,
        body: Center(child: CircularProgressIndicator(color: C.primary)),
      );
    }

    final store = _store!;
    final strings = _strings;
    final todayRecord = strings.localizeRecord(store.todayRecord);

    if (!store.settings.onboardingCompleted) {
      return OnboardingScreen(
        strings: strings,
        localeCode: store.settings.localeCode,
        onSwitchLanguage: _switchLanguage,
        onComplete: _completeOnboarding,
      );
    }

    final confidence = confidenceSummary(store.profile, strings);
    final metrics = insightMetrics(store.profile, store.history, strings);
    final stats = historyStats(store.history, strings);
    final trends = buildTrendCards(
      stats: stats,
      confidence: confidence,
      metrics: metrics,
      strings: strings,
    );
    final reminder = buildReminderPreview(
      profile: store.profile,
      settings: store.settings,
      strings: strings,
    );
    final periodDay = periodDayOnDate(store.profile, DateTime.now());
    final calendarDays = makeCalendarDays(
      year: _calendarYear,
      month: _calendarMonth,
      history: store.history,
      profile: store.profile,
    );

    final pages = [
      _HomePage(
        strings: strings,
        localeCode: store.settings.localeCode,
        profile: store.profile,
        record: todayRecord,
        confidence: confidence,
        periodDay: periodDay,
        calendarDays: makeCalendarDays(
          year: DateTime.now().year,
          month: DateTime.now().month,
          history: store.history,
          profile: store.profile,
        ),
        onLog: _openLog,
        onProfile: () => _openProfile(),
        onCalendar: () => setState(() => _tab = 1),
        onInsight: () => setState(() => _tab = 2),
        onDayTap: _onDayTap,
        onSwitchLanguage: _switchLanguage,
      ),
      _CalendarPage(
        strings: strings,
        confidence: confidence,
        calendarYear: _calendarYear,
        calendarMonth: _calendarMonth,
        calendarDays: calendarDays,
        todayRecord: store.recordForDate(todayKey()) == null
            ? null
            : strings.localizeRecord(store.recordForDate(todayKey())!),
        onLog: _openLog,
        onPrevMonth: () => _shiftCalendarMonth(-1),
        onNextMonth: () => _shiftCalendarMonth(1),
        onDayTap: _onDayTap,
      ),
      _InsightPage(
        strings: strings,
        record: todayRecord,
        confidence: confidence,
        metrics: metrics,
        trends: trends,
        factors: todayRecord.factors,
        onLog: _openLog,
      ),
      _PrivacyPage(
        strings: strings,
        settings: store.settings,
        reminder: reminder,
        onToggleGentle: (v) => _toggleSetting(
          (s) => s.copyWith(gentleReminder: v),
          notifyReminder: v,
        ),
        onTogglePrivacyMode: (v) =>
            _toggleSetting((s) => s.copyWith(privacyNotificationMode: v)),
        onToggleHideSensitive: (v) =>
            _toggleSetting((s) => s.copyWith(hideSensitiveWords: v)),
        onExport: _exportData,
        onClearData: _clearAllData,
        onPreviewReminder: _previewReminder,
        onSendFeedback: () => _openExternalUrl(BetaLinks.feedbackIssue),
        onOpenDataDisclosure: () => _openExternalUrl(BetaLinks.dataDisclosure),
        onOpenWebBeta: () => _openExternalUrl(BetaLinks.webApp),
        onOpenApk: () => _openExternalUrl(BetaLinks.apkRelease),
      ),
    ];

    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(child: pages[_tab]),
      floatingActionButton: _tab == 3
          ? null
          : FloatingActionButton.extended(
              backgroundColor: C.primary,
              foregroundColor: Colors.white,
              onPressed: _openLog,
              icon: const Icon(Icons.add),
              label: Text(strings.logToday),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        backgroundColor: Colors.white,
        indicatorColor: C.blush,
        onDestinationSelected: (value) => setState(() => _tab = value),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: strings.tabHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            label: strings.tabCalendar,
          ),
          NavigationDestination(
            icon: const Icon(Icons.insights_outlined),
            selectedIcon: const Icon(Icons.insights),
            label: strings.tabInsights,
          ),
          NavigationDestination(
            icon: const Icon(Icons.lock_outline),
            selectedIcon: const Icon(Icons.lock),
            label: strings.tabPrivacy,
          ),
        ],
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage({
    required this.strings,
    required this.localeCode,
    required this.profile,
    required this.record,
    required this.confidence,
    required this.periodDay,
    required this.calendarDays,
    required this.onLog,
    required this.onProfile,
    required this.onCalendar,
    required this.onInsight,
    required this.onDayTap,
    required this.onSwitchLanguage,
  });

  final AppStrings strings;
  final String localeCode;
  final CycleProfile profile;
  final DailyRecord record;
  final ConfidenceSummary confidence;
  final int periodDay;
  final List<CalendarDay> calendarDays;
  final VoidCallback onLog;
  final VoidCallback onProfile;
  final VoidCallback onCalendar;
  final VoidCallback onInsight;
  final ValueChanged<String> onDayTap;
  final ValueChanged<String> onSwitchLanguage;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 96),
      children: [
        _Header(
          strings: strings,
          localeCode: localeCode,
          onProfile: onProfile,
          onSwitchLanguage: onSwitchLanguage,
        ),
        const SizedBox(height: 16),
        _Hero(
          strings: strings,
          periodDay: periodDay,
          confidence: confidence,
          onTap: onLog,
        ),
        const SizedBox(height: 16),
        _TodayCard(strings: strings, record: record, onTap: onLog),
        const SizedBox(height: 16),
        _PredictionBasis(strings: strings, confidence: confidence, profile: profile),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _Action(
                icon: Icons.calendar_month,
                title: strings.tabCalendar,
                subtitle: strings.periodFertileWindow,
                color: C.purple,
                onTap: onCalendar,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Action(
                icon: Icons.insights,
                title: strings.tabInsights,
                subtitle: strings.painTemperature,
                color: C.mint,
                onTap: onInsight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _CalendarWidget(
          strings: strings,
          year: DateTime.now().year,
          month: DateTime.now().month,
          days: calendarDays,
          onDayTap: onDayTap,
        ),
        const SizedBox(height: 16),
        _InsightPreview(strings: strings, profile: profile),
      ],
    );
  }
}

class _CalendarPage extends StatelessWidget {
  const _CalendarPage({
    required this.strings,
    required this.confidence,
    required this.calendarYear,
    required this.calendarMonth,
    required this.calendarDays,
    required this.todayRecord,
    required this.onLog,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onDayTap,
  });

  final AppStrings strings;
  final ConfidenceSummary confidence;
  final int calendarYear;
  final int calendarMonth;
  final List<CalendarDay> calendarDays;
  final DailyRecord? todayRecord;
  final VoidCallback onLog;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<String> onDayTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 96),
      children: [
        _PageTitle(
          strings.tabCalendar,
          strings.calendarPageSubtitle,
        ),
        const SizedBox(height: 16),
        _CalendarWidget(
          strings: strings,
          year: calendarYear,
          month: calendarMonth,
          days: calendarDays,
          onDayTap: onDayTap,
          onPrevMonth: onPrevMonth,
          onNextMonth: onNextMonth,
        ),
        const SizedBox(height: 16),
        _PredictionBasis(strings: strings, confidence: confidence),
        if (todayRecord != null) ...[
          const SizedBox(height: 16),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${strings.formatDateKey(todayKey())} ${strings.recordLogSuffix}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: C.text,
                  ),
                ),
                const SizedBox(height: 12),
                _Timeline(
                  Icons.water_drop,
                  strings.flowLabel(todayRecord!.flow),
                  strings.flowChangeHint,
                ),
                if (todayRecord!.symptoms.isNotEmpty)
                  _Timeline(
                    Icons.healing,
                    strings.listJoin(todayRecord!.symptoms),
                    strings.painTrackHint,
                  ),
                _Timeline(
                  Icons.thermostat,
                  '${todayRecord!.bbt.toStringAsFixed(2)}℃',
                  strings.bbtContinuousHint,
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onLog,
                    icon: const Icon(Icons.edit),
                    label: Text(strings.edit),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _InsightPage extends StatelessWidget {
  const _InsightPage({
    required this.strings,
    required this.record,
    required this.confidence,
    required this.metrics,
    required this.trends,
    required this.factors,
    required this.onLog,
  });

  final AppStrings strings;
  final DailyRecord record;
  final ConfidenceSummary confidence;
  final InsightMetrics metrics;
  final List<TrendCardData> trends;
  final List<String> factors;
  final VoidCallback onLog;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 96),
      children: [
        _PageTitle(
          strings.tabInsights,
          strings.insightsPageSubtitle,
        ),
        const SizedBox(height: 16),
        _TodayCard(strings: strings, record: record, onTap: onLog),
        const SizedBox(height: 16),
        _AccuracyCard(strings: strings, confidence: confidence),
        const SizedBox(height: 12),
        _ConfidenceFactors(strings: strings, metrics: metrics),
        const SizedBox(height: 12),
        ...trends.map(
          (trend) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _Trend(
              title: trend.title,
              badge: trend.badge,
              body: trend.body,
              color: Color(trend.colorValue),
            ),
          ),
        ),
        _LocalFactors(strings: strings, factors: factors),
      ],
    );
  }
}

class _PrivacyPage extends StatelessWidget {
  const _PrivacyPage({
    required this.strings,
    required this.settings,
    required this.reminder,
    required this.onToggleGentle,
    required this.onTogglePrivacyMode,
    required this.onToggleHideSensitive,
    required this.onExport,
    required this.onClearData,
    required this.onPreviewReminder,
    required this.onSendFeedback,
    required this.onOpenDataDisclosure,
    required this.onOpenWebBeta,
    required this.onOpenApk,
  });

  final AppStrings strings;
  final CycleSettings settings;
  final ReminderPreview reminder;
  final ValueChanged<bool> onToggleGentle;
  final ValueChanged<bool> onTogglePrivacyMode;
  final ValueChanged<bool> onToggleHideSensitive;
  final VoidCallback onExport;
  final VoidCallback onClearData;
  final VoidCallback onPreviewReminder;
  final VoidCallback onSendFeedback;
  final VoidCallback onOpenDataDisclosure;
  final VoidCallback onOpenWebBeta;
  final VoidCallback onOpenApk;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 96),
      children: [
        _PageTitle(
          strings.privacySettingsTitle,
          strings.privacySettingsSubtitle,
        ),
        const SizedBox(height: 16),
        _PrivacyHero(strings: strings),
        const SizedBox(height: 12),
        _ThreatModelCard(strings: strings),
        const SizedBox(height: 12),
        _FloMigrationCard(strings: strings),
        const SizedBox(height: 16),
        _SettingToggle(
          icon: Icons.notifications_active,
          title: strings.reminderTitle,
          subtitle: reminder.enabled
              ? '${reminder.body} · ${reminder.scheduledLabel}'
              : strings.remindersOff,
          value: settings.gentleReminder,
          onChanged: onToggleGentle,
        ),
        _SettingToggle(
          icon: Icons.sms_failed,
          title: strings.notificationPrivacyMode,
          subtitle: strings.privacyReminderCopy,
          value: settings.privacyNotificationMode,
          onChanged: onTogglePrivacyMode,
        ),
        _SettingToggle(
          icon: Icons.hide_source,
          title: strings.hideSensitiveWords,
          subtitle: strings.hideSensitiveSubtitle,
          value: settings.hideSensitiveWords,
          onChanged: onToggleHideSensitive,
        ),
        const SizedBox(height: 4),
        _SettingAction(
          icon: Icons.notifications_none,
          title: strings.testReminder,
          subtitle: reminder.enabled
              ? reminder.scheduledLabel
              : strings.reminderBody,
          onTap: onPreviewReminder,
        ),
        _SettingAction(
          icon: Icons.ios_share,
          title: strings.exportJsonTitle,
          subtitle: strings.exportJsonSubtitle,
          onTap: onExport,
        ),
        _SettingAction(
          icon: Icons.delete_forever_outlined,
          title: strings.clearDataTitle,
          subtitle: strings.clearDataSubtitle,
          onTap: onClearData,
        ),
        _SettingAction(
          icon: Icons.description_outlined,
          title: strings.dataDisclosureTitle,
          subtitle: strings.dataDisclosureSubtitle,
          onTap: onOpenDataDisclosure,
        ),
        _SettingAction(
          icon: Icons.rate_review_outlined,
          title: strings.sendFeedbackTitle,
          subtitle: strings.sendFeedbackSubtitle,
          onTap: onSendFeedback,
        ),
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.betaLinksTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: C.text,
                ),
              ),
              const SizedBox(height: 8),
              _SettingAction(
                icon: Icons.public,
                title: strings.betaWebLink,
                subtitle: BetaLinks.webApp,
                onTap: onOpenWebBeta,
              ),
              _SettingAction(
                icon: Icons.android,
                title: strings.betaApkLink,
                subtitle: BetaLinks.apkRelease,
                onTap: onOpenApk,
              ),
            ],
          ),
        ),
        _SettingInfo(
          icon: Icons.lock,
          title: strings.localFirstStorage,
          subtitle: strings.localFirstSubtitle,
        ),
        _SettingInfo(
          icon: Icons.visibility_off,
          title: strings.noCommunityFeed,
          subtitle: strings.noCommunitySubtitle,
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.strings,
    required this.localeCode,
    required this.onProfile,
    required this.onSwitchLanguage,
  });

  final AppStrings strings;
  final String localeCode;
  final VoidCallback onProfile;
  final ValueChanged<String> onSwitchLanguage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [C.primary, C.purple]),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.nights_stay, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.appName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: C.text,
                ),
              ),
              Text(
                strings.appTagline,
                style: const TextStyle(fontSize: 12, color: C.soft),
              ),
            ],
          ),
        ),
        LanguagePickerButton(
          strings: strings,
          localeCode: localeCode,
          onSelected: onSwitchLanguage,
        ),
        IconButton(
          icon: const Icon(Icons.tune, color: C.text),
          onPressed: onProfile,
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.strings,
    required this.periodDay,
    required this.confidence,
    required this.onTap,
  });

  final AppStrings strings;
  final int periodDay;
  final ConfidenceSummary confidence;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final inPeriod = periodDay > 0;
    final pillText =
        inPeriod ? strings.periodDayPill(periodDay) : strings.notInPeriod;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6D9B), C.primary, C.purple],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: C.primary.withValues(alpha: .24),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Pill(pillText, light: true),
              const Spacer(),
              const Icon(Icons.lock, color: Colors.white, size: 18),
              const SizedBox(width: 5),
              Text(
                strings.localSaved,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white24,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      inPeriod ? '$periodDay' : '—',
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    Text(
                      strings.dayLabelCaps,
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  '${strings.periodPrediction}：${confidence.periodLevel}\n'
                  '${strings.expectedWindow} ${confidence.window}\n'
                  '${confidence.reason}',
                  style: const TextStyle(
                    color: Colors.white,
                    height: 1.35,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: C.dark,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: onTap,
              icon: const Icon(Icons.water_drop),
              label: Text(strings.logToday),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({
    required this.strings,
    required this.record,
    required this.onTap,
  });

  final AppStrings strings;
  final DailyRecord record;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  strings.todayRecord,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: C.text,
                  ),
                ),
              ),
              TextButton(onPressed: onTap, child: Text(strings.edit)),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  Icons.water_drop,
                  strings.flowShort,
                  strings.flowLabel(record.flow),
                  C.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Metric(
                  Icons.thermostat,
                  strings.bbtShort,
                  '${record.bbt.toStringAsFixed(2)}℃',
                  C.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  Icons.mood,
                  strings.moodShort,
                  record.mood.isEmpty ? strings.none : strings.normalizeMood(record.mood),
                  C.purple,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Metric(
                  Icons.healing,
                  strings.symptomsShort,
                  record.symptoms.isEmpty
                      ? strings.none
                      : strings.listJoin(
                          record.symptoms.map(strings.normalizeSymptom).take(2),
                        ),
                  C.mint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _Metric(
            Icons.local_fire_department,
            strings.factorsShort,
            record.factors.isEmpty
                ? strings.none
                : strings.listJoin(
                    record.factors.map(strings.normalizeFactor).take(3),
                  ),
            C.amber,
          ),
        ],
      ),
    );
  }
}

class _CalendarWidget extends StatelessWidget {
  const _CalendarWidget({
    required this.strings,
    required this.year,
    required this.month,
    required this.days,
    required this.onDayTap,
    this.onPrevMonth,
    this.onNextMonth,
  });

  final AppStrings strings;
  final int year;
  final int month;
  final List<CalendarDay> days;
  final ValueChanged<String> onDayTap;
  final VoidCallback? onPrevMonth;
  final VoidCallback? onNextMonth;

  @override
  Widget build(BuildContext context) {
    final monthLabel = strings.formatMonthYear(year, month);

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (onPrevMonth != null)
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: onPrevMonth,
                ),
              Expanded(
                child: Text(
                  monthLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (onNextMonth != null)
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: onNextMonth,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: days.map((day) {
              final isPeriod = day.type == 'period';
              final isOvulation = day.type == 'ovulation';
              final isLogged = day.type == 'logged';
              final isToday = day.dateKey == todayKey();

              Color bg;
              if (isPeriod) {
                bg = C.primary.withValues(alpha: .18);
              } else if (isOvulation) {
                bg = C.purple.withValues(alpha: .12);
              } else if (isLogged) {
                bg = C.mint.withValues(alpha: .15);
              } else {
                bg = const Color(0xFFFAF7F9);
              }

              return InkWell(
                onTap: () => onDayTap(day.dateKey),
                customBorder: const CircleBorder(),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: bg,
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: isPeriod || isToday ? C.dark : C.text,
                      fontSize: 12,
                      fontWeight: isToday ? FontWeight.w900 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            children: [
              _LegendDot(
                color: Color(0x2EE84B7A),
                label: strings.calendarLegendPeriod,
              ),
              _LegendDot(
                color: Color(0x1F7C5CFF),
                label: strings.calendarLegendFertile,
              ),
              _LegendDot(
                color: Color(0x2631B59A),
                label: strings.calendarLegendLogged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: C.soft, fontSize: 11)),
      ],
    );
  }
}

class _InsightPreview extends StatelessWidget {
  const _InsightPreview({required this.strings, required this.profile});

  final AppStrings strings;
  final CycleProfile profile;

  @override
  Widget build(BuildContext context) {
    final text = strings.insightPreview(profile.cycles);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F1FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: C.text,
          height: 1.35,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PredictionBasis extends StatelessWidget {
  const _PredictionBasis({
    required this.strings,
    required this.confidence,
    this.profile,
  });

  final AppStrings strings;
  final ConfidenceSummary confidence;
  final CycleProfile? profile;

  @override
  Widget build(BuildContext context) {
    final cycles = profile?.cycles;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  strings.predictionBasis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: C.text,
                  ),
                ),
              ),
              _Pill('${strings.periodWord} ${confidence.periodLevel}'),
            ],
          ),
          const SizedBox(height: 12),
          _BasisRow(
            Icons.history,
            cycles != null
                ? strings.cyclesLogged(cycles)
                : confidence.reason,
            strings.moreLogsNarrowWindow,
          ),
          _BasisRow(Icons.timeline, confidence.window, confidence.reason),
          _BasisRow(
            Icons.thermostat,
            strings.ovulationReference,
            strings.withoutBbtContraception,
          ),
        ],
      ),
    );
  }
}

class _ConfidenceFactors extends StatelessWidget {
  const _ConfidenceFactors({required this.strings, required this.metrics});

  final AppStrings strings;
  final InsightMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.confidenceFactors,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: C.text,
            ),
          ),
          const SizedBox(height: 12),
          _FactorBar(
            strings.dataCompleteness,
            metrics.dataCompleteness,
            C.primary,
            '${(metrics.dataCompleteness * 5).round()}/5 ${strings.cyclesUnit}',
          ),
          _FactorBar(
            strings.cycleStability,
            metrics.cycleStability,
            C.purple,
            strings.periodReliable,
          ),
          _FactorBar(
            strings.bbtContinuity,
            metrics.bbtContinuity,
            C.amber,
            metrics.bbtNote,
          ),
          _FactorBar(
            strings.symptomContinuity,
            metrics.symptomContinuity,
            C.mint,
            metrics.symptomNote,
          ),
        ],
      ),
    );
  }
}

class _AccuracyCard extends StatelessWidget {
  const _AccuracyCard({required this.strings, required this.confidence});

  final AppStrings strings;
  final ConfidenceSummary confidence;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  strings.improveForecast,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: C.text,
                  ),
                ),
              ),
              _Pill('${strings.periodWord} ${confidence.periodLevel}'),
            ],
          ),
          const SizedBox(height: 12),
          _AccuracyStep(
            '1',
            strings.log3Cycles,
            strings.log3CyclesDetail,
          ),
          _AccuracyStep(
            '2',
            strings.addFlowDaily,
            strings.addFlowDailyDetail,
          ),
          _AccuracyStep(
            '3',
            strings.logBbtFixed,
            strings.logBbtFixedDetail,
          ),
        ],
      ),
    );
  }
}

class _LocalFactors extends StatelessWidget {
  const _LocalFactors({required this.strings, required this.factors});

  final AppStrings strings;
  final List<String> factors;

  @override
  Widget build(BuildContext context) {
    final allFactors = strings.factorOptions;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.lifestyleFactors,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: C.text,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            strings.todayFactorsRecorded(
              factors.isEmpty
                  ? strings.none
                  : strings.listJoin(
                      factors.map(strings.normalizeFactor),
                    ),
            ),
            style: const TextStyle(color: C.soft, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allFactors.map((t) => _Tag(t)).toList(),
          ),
          const SizedBox(height: 10),
          Text(
            strings.lifestyleFactorsDisclaimer,
            style: const TextStyle(color: C.soft, height: 1.35, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle(this.title, this.subtitle);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: C.text,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(color: C.soft, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w900, color: C.text),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: C.soft, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _Trend extends StatelessWidget {
  const _Trend({
    required this.title,
    required this.badge,
    required this.body,
    required this.color,
  });

  final String title;
  final String badge;
  final String body;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: C.text,
                  ),
                ),
              ),
              _Pill(badge),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: const TextStyle(
              color: C.text,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _BasisRow extends StatelessWidget {
  const _BasisRow(this.icon, this.title, this.subtitle);

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Icon(icon, color: C.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: C.text,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: C.soft, fontSize: 12, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FactorBar extends StatelessWidget {
  const _FactorBar(this.title, this.value, this.color, this.note);

  final String title;
  final double value;
  final Color color;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: C.text,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(note, style: const TextStyle(color: C.soft, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: color.withValues(alpha: .12),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccuracyStep extends StatelessWidget {
  const _AccuracyStep(this.index, this.title, this.subtitle);

  final String index;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: C.blush,
            child: Text(
              index,
              style: const TextStyle(
                color: C.dark,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: C.text,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: C.soft, height: 1.3, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyHero extends StatelessWidget {
  const _PrivacyHero({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: C.text,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified_user, color: Colors.white, size: 32),
          const SizedBox(height: 16),
          Text(
            strings.privacyHeroTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              height: 1.25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            strings.privacyHeroSubtitle,
            style: const TextStyle(color: Colors.white70, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _ThreatModelCard extends StatelessWidget {
  const _ThreatModelCard({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: C.blush,
                child: Icon(Icons.shield_outlined, color: C.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  strings.threatModelTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: C.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...strings.threatModelBullets.map(
            (bullet) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: C.soft)),
                  Expanded(
                    child: Text(
                      bullet,
                      style: const TextStyle(color: C.soft, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloMigrationCard extends StatelessWidget {
  const _FloMigrationCard({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: C.blush,
                child: Icon(Icons.swap_horiz, color: C.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  strings.floMigrationTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: C.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            strings.floMigrationIntro,
            style: const TextStyle(color: C.soft, height: 1.4),
          ),
          const SizedBox(height: 12),
          ...strings.floMigrationSteps.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: C.blush,
                    child: Text(
                      '${entry.key + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: C.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(color: C.text, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingToggle extends StatelessWidget {
  const _SettingToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _Card(
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: C.blush,
              child: Icon(icon, color: C.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: C.text,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: C.soft, height: 1.3),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              activeTrackColor: C.primary.withValues(alpha: .45),
              thumbColor: WidgetStateProperty.resolveWith(
                (states) =>
                    states.contains(WidgetState.selected) ? C.primary : null,
              ),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingAction extends StatelessWidget {
  const _SettingAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: _Card(
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: C.blush,
                child: Icon(icon, color: C.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: C.text,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(color: C.soft, height: 1.3),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: C.soft),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingInfo extends StatelessWidget {
  const _SettingInfo({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _Card(
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: C.blush,
              child: Icon(icon, color: C.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: C.text,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: C.soft, height: 1.3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline(this.icon, this.title, this.subtitle);

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: C.blush,
            child: Icon(icon, color: C.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: C.text,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: C.soft, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric(this.icon, this.label, this.value, this.color);

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: C.soft, fontSize: 12)),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: C.text,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: C.blush,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: C.dark,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .035),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.text, {this.light = false});

  final String text;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: light ? Colors.white.withValues(alpha: .18) : C.blush,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: light ? Colors.white : C.dark,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}
