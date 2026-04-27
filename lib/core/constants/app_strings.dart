// Türkçe UI metinleri — ileride l10n'a taşınacak
class AppStrings {
  AppStrings._();

  // Onboarding
  static const String onboarding1Title = 'Mırıldan\'a\nHoş Geldin.';
  static const String onboarding1Subtitle = 'Duygularını yakala, takip etme.';
  static const String onboarding2Title = 'Konuş ya da yaz,\nbir renk seç.';
  static const String onboarding2Subtitle =
      'Her şey senin tempondan, sen istediğinde.';
  static const String onboarding3Title = 'Her şey senin\nkontrolünde.';
  static const String onboarding3Subtitle =
      'Kayıtların sadece senin cihazında.\nHesap açmak isteğe bağlı.';
  static const String onboardingContinue = 'Devam';
  static const String onboardingStart = 'Başla';
  static const String onboardingCreateAccount = 'Hesap Oluştur';
  static const String onboardingSkip = 'Şimdi değil';

  // Ana ekran
  static const String galaxyEmpty = 'İlk fısıltını bırak...';
  static const String galaxyEmptySubtitle =
      'Bir şeyler hissediyorsan buradayız.';

  // Kayıt
  static const String recordHold = 'Konuşmak için basılı tut';
  static const String recordRelease = 'Bırak, bitir.';
  static const String recordWrite = 'Yaz';
  static const String recordSwitchToAudio = 'Ses';
  static const String recordShuffle = 'Karıştır';
  static const String recordColorTitle = 'Bu an nasıl hissettiriyor?';
  static const String recordAddNote = 'Bir not eklemek ister misin?';
  static const String recordNoteHint = 'İsteğe bağlı...';
  static const String recordTextHint = 'Ne hissediyorsun?';
  static const String recordContinue = 'Devam';
  static const String recordSave = 'Kaydet';
  static const String recordCancel = 'İptal';
  static const String recordPermissionDenied =
      'Mikrofon izni verilmedi. Metin olarak kaydet.';
  static const String recordSaveError = 'Bir sorun oluştu, tekrar dener misin?';
  static const int recordTextMaxLength = 280;

  // İptal onay diyalogu
  static const String recordCancelConfirmTitle = 'Kaydı iptal et?';
  static const String recordCancelConfirmBodyAudio =
      'Bu ses kaydı silinecek. Emin misin?';
  static const String recordCancelConfirmBodyText =
      'Yazdıkların silinecek. Emin misin?';
  static const String recordCancelConfirmBodyColorPicker =
      'Bu an kaydedilmeyecek. Emin misin?';
  static const String recordCancelConfirmYes = 'Evet, iptal et';
  static const String recordCancelConfirmNo = 'Hayır, devam et';

  // Liste görünümü
  static const String listViewTitle = 'Kayıtlar';
  static const String listViewEmpty = 'Henüz kayıt yok.';
  static const String listViewEmptySubtitle = 'Ne zaman istersen buradayız.';
  static const String listViewFilterAll = 'Tümü';
  static const String listViewFilterAudio = 'Ses';
  static const String listViewFilterText = 'Metin';
  static const String listViewFilterMixed = 'Karma';
  static const String listViewDeleteTitle = 'Bu kaydı sil?';
  static const String listViewDeleteBody = 'Bu işlem geri alınamaz.';
  static const String listViewDeleteConfirm = 'Evet, sil';
  static const String listViewDeleteCancel = 'Vazgeç';
  static const String listViewToday = 'Bugün';
  static const String listViewYesterday = 'Dün';

  // Bildirimler
  static const String notifMissed7Days =
      'Seni özledik. Bir şeyler bırakmak ister misin?';
  static const String notifMissed30Days =
      'Mırıldan hala burada. Ne zaman istersen döneriz.';

  // Ayarlar
  static const String settingsTitle = 'Ayarlar';
  static const String settingsLanguage = 'Dil';
  static const String settingsTheme = 'Tema';
  static const String settingsDateFormat = 'Tarih Gösterimi';
  static const String settingsNotifications = 'Bildirimler';
  static const String settingsAccount = 'Hesap';
  static const String settingsExport = 'Verileri Dışa Aktar';
  static const String settingsDeleteAll = 'Tüm Verileri Sil';
  static const String settingsAbout = 'Hakkında';

  // Auth
  static const String authSignInTitle = 'Hoş geldin.';
  static const String authCreateAccountTitle = 'Hesap oluştur.';
  static const String authSignInWithGoogle = 'Google ile devam et';
  static const String authOrDivider = 'veya';
  static const String authEmailHint = 'E-posta';
  static const String authPasswordHint = 'Şifre';
  static const String authSignIn = 'Giriş yap';
  static const String authCreateAccount = 'Hesap oluştur';
  static const String authNoAccount = 'Hesabın yok mu? Kayıt ol';
  static const String authHaveAccount = 'Hesabın var mı? Giriş yap';

  // Genel
  static const String appName = 'Mırıldan';
  static const String cancel = 'İptal';
  static const String confirm = 'Onayla';
  static const String delete = 'Sil';
  static const String share = 'Paylaş';
  static const String changeColor = 'Rengi Değiştir';
}
