import 'package:intl/intl.dart';

class AppStrings {
  AppStrings(this.locale);

  final String locale;

  factory AppStrings.fromCode(String code) =>
      AppStrings(code.startsWith('en') ? 'en' : 'zh');

  bool get isEn => locale == 'en';

  String get appName => 'Localoop';

  String get appTagline => isEn
      ? 'Private, lightweight period assistant'
      : '私密、轻量、中文友好的周期助手';

  String get tabHome => isEn ? 'Home' : '首页';
  String get tabCalendar => isEn ? 'Calendar' : '日历';
  String get tabInsights => isEn ? 'Insights' : '洞察';
  String get tabPrivacy => isEn ? 'Privacy' : '隐私';
  String get logToday => isEn ? 'Log today' : '记录今天';
  String get savedToday => isEn ? 'Saved for today' : '已保存今日记录';
  String get savedProfile => isEn ? 'Profile saved' : '已建立周期档案';
  String get updatedProfile => isEn ? 'Profile updated' : '已更新周期档案';
  String get exportCopied =>
      isEn ? 'JSON copied to clipboard' : '数据已复制到剪贴板，可粘贴备份';
  String get exportDownloaded =>
      isEn ? 'Backup file downloaded' : '备份文件已下载';
  String get localSaved => isEn ? 'Saved locally' : '本地保存';
  String get inPeriodDay => isEn ? 'Period day' : '经期中';
  String get notInPeriod => isEn ? 'Not in period' : '非经期';
  String get keepLogging => isEn ? 'Keep logging' : '继续记录';
  String get periodPrediction => isEn ? 'Period forecast' : '经期预测';
  String get expectedWindow => isEn ? 'Expected window' : '预计窗口';
  String get varianceDays => isEn ? 'variance about ±2 days' : '波动约 ±2 天';
  String get todayRecord => isEn ? 'Today' : '今日记录';
  String get edit => isEn ? 'Edit' : '编辑';
  String get recentLogs => isEn ? 'Recent logs' : '最近记录';
  String get noLogThisDay => isEn ? 'No log for this day yet' : '这天还没有记录';
  String get reminderTitle => isEn ? 'Gentle reminder' : '温和提醒';
  String get reminderBody => isEn
      ? 'We will nudge you 2 days before the predicted window.'
      : '将在预测窗口前 2 天温和提醒补充用品。';
  String get privacyReminderCopy => isEn
      ? 'Remember to log how you feel today'
      : '今天记一下身体状态';
  String get language => isEn ? 'Language' : '界面语言';
  String get languageZh => '中文';
  String get languageEn => 'English';
  String get goalLabel => isEn ? 'Your goal' : '使用目标';
  List<String> get goalOptions => isEn
      ? ['Track cycle', 'Fertility watch', 'Ease cramps']
      : ['记录周期', '备孕观察', '改善痛经'];

  String get profileCreateTitle =>
      isEn ? 'Create cycle profile' : '建立周期档案';
  String get profileEditTitle =>
      isEn ? 'Edit cycle profile' : '编辑周期档案';
  String get profileCreateSubtitle =>
      isEn ? 'One-time setup for better forecasts' : '只需一次，预测会更准';
  String get profileEditSubtitle => isEn
      ? 'Updates refresh calendar and insights'
      : '更新后预测和日历会同步刷新';
  String get profileLastPeriodStart =>
      isEn ? 'Last period start (YYYY-MM-DD)' : '最近一次经期开始 (YYYY-MM-DD)';
  String get profileCycleLength =>
      isEn ? 'Average cycle (days)' : '平均周期（天）';
  String get profilePeriodLength =>
      isEn ? 'Period length (days)' : '经期长度（天）';
  String get profileCyclesRecorded =>
      isEn ? 'Cycles logged' : '已记录周期数';
  String get profileVariance => isEn ? 'Variance (±days)' : '波动（±天）';
  String get profileSave => isEn ? 'Save profile' : '保存档案';
  String get profileUpdate => isEn ? 'Update profile' : '更新档案';
  String get reminderScheduled => isEn
      ? 'Next gentle reminder scheduled'
      : '已安排下次温和提醒';
  String get reminderPreviewSent => isEn
      ? 'Preview notification sent'
      : '已发送预览通知';
  String get reminderPreviewWeb => isEn
      ? 'Web demo: notification preview shown in-app'
      : 'Web 演示：已在应用内显示提醒预览';
  String get testReminder => isEn ? 'Preview reminder' : '预览提醒';

  String normalizeGoal(String goal) {
    const pairs = [
      ('记录周期', 'Track cycle'),
      ('备孕观察', 'Fertility watch'),
      ('改善痛经', 'Ease cramps'),
    ];
    for (final pair in pairs) {
      if (goal == pair.$1 || goal == pair.$2) {
        return isEn ? pair.$2 : pair.$1;
      }
    }
    return goalOptions.first;
  }

