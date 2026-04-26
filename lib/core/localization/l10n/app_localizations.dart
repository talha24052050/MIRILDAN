import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In tr, this message translates to:
  /// **'Mırıldan'**
  String get appName;

  /// No description provided for @onboarding1Title.
  ///
  /// In tr, this message translates to:
  /// **'Mırıldan\'a\nHoş Geldin.'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Duygularını yakala, takip etme.'**
  String get onboarding1Subtitle;

  /// No description provided for @onboarding2Title.
  ///
  /// In tr, this message translates to:
  /// **'Konuş ya da yaz,\nbir renk seç.'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Her şey senin tempondan, sen istediğinde.'**
  String get onboarding2Subtitle;

  /// No description provided for @onboarding3Title.
  ///
  /// In tr, this message translates to:
  /// **'Her şey senin\nkontrolünde.'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtların sadece senin cihazında.\nHesap açmak isteğe bağlı.'**
  String get onboarding3Subtitle;

  /// No description provided for @onboardingContinue.
  ///
  /// In tr, this message translates to:
  /// **'Devam'**
  String get onboardingContinue;

  /// No description provided for @onboardingStart.
  ///
  /// In tr, this message translates to:
  /// **'Başla'**
  String get onboardingStart;

  /// No description provided for @onboardingCreateAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesap Oluştur'**
  String get onboardingCreateAccount;

  /// No description provided for @onboardingSkip.
  ///
  /// In tr, this message translates to:
  /// **'Şimdi değil'**
  String get onboardingSkip;

  /// No description provided for @galaxyEmpty.
  ///
  /// In tr, this message translates to:
  /// **'İlk fısıltını bırak...'**
  String get galaxyEmpty;

  /// No description provided for @galaxyEmptySubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bir şeyler hissediyorsan buradayız.'**
  String get galaxyEmptySubtitle;

  /// No description provided for @recordHold.
  ///
  /// In tr, this message translates to:
  /// **'Konuşmak için basılı tut'**
  String get recordHold;

  /// No description provided for @recordWrite.
  ///
  /// In tr, this message translates to:
  /// **'Yaz'**
  String get recordWrite;

  /// No description provided for @recordShuffle.
  ///
  /// In tr, this message translates to:
  /// **'Karıştır'**
  String get recordShuffle;

  /// No description provided for @recordColorTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bu an nasıl hissettiriyor?'**
  String get recordColorTitle;

  /// No description provided for @recordAddNote.
  ///
  /// In tr, this message translates to:
  /// **'Bir not eklemek ister misin?'**
  String get recordAddNote;

  /// No description provided for @recordNoteHint.
  ///
  /// In tr, this message translates to:
  /// **'İsteğe bağlı...'**
  String get recordNoteHint;

  /// No description provided for @recordSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get recordSave;

  /// No description provided for @recordCancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get recordCancel;

  /// No description provided for @emotionYellow.
  ///
  /// In tr, this message translates to:
  /// **'Enerji'**
  String get emotionYellow;

  /// No description provided for @emotionBlue.
  ///
  /// In tr, this message translates to:
  /// **'Sakin'**
  String get emotionBlue;

  /// No description provided for @emotionRed.
  ///
  /// In tr, this message translates to:
  /// **'Öfke'**
  String get emotionRed;

  /// No description provided for @emotionGreen.
  ///
  /// In tr, this message translates to:
  /// **'Huzur'**
  String get emotionGreen;

  /// No description provided for @emotionPurple.
  ///
  /// In tr, this message translates to:
  /// **'Düşünceli'**
  String get emotionPurple;

  /// No description provided for @emotionGray.
  ///
  /// In tr, this message translates to:
  /// **'Boş'**
  String get emotionGray;

  /// No description provided for @emotionPink.
  ///
  /// In tr, this message translates to:
  /// **'Sevgi'**
  String get emotionPink;

  /// No description provided for @emotionOrange.
  ///
  /// In tr, this message translates to:
  /// **'Heyecan'**
  String get emotionOrange;

  /// No description provided for @notifMissed7Days.
  ///
  /// In tr, this message translates to:
  /// **'Seni özledik. Bir şeyler bırakmak ister misin?'**
  String get notifMissed7Days;

  /// No description provided for @notifMissed30Days.
  ///
  /// In tr, this message translates to:
  /// **'Mırıldan hala burada. Ne zaman istersen döneriz.'**
  String get notifMissed30Days;

  /// No description provided for @settingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @settingsTheme.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get settingsTheme;

  /// No description provided for @settingsLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get settingsLanguage;

  /// No description provided for @settingsDateFormat.
  ///
  /// In tr, this message translates to:
  /// **'Tarih Gösterimi'**
  String get settingsDateFormat;

  /// No description provided for @settingsNotifications.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get settingsNotifications;

  /// No description provided for @settingsAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesap'**
  String get settingsAccount;

  /// No description provided for @settingsExport.
  ///
  /// In tr, this message translates to:
  /// **'Verileri Dışa Aktar'**
  String get settingsExport;

  /// No description provided for @settingsDeleteAll.
  ///
  /// In tr, this message translates to:
  /// **'Tüm Verileri Sil'**
  String get settingsDeleteAll;

  /// No description provided for @settingsAbout.
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get settingsAbout;

  /// No description provided for @themeDarkGalaxy.
  ///
  /// In tr, this message translates to:
  /// **'Koyu Galaxy'**
  String get themeDarkGalaxy;

  /// No description provided for @themeGradientNight.
  ///
  /// In tr, this message translates to:
  /// **'Gradient Gece'**
  String get themeGradientNight;

  /// No description provided for @themeWhiteMinimal.
  ///
  /// In tr, this message translates to:
  /// **'Beyaz Minimal'**
  String get themeWhiteMinimal;

  /// No description provided for @themePaper.
  ///
  /// In tr, this message translates to:
  /// **'Kağıt'**
  String get themePaper;

  /// No description provided for @dateFormatRelative.
  ///
  /// In tr, this message translates to:
  /// **'Göreceli'**
  String get dateFormatRelative;

  /// No description provided for @dateFormatExact.
  ///
  /// In tr, this message translates to:
  /// **'Kesin'**
  String get dateFormatExact;

  /// No description provided for @dateFormatMonthOnly.
  ///
  /// In tr, this message translates to:
  /// **'Ay Bazlı'**
  String get dateFormatMonthOnly;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In tr, this message translates to:
  /// **'Onayla'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @share.
  ///
  /// In tr, this message translates to:
  /// **'Paylaş'**
  String get share;

  /// No description provided for @changeColor.
  ///
  /// In tr, this message translates to:
  /// **'Rengi Değiştir'**
  String get changeColor;

  /// No description provided for @noAccountLabel.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yapılmadı'**
  String get noAccountLabel;

  /// No description provided for @appVersion.
  ///
  /// In tr, this message translates to:
  /// **'Mırıldan v1.0'**
  String get appVersion;
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
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
