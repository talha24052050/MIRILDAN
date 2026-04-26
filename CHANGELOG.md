# CHANGELOG

Tüm önemli değişiklikler bu dosyada belgelenir.
Format: [Keep a Changelog](https://keepachangelog.com/tr/1.0.0/)

---

## [Unreleased]

## Aşama 8 — Galaxy Görünümü

**Branch:** `feature/phase-8-galaxy` | **Tarih:** Nisan 2026

### Eklendi
- `lib/features/galaxy/providers/galaxy_providers.dart` — `GalaxyFilter` (renk/tip filtresi) ve `galaxyEntries` (filtreli kayıt listesi) provider'ları
- `lib/features/galaxy/presentation/galaxy_painter.dart` — `GalaxyPainter` (`CustomPainter`): Fibonacci spiral algoritmasıyla noktaları yerleştirir, glow + halo efektleri
- `lib/features/galaxy/presentation/galaxy_screen.dart` — Tam ekran galaksi görünümü: `InteractiveViewer` ile zoom/pan, nokta tap → detay sheet, boş durum, kayıt butonu
- `lib/features/galaxy/presentation/widgets/entry_detail_sheet.dart` — Kayıt detay bottom sheet: renk etiketi, tarih, içerik, ses süresi, silme akışı
- `test/features/galaxy/galaxy_test.dart` — 9 widget testi (GalaxyScreen × 4, EntryDetailSheet × 4)

### Değişti
- `app_router.dart`: Galaxy route `_PlaceholderScreen` → `GalaxyScreen`

---

## Aşama 7 — Kayıt Listesi, Oynatma ve Filtreleme

**Branch:** `feature/phase-7-list-playback` | **Tarih:** Nisan 2026

### Eklendi
- `lib/features/list_view/data/audio_player_service.dart` — `AudioPlayerService` soyut arayüzü + `JustAudioPlayerService` implementasyonu (`positionStream`, `playingStream`, `processingStateStream`)
- `lib/features/list_view/providers/list_view_providers.dart` — `EntryListFilter`, `filteredEntries`, `audioPlayerService`, `PlayerNotifier` provider'ları
- `lib/features/list_view/presentation/list_view_screen.dart` — tarih gruplu kayıt listesi, boş/hata durumları, oynatıcı durduğunda liste güncellemesi (`ref.listen`)
- `lib/features/list_view/presentation/widgets/entry_list_tile.dart` — `Dismissible` tile, oynatma ikonu, renk noktası
- `lib/features/list_view/presentation/widgets/date_group_header.dart` — Türkçe tarih başlıkları (Bugün/Dün/tarih)
- `lib/features/list_view/presentation/widgets/filter_bar.dart` — yatay renk ve tip filtre chip'leri
- `lib/features/list_view/presentation/widgets/mini_player_bar.dart` — alt oynatma çubuğu, progress slider, ayrı `StreamBuilder<bool>` play/pause ikonu için
- `lib/core/utils/duration_formatter.dart` — paylaşımlı süre formatlayıcı (`DurationFormatter.format`)
- `lib/core/widgets/confirm_dialog.dart` — paylaşımlı onay diyalogu (`showConfirmDialog`)
- `lib/core/router/app_router.dart`: `/list` → `ListViewScreen` rotası eklendi
- `test/features/list_view/list_view_test.dart` — 12 widget testi (ListViewScreen, FilterBar, EntryListTile)

### Değişti
- `RecordingScreen`: `_formatDuration` → `DurationFormatter.format`, `_showCancelDialog` → `showConfirmDialog`
- `ColorPickerScreen`: `_showCancelDialog` → `showConfirmDialog`, double `.trim()` düzeltildi
- `AppStrings`: liste görünümü string'leri eklendi

---

## Aşama 6 — Renk ve Metin Ekleme Akışı

**Branch:** `feature/phase-6-color-text-flow` | **Tarih:** Nisan 2026

### Eklendi
- `AppStrings`: iptal onay diyalogu string'leri (`recordCancelConfirmTitle/Body*/Yes/No`), `recordSaveError`, `recordTextMaxLength` (280)
- `RecordingScreen`: metin moduna 280 karakterlik sayaç (`buildCounter`)
- `RecordingScreen`: kayıt/metin iptal akışında onay diyalogu (`PopScope` + AppBar X butonu)
- `ColorPickerScreen`: renk seçiminde haptic feedback (`HapticFeedback.selectionClick()`)
- `ColorPickerScreen`: geri/İptal butonunda onay diyalogu (`PopScope` dahil)
- `ColorPickerScreen`: body `SingleChildScrollView`'a sarıldı — küçük ekranlarda scroll desteği
- `app_router.dart`: ColorPickerScreen geçişi `CustomTransitionPage` + slide-up animasyonu
- `test/features/recording/color_picker_screen_test.dart` — 6 yeni widget testi
- `test/features/recording/recording_screen_test.dart` — 5 yeni widget testi (toplam 10'a çıktı)

### Değişti
- `RecordingScreen._handleClose`: GoRouter çağrısı erken return'lerden sonraya taşındı (`canPop()` kontrolü eklendi)
- `ColorPickerScreen._cancel`: `canPop()` kontrolü eklendi, ses dosyası async delete güvenliği düzeltildi

---

## Aşama 5 — Ana Ekran: Kayıt Butonu ve Ses Kaydı

**Branch:** `feature/phase-5-recording` | **Tarih:** Nisan 2026

### Eklendi
- `lib/features/recording/data/audio_recorder_service.dart` — `record` paketi wrapper, amplitude stream
- `lib/features/recording/domain/recording_state.dart` — freezed sealed state (idle, recording, done, permissionDenied, error)
- `lib/features/recording/providers/recording_providers.dart` — `RecordingController` (@riverpod): kayıt başlat/durdur/iptal
- `lib/features/recording/presentation/recording_screen.dart` — ses kaydı ekranı + metin modu (mikrofon izni reddedilince)
- `lib/features/recording/presentation/color_picker_screen.dart` — renk seçimi, not ekleme, DB'ye kaydetme
- `lib/features/recording/presentation/widgets/record_button.dart` — amplitude'a göre pulse animasyonlu kayıt butonu
- `lib/features/recording/presentation/widgets/waveform_display.dart` — animasyonlu dalga formu görselleştirmesi
- `test/features/recording/recording_screen_test.dart` — 5 widget testi
- Android `RECORD_AUDIO` izni + iOS `NSMicrophoneUsageDescription` eklendi
- `app_router.dart` güncellendi: `/record` → RecordingScreen, `/record/color` → ColorPickerScreen
- `AppStrings`: `recordRelease`, `recordPermissionDenied`, `recordTextHint`, `recordContinue` eklendi
- `AppRoutes`: `colorPicker`, `colorPickerRelative` eklendi

---

---

## Aşama 4 — Veri Modeli ve Yerel Depolama

**Branch:** `feature/phase-4-data-model` | **Tarih:** Nisan 2026

### Eklendi
- `lib/data/models/entry.dart` — Entry modeli (freezed, EntryType + EntryColor enum)
- `lib/data/models/user_preferences.dart` — UserPreferences modeli (freezed)
- `lib/data/models/earned_badge.dart` — EarnedBadge modeli (freezed)
- `lib/data/repositories/entry_repository.dart` — CRUD, renk/tip filtresi, count, tarih sıralama
- `lib/data/repositories/preferences_repository.dart` — tema ve dil tercihi okuma/yazma
- `lib/data/services/audio_file_service.dart` — ses dosyası kaydetme, silme, orphan temizleme
- `lib/data/services/database_service.dart` — `initInMemory()` test desteği eklendi
- `test/data/repositories/entry_repository_test.dart` — 8 unit test (hepsi geçiyor)

---

## Aşama 3 — Proje İskeleti ve Temel Mimari

**Branch:** `feature/phase-3-skeleton` | **Tarih:** Nisan 2026

### Eklendi
- `lib/main.dart` — ProviderScope + DatabaseService.init() ile gerçek uygulama girişi
- `lib/app.dart` — MiriildanApp (ConsumerWidget, tema + locale reaktif)
- `lib/core/router/` — go_router ile 6 rota (galaxy, onboarding, record, entry/:id, list, settings)
- `lib/core/providers/theme_provider.dart` — AppThemeType state yönetimi
- `lib/core/providers/locale_provider.dart` — Locale state yönetimi
- `lib/data/services/database_service.dart` — Isar singleton başlatma servisi
- `lib/core/localization/l10n/` — TR ve EN .arb dosyaları + generate edilmiş AppLocalizations
- `l10n.yaml` — Localization yapılandırması
- `pubspec.yaml` — Tüm bağımlılıklar eklendi (Riverpod, Isar, go_router, Firebase, audio, vb.)
- `build_runner` çalışır hale getirildi

---

## Aşama 2 — Tasarım Sistemi ve Mockup'lar

**Branch:** `feature/phase-2-design-system` | **Tarih:** Nisan 2026

### Eklendi
- `lib/core/constants/app_colors.dart` — 8 duygu rengi + 4 tema paleti
- `lib/core/constants/app_spacing.dart` — Spacing, radius, size, duration sabitleri
- `lib/core/constants/app_text_styles.dart` — 9 tipografi stili (Inter font ailesi)
- `lib/core/constants/emotion_colors.dart` — EmotionColor enum + Türkçe etiketler
- `lib/core/theme/app_theme.dart` — 4 tam tema (darkGalaxy, gradientNight, whiteMinimal, paper)
- Statik mockup ekranları: Onboarding (×3), Galaxy (dolu/boş), Ses kaydı + renk seçimi, Ayarlar
- Flutter klasör yapısı: core, features, data alt dizinleri

---

## Aşama 1 — PRD + Teknik Karar Dokümanı

**Branch:** `main` | **Tarih:** Nisan 2026

### Eklendi
- `docs/Mirildan_PRD_v1.0.docx` — Ürün Gereksinim Dokümanı
- `docs/Mirildan_Teknik_Karar_Dokumani_v1.0.docx` — Mimari ve teknoloji kararları
- `CLAUDE.md` — Proje kuralları ve Claude Code talimatları
- `README.md` — Proje tanıtımı
