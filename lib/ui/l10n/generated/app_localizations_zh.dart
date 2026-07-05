// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Luna';

  @override
  String get tagline => '你的周期数据，永远只有你能解开';

  @override
  String get welcomeTitle => '欢迎使用 Luna';

  @override
  String get welcomeBody =>
      '你的周期数据，永远只有你能解开。\\n\\n• 不需要账号，不收集邮箱手机号\\n• 数据本地加密，云端只存密文\\n• 我们卖不了你的数据，因为我们根本没有\\n• 开源可审计，第三方安全审计报告公开';

  @override
  String get privacyTitle => '我们如何保护你的数据';

  @override
  String get privacyLocalEncrypt => '本地加密';

  @override
  String get privacyLocalEncryptDesc => '所有数据用 AES-256 加密存在你手机里，连我们都读不了';

  @override
  String get privacyNoCloud => '默认不上云';

  @override
  String get privacyNoCloudDesc => '云备份是可选功能，开启后服务器只见密文';

  @override
  String get privacyNoAccount => '无账号';

  @override
  String get privacyNoAccountDesc => '不收集邮箱、手机号、生日、体重。设备生成密钥对作为唯一身份';

  @override
  String get privacyMnemonic => '助记词恢复';

  @override
  String get privacyMnemonicDesc => '24 词助记词派生主密钥。丢了助记词 = 数据永久丢失，请抄写离线保管';

  @override
  String get privacyOpenSource => '开源审计';

  @override
  String get privacyOpenSourceDesc => '源码 + 加密算法公开，第三方安全审计报告公开';

  @override
  String get generateMnemonic => '生成我的助记词';

  @override
  String get mnemonicTitle => '你的 24 词助记词';

  @override
  String get mnemonicWarning => '⚠️ 请立即抄写到纸上离线保管。\\n⚠️ 不要截图、不要拍照、不要发到任何云端。';

  @override
  String get mnemonicConfirmed => '我已抄写完成';

  @override
  String get backupConfirmTitle => '确认你已离线备份';

  @override
  String get backupConfirmBody =>
      '请确认：\\n\\n✓ 我已将助记词抄写在纸上\\n✓ 我没有截图、拍照或保存到任何云端服务\\n✓ 我知道丢失助记词 = 数据永久无法恢复\\n✓ 我知道任何人拿到助记词 + 我的手机 = 能看我的数据';

  @override
  String get backupConfirmAction => '我确认已正确备份';

  @override
  String get mnemonicConfirmTitle => '请输入你的助记词确认';

  @override
  String get mnemonicConfirmHint => '按顺序输入全部 24 个词，用空格分隔';

  @override
  String get verify => '校验';

  @override
  String get mnemonicError => '助记词不正确，请检查';

  @override
  String get setupComplete => '设置完成';

  @override
  String get mnemonicFingerprintLabel => '你的助记词指纹（不泄露助记词本身）：';

  @override
  String get mnemonicFingerprintHint =>
      '这个指纹用于以后校验你抄写的助记词是否正确。\\n可以记下指纹，但不要记下助记词本身到任何云端。';

  @override
  String get startUsing => '开始使用';

  @override
  String get tabHome => 'Luna';

  @override
  String get tabInsights => '周期洞察';

  @override
  String get tabSettings => '设置';

  @override
  String get nextPeriod => '下次经期';

  @override
  String daysLeft(int count) {
    return '还有 $count 天';
  }

  @override
  String get todayMaybeStart => '今天可能开始';

  @override
  String overdueDays(int count) {
    return '已逾期 $count 天';
  }

  @override
  String get predictedOvulation => '预计排卵';

  @override
  String get currentPhase => '当前阶段';

  @override
  String get confidenceHigh => '高';

  @override
  String get confidenceMedium => '中';

  @override
  String get confidenceLow => '低';

  @override
  String get confidenceVeryLow => '很低';

  @override
  String get phaseMenstrual => '月经期';

  @override
  String get phaseFollicular => '卵泡期';

  @override
  String get phaseOvulation => '排卵期';

  @override
  String get phaseLuteal => '黄体期';

  @override
  String get markPeriodStartToday => '今天开始经期';

  @override
  String get recordBbt => '记录基础体温';

  @override
  String get recordSymptom => '记录症状';

  @override
  String get flowLight => '轻微';

  @override
  String get flowModerate => '适中';

  @override
  String get flowHeavy => '较多';

  @override
  String get flowVeryHeavy => '大量';

  @override
  String get flowUnrecorded => '未记录';

  @override
  String get settingsPrivacy => '隐私';

  @override
  String get settingsData => '数据';

  @override
  String get settingsAbout => '关于';

  @override
  String get mnemonicFingerprint => '助记词指纹';

  @override
  String get mnemonicFingerprintSubtitle => '校验你抄写的助记词是否正确';

  @override
  String get cloudSync => '云同步';

  @override
  String get cloudSyncSubtitle => '默认关闭。v2.0 上线加密云备份';

  @override
  String get exportJson => '导出数据（JSON）';

  @override
  String get exportJsonSubtitle => '数据可携带权，可迁移到其他设备';

  @override
  String get exportPdf => '导出报告（PDF）';

  @override
  String get exportPdfSubtitle => '医生友好版，可打印带去就诊';

  @override
  String get purgeAll => '销毁所有数据（注销）';

  @override
  String get purgeAllSubtitle => '不可恢复。本地数据 + 凭证全部清除';

  @override
  String get openSource => '开源代码';

  @override
  String get openSourceSubtitle => '查看源码 + 第三方安全审计报告';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get algorithmInfo => '预测算法说明';

  @override
  String get algorithmInfoSubtitle => '统计预测非医学诊断，了解算法原理';

  @override
  String get purgeConfirmTitle => '确认销毁所有数据？';

  @override
  String get purgeConfirmBody =>
      '此操作不可恢复：\\n\\n• 本地加密数据库将被删除\\n• SQLCipher 密钥将被销毁\\n• 助记词指纹将被清除\\n• 设备身份密钥将被销毁\\n\\n如果你开启了云备份，需另行在后端发起 tombstone 销毁指令。\\n\\n如果你保留了助记词，可以在新设备上恢复云端备份。';

  @override
  String get purgeConfirmAction => '我确认销毁';

  @override
  String get purgeDone => '所有数据已销毁，App 将退出';

  @override
  String get disclaimerPrediction => '统计预测非医学诊断';

  @override
  String get disclaimerPredictionBody =>
      '本页所有预测基于历史周期统计，不是医学诊断。\\n算法开源可审计。如有健康问题请咨询医生。';
}
