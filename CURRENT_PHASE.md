# CURRENT_PHASE.md — Mevcut Aşama Durumu

## Tamamlanan Aşamalar

| # | Aşama | Branch | Durum |
|---|---|---|---|
| 1 | PRD + Teknik Karar Dokümanı | `main` | ✅ |
| 2 | Tasarım Sistemi ve Mockup'lar | `feature/phase-2-design-system` | ✅ |
| 3 | Proje İskeleti ve Temel Mimari | `feature/phase-3-skeleton` | ✅ |

---

## Sıradaki Aşama: Aşama 4 — Veri Modeli ve Yerel Depolama

**Durum:** Bekliyor (kullanıcı onayı alındı)
**Branch:** `feature/phase-4-data-model` (henüz açılmadı)

### Yapılacaklar

- [ ] `Entry` modeli (Isar `@collection`) — ses/metin/karma kayıt
- [ ] `UserPreferences` modeli — tema, dil, tarih tercihi
- [ ] `EarnedBadge` modeli — gizli rozetler
- [ ] `EntryRepository` — CRUD, sıralama, filtreleme
- [ ] `PreferencesRepository` — tercih okuma/yazma
- [ ] Ses dosyası yönetimi (`AudioFileService`) — kaydet, sil, orphan temizle
- [ ] `isar_generator` uyumluluk sorunu çözümü veya manuel schema
- [ ] Unit testler (repository katmanı)
- [ ] `flutter analyze` + `flutter test` temiz

### Teslim Kriterleri

- Entry veritabanına yazılabilir ve okunabilir
- Repository üzerinden filtreleme (renk, tip, tarih) çalışır
- Ses dosyası silinince veritabanı kaydı da silinir
- Unit testler geçiyor
