# CHANGELOG

Tüm önemli değişiklikler bu dosyada belgelenir.
Format: [Keep a Changelog](https://keepachangelog.com/tr/1.0.0/)

---

## [Unreleased]

### Aşama 4 — Veri Modeli ve Yerel Depolama (Bekliyor)
- Entry, UserPreferences, EarnedBadge Isar modelleri
- Repository katmanı ve unit testler
- Ses dosyası yönetim servisi

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