  String formatDate(DateTime date) {
    if (isEn) {
      return DateFormat.yMMMd('en').format(date);
    }
    return '${date.year}年${date.month}月${date.day}日';
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
      values.join(isEn ? ', ' : '、');

  List<String> get logStepTitles => isEn
      ? [
          'How is your flow today?',
          'Any body signals?',
          'Lifestyle factors today?',
          'Mood and basal temperature',
          'Add a short note',
        ]
      : [
          '今天的月经流量？',
          '有什么身体信号？',
          '今天有哪些影响因素？',
          '心情和基础体温',
          '补一句备注',
        ];

  String get logQuickHint => isEn ? '~20 seconds' : '约 20 秒完成';
  String get logBack => isEn ? 'Back' : '上一步';
  String get logNext => isEn ? 'Next' : '继续';
  String get logSave => isEn ? 'Save today' : '保存今日记录';
  String get factorDisclaimer => isEn
      ? 'For lifestyle observation only, not medical diagnosis.'
      : '用于观察生活方式与症状的关系，不做医学诊断。';
  String get noteHint => isEn
      ? 'e.g. when pain started, sleep quality...'
      : '比如：疼痛什么时候开始、睡眠如何……';
  String bbtLabel(double value) =>
      isEn ? 'Basal temp ${value.toStringAsFixed(2)}°C' : '基础体温 ${value.toStringAsFixed(2)}℃';

  List<String> get symptomOptions => isEn
      ? [
          'Cramping',
          'Back ache',
          'Breast tenderness',
          'Fatigue',
          'Headache',
          'Acne',
          'Bloating',
          'Appetite change',
        ]
      : ['腹痛', '腰酸', '乳房胀痛', '疲惫', '头痛', '痘痘', '腹胀', '食欲变化'];

  List<String> get factorOptions => isEn
      ? ['Late night', 'Stress', 'Cold drinks', 'Exercise', 'Painkiller', 'Heat pack']
      : ['熬夜', '压力', '冷饮', '运动强度', '止痛药', '热敷'];

  List<String> get moodOptions =>
      isEn ? ['Happy', 'Calm', 'Sensitive', 'Anxious', 'Tired'] : ['开心', '平静', '敏感', '焦虑', '疲惫'];

  List<({int level, String title, String subtitle})> get flowOptions => isEn
      ? [
          (level: 1, title: 'Light', subtitle: 'Spotting or liner'),
          (level: 2, title: 'Medium', subtitle: 'Normal changes'),
          (level: 3, title: 'Heavy', subtitle: 'More frequent changes'),
          (level: 4, title: 'Very heavy', subtitle: 'Clearly heavy'),
        ]
      : [
          (level: 1, title: '轻微', subtitle: '点滴或护垫'),
          (level: 2, title: '适中', subtitle: '正常更换'),
          (level: 3, title: '较多', subtitle: '更频繁更换'),
          (level: 4, title: '大量', subtitle: '明显偏多'),
        ];

  String flowLabel(int flow) {
    final labels = isEn
        ? ['None', 'Light', 'Medium', 'Heavy', 'Very heavy']
        : ['未记录', '轻微', '适中', '较多', '大量'];
    return labels[flow.clamp(0, labels.length - 1)];
  }

  String get privacyHeroTitle => isEn
      ? 'Not another feed — your private cycle assistant.'
      : '不是另一个内容社区，而是你的私密周期助理。';

  String get privacyHeroSubtitle => isEn
      ? 'Local-first by default: no account, no cloud sync, no ads.'
      : '默认本地优先：无账号、无云端同步、无广告流。';

  String get threatModelTitle =>
      isEn ? 'How Localoop handles your data' : 'Localoop 如何处理你的数据';

  List<String> get threatModelBullets => isEn
      ? [
          'Stored on this device only — we never receive your cycle history.',
          'No sign-in required; uninstalling removes local data from this device.',
          'Export JSON anytime; you own the file.',
        ]
      : [
          '数据只存在本设备，我们不会收到你的周期记录。',
          '无需注册；卸载即从本机删除本地数据。',
          '随时 JSON 导出，文件归你所有。',
        ];

  String get floMigrationTitle =>
      isEn ? 'Leaving Flo or Clue?' : '正在离开 Flo 或 Clue？';

  String get floMigrationIntro => isEn
      ? 'Three steps many privacy guides recommend before switching:'
      : '多数隐私指南建议换 App 前先做这三步：';

  List<String> get floMigrationSteps => isEn
      ? [
          'In Flo: Settings → Privacy → Request My Data. Save the export email.',
          'Delete your Flo account (not just uninstall) so server copies are removed.',
          'In Localoop: create your profile with your last period start date, then keep logging.',
        ]
      : [
          '在 Flo：设置 → 隐私 → 申请我的数据，保存导出的邮件。',
          '删除 Flo 账号（不只是卸载），让服务器上的副本被清除。',
          '在 Localoop：用最近一次经期开始日建立档案，然后继续每日记录。',
        ];

  String get sendFeedbackTitle =>
      isEn ? 'Send beta feedback' : '发送测试反馈';

  String get sendFeedbackSubtitle => isEn
      ? 'Opens a short GitHub form (no app data uploaded)'
      : '打开 GitHub 简短反馈表（不会上传 App 内数据）';

  String get betaLinksTitle => isEn ? 'Beta links' : '测试版链接';

  String get betaWebLink => isEn ? 'Web beta URL' : '网页测试地址';

  String get betaApkLink => isEn ? 'Android APK download' : 'Android 安装包下载';
}
