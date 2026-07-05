import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// 应用名
  ///
  /// In zh, this message translates to:
  /// **'Luna'**
  String get appTitle;

  /// 核心叙事 slogan
  ///
  /// In zh, this message translates to:
  /// **'你的周期数据，永远只有你能解开'**
  String get tagline;

  /// No description provided for @welcomeTitle.
  ///
  /// In zh, this message translates to:
  /// **'欢迎使用 Luna'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In zh, this message translates to:
  /// **'你的周期数据，永远只有你能解开。\\n\\n• 不需要账号，不收集邮箱手机号\\n• 数据本地加密，云端只存密文\\n• 我们卖不了你的数据，因为我们根本没有\\n• 开源可审计，第三方安全审计报告公开'**
  String get welcomeBody;

  /// No description provided for @privacyTitle.
  ///
  /// In zh, this message translates to:
  /// **'我们如何保护你的数据'**
  String get privacyTitle;

  /// No description provided for @privacyLocalEncrypt.
  ///
  /// In zh, this message translates to:
  /// **'本地加密'**
  String get privacyLocalEncrypt;

  /// No description provided for @privacyLocalEncryptDesc.
  ///
  /// In zh, this message translates to:
  /// **'所有数据用 AES-256 加密存在你手机里，连我们都读不了'**
  String get privacyLocalEncryptDesc;

  /// No description provided for @privacyNoCloud.
  ///
  /// In zh, this message translates to:
  /// **'默认不上云'**
  String get privacyNoCloud;

  /// No description provided for @privacyNoCloudDesc.
  ///
  /// In zh, this message translates to:
  /// **'云备份是可选功能，开启后服务器只见密文'**
  String get privacyNoCloudDesc;

  /// No description provided for @privacyNoAccount.
  ///
  /// In zh, this message translates to:
  /// **'无账号'**
  String get privacyNoAccount;

  /// No description provided for @privacyNoAccountDesc.
  ///
  /// In zh, this message translates to:
  /// **'不收集邮箱、手机号、生日、体重。设备生成密钥对作为唯一身份'**
  String get privacyNoAccountDesc;

  /// No description provided for @privacyMnemonic.
  ///
  /// In zh, this message translates to:
  /// **'助记词恢复'**
  String get privacyMnemonic;

  /// No description provided for @privacyMnemonicDesc.
  ///
  /// In zh, this message translates to:
  /// **'24 词助记词派生主密钥。丢了助记词 = 数据永久丢失，请抄写离线保管'**
  String get privacyMnemonicDesc;

  /// No description provided for @privacyOpenSource.
  ///
  /// In zh, this message translates to:
  /// **'开源审计'**
  String get privacyOpenSource;

  /// No description provided for @privacyOpenSourceDesc.
  ///
  /// In zh, this message translates to:
  /// **'源码 + 加密算法公开，第三方安全审计报告公开'**
  String get privacyOpenSourceDesc;

  /// No description provided for @generateMnemonic.
  ///
  /// In zh, this message translates to:
  /// **'生成我的助记词'**
  String get generateMnemonic;

  /// No description provided for @mnemonicTitle.
  ///
  /// In zh, this message translates to:
  /// **'你的 24 词助记词'**
  String get mnemonicTitle;

  /// No description provided for @mnemonicWarning.
  ///
  /// In zh, this message translates to:
  /// **'⚠️ 请立即抄写到纸上离线保管。\\n⚠️ 不要截图、不要拍照、不要发到任何云端。'**
  String get mnemonicWarning;

  /// No description provided for @mnemonicConfirmed.
  ///
  /// In zh, this message translates to:
  /// **'我已抄写完成'**
  String get mnemonicConfirmed;

  /// No description provided for @backupConfirmTitle.
  ///
  /// In zh, this message translates to:
  /// **'确认你已离线备份'**
  String get backupConfirmTitle;

  /// No description provided for @backupConfirmBody.
  ///
  /// In zh, this message translates to:
  /// **'请确认：\\n\\n✓ 我已将助记词抄写在纸上\\n✓ 我没有截图、拍照或保存到任何云端服务\\n✓ 我知道丢失助记词 = 数据永久无法恢复\\n✓ 我知道任何人拿到助记词 + 我的手机 = 能看我的数据'**
  String get backupConfirmBody;

  /// No description provided for @backupConfirmAction.
  ///
  /// In zh, this message translates to:
  /// **'我确认已正确备份'**
  String get backupConfirmAction;

  /// No description provided for @mnemonicConfirmTitle.
  ///
  /// In zh, this message translates to:
  /// **'请输入你的助记词确认'**
  String get mnemonicConfirmTitle;

  /// No description provided for @mnemonicConfirmHint.
  ///
  /// In zh, this message translates to:
  /// **'按顺序输入全部 24 个词，用空格分隔'**
  String get mnemonicConfirmHint;

  /// No description provided for @verify.
  ///
  /// In zh, this message translates to:
  /// **'校验'**
  String get verify;

  /// No description provided for @mnemonicError.
  ///
  /// In zh, this message translates to:
  /// **'助记词不正确，请检查'**
  String get mnemonicError;

  /// No description provided for @setupComplete.
  ///
  /// In zh, this message translates to:
  /// **'设置完成'**
  String get setupComplete;

  /// No description provided for @mnemonicFingerprintLabel.
  ///
  /// In zh, this message translates to:
  /// **'你的助记词指纹（不泄露助记词本身）：'**
  String get mnemonicFingerprintLabel;

  /// No description provided for @mnemonicFingerprintHint.
  ///
  /// In zh, this message translates to:
  /// **'这个指纹用于以后校验你抄写的助记词是否正确。\\n可以记下指纹，但不要记下助记词本身到任何云端。'**
  String get mnemonicFingerprintHint;

  /// No description provided for @startUsing.
  ///
  /// In zh, this message translates to:
  /// **'开始使用'**
  String get startUsing;

  /// No description provided for @tabHome.
  ///
  /// In zh, this message translates to:
  /// **'Luna'**
  String get tabHome;

  /// No description provided for @tabInsights.
  ///
  /// In zh, this message translates to:
  /// **'周期洞察'**
  String get tabInsights;

  /// No description provided for @tabSettings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get tabSettings;

  /// No description provided for @nextPeriod.
  ///
  /// In zh, this message translates to:
  /// **'下次经期'**
  String get nextPeriod;

  /// No description provided for @daysLeft.
  ///
  /// In zh, this message translates to:
  /// **'还有 {count} 天'**
  String daysLeft(int count);

  /// No description provided for @todayMaybeStart.
  ///
  /// In zh, this message translates to:
  /// **'今天可能开始'**
  String get todayMaybeStart;

  /// No description provided for @overdueDays.
  ///
  /// In zh, this message translates to:
  /// **'已逾期 {count} 天'**
  String overdueDays(int count);

  /// No description provided for @predictedOvulation.
  ///
  /// In zh, this message translates to:
  /// **'预计排卵'**
  String get predictedOvulation;

  /// No description provided for @currentPhase.
  ///
  /// In zh, this message translates to:
  /// **'当前阶段'**
  String get currentPhase;

  /// No description provided for @confidenceHigh.
  ///
  /// In zh, this message translates to:
  /// **'高'**
  String get confidenceHigh;

  /// No description provided for @confidenceMedium.
  ///
  /// In zh, this message translates to:
  /// **'中'**
  String get confidenceMedium;

  /// No description provided for @confidenceLow.
  ///
  /// In zh, this message translates to:
  /// **'低'**
  String get confidenceLow;

  /// No description provided for @confidenceVeryLow.
  ///
  /// In zh, this message translates to:
  /// **'很低'**
  String get confidenceVeryLow;

  /// No description provided for @phaseMenstrual.
  ///
  /// In zh, this message translates to:
  /// **'月经期'**
  String get phaseMenstrual;

  /// No description provided for @phaseFollicular.
  ///
  /// In zh, this message translates to:
  /// **'卵泡期'**
  String get phaseFollicular;

  /// No description provided for @phaseOvulation.
  ///
  /// In zh, this message translates to:
  /// **'排卵期'**
  String get phaseOvulation;

  /// No description provided for @phaseLuteal.
  ///
  /// In zh, this message translates to:
  /// **'黄体期'**
  String get phaseLuteal;

  /// No description provided for @markPeriodStartToday.
  ///
  /// In zh, this message translates to:
  /// **'今天开始经期'**
  String get markPeriodStartToday;

  /// No description provided for @recordBbt.
  ///
  /// In zh, this message translates to:
  /// **'记录基础体温'**
  String get recordBbt;

  /// No description provided for @recordSymptom.
  ///
  /// In zh, this message translates to:
  /// **'记录症状'**
  String get recordSymptom;

  /// No description provided for @flowLight.
  ///
  /// In zh, this message translates to:
  /// **'轻微'**
  String get flowLight;

  /// No description provided for @flowModerate.
  ///
  /// In zh, this message translates to:
  /// **'适中'**
  String get flowModerate;

  /// No description provided for @flowHeavy.
  ///
  /// In zh, this message translates to:
  /// **'较多'**
  String get flowHeavy;

  /// No description provided for @flowVeryHeavy.
  ///
  /// In zh, this message translates to:
  /// **'大量'**
  String get flowVeryHeavy;

  /// No description provided for @flowUnrecorded.
  ///
  /// In zh, this message translates to:
  /// **'未记录'**
  String get flowUnrecorded;

  /// No description provided for @settingsPrivacy.
  ///
  /// In zh, this message translates to:
  /// **'隐私'**
  String get settingsPrivacy;

  /// No description provided for @settingsData.
  ///
  /// In zh, this message translates to:
  /// **'数据'**
  String get settingsData;

  /// No description provided for @settingsAbout.
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get settingsAbout;

  /// No description provided for @mnemonicFingerprint.
  ///
  /// In zh, this message translates to:
  /// **'助记词指纹'**
  String get mnemonicFingerprint;

  /// No description provided for @mnemonicFingerprintSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'校验你抄写的助记词是否正确'**
  String get mnemonicFingerprintSubtitle;

  /// No description provided for @cloudSync.
  ///
  /// In zh, this message translates to:
  /// **'云同步'**
  String get cloudSync;

  /// No description provided for @cloudSyncSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'默认关闭。v2.0 上线加密云备份'**
  String get cloudSyncSubtitle;

  /// No description provided for @exportJson.
  ///
  /// In zh, this message translates to:
  /// **'导出数据（JSON）'**
  String get exportJson;

  /// No description provided for @exportJsonSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'数据可携带权，可迁移到其他设备'**
  String get exportJsonSubtitle;

  /// No description provided for @exportPdf.
  ///
  /// In zh, this message translates to:
  /// **'导出报告（PDF）'**
  String get exportPdf;

  /// No description provided for @exportPdfSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'医生友好版，可打印带去就诊'**
  String get exportPdfSubtitle;

  /// No description provided for @purgeAll.
  ///
  /// In zh, this message translates to:
  /// **'销毁所有数据（注销）'**
  String get purgeAll;

  /// No description provided for @purgeAllSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'不可恢复。本地数据 + 凭证全部清除'**
  String get purgeAllSubtitle;

  /// No description provided for @openSource.
  ///
  /// In zh, this message translates to:
  /// **'开源代码'**
  String get openSource;

  /// No description provided for @openSourceSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'查看源码 + 第三方安全审计报告'**
  String get openSourceSubtitle;

  /// No description provided for @privacyPolicy.
  ///
  /// In zh, this message translates to:
  /// **'隐私政策'**
  String get privacyPolicy;

  /// No description provided for @algorithmInfo.
  ///
  /// In zh, this message translates to:
  /// **'预测算法说明'**
  String get algorithmInfo;

  /// No description provided for @algorithmInfoSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'统计预测非医学诊断，了解算法原理'**
  String get algorithmInfoSubtitle;

  /// No description provided for @purgeConfirmTitle.
  ///
  /// In zh, this message translates to:
  /// **'确认销毁所有数据？'**
  String get purgeConfirmTitle;

  /// No description provided for @purgeConfirmBody.
  ///
  /// In zh, this message translates to:
  /// **'此操作不可恢复：\\n\\n• 本地加密数据库将被删除\\n• SQLCipher 密钥将被销毁\\n• 助记词指纹将被清除\\n• 设备身份密钥将被销毁\\n\\n如果你开启了云备份，需另行在后端发起 tombstone 销毁指令。\\n\\n如果你保留了助记词，可以在新设备上恢复云端备份。'**
  String get purgeConfirmBody;

  /// No description provided for @purgeConfirmAction.
  ///
  /// In zh, this message translates to:
  /// **'我确认销毁'**
  String get purgeConfirmAction;

  /// No description provided for @purgeDone.
  ///
  /// In zh, this message translates to:
  /// **'所有数据已销毁，App 将退出'**
  String get purgeDone;

  /// No description provided for @disclaimerPrediction.
  ///
  /// In zh, this message translates to:
  /// **'统计预测非医学诊断'**
  String get disclaimerPrediction;

  /// No description provided for @disclaimerPredictionBody.
  ///
  /// In zh, this message translates to:
  /// **'本页所有预测基于历史周期统计，不是医学诊断。\\n算法开源可审计。如有健康问题请咨询医生。'**
  String get disclaimerPredictionBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
