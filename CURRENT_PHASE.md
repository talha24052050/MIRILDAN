# CURRENT_PHASE.md — Mevcut Aşama Durumu

## Tamamlanan Aşamalar

| # | Aşama | Branch | Durum |
|---|---|---|---|
| 1 | PRD + Teknik Karar Dokümanı | `main` | ✅ |
| 2 | Tasarım Sistemi ve Mockup'lar | `feature/phase-2-design-system` | ✅ |
| 3 | Proje İskeleti ve Temel Mimari | `feature/phase-3-skeleton` | ✅ |
| 4 | Veri Modeli ve Yerel Depolama | `feature/phase-4-data-model` | ✅ |

---

## Aktif Aşama: Aşama 5 — Ana Ekran: Kayıt Butonu ve Ses Kaydı

**Durum:** Devam ediyor
**Branch:** `feature/phase-5-recording`

### Yapılacaklar

- [ ] Ana ekran UI — büyük kayıt butonu, minimal tasarım, Galaxy preview
- [ ] Mikrofon izni akışı — reddedilince metin kaydına yönlendir, uygulama kırılmaz
- [ ] Ses kaydı — `record` paketi ile başlat/durdur, süre göstergesi
- [ ] Metin kaydı — alternatif kısa metin girişi
- [ ] Kayıt sonrası — `AudioFileService` + `EntryRepository` ile kaydet
- [ ] Riverpod provider'ları — kayıt state yönetimi
- [ ] Widget testleri — kayıt butonu ve temel akış

### Teslim Kriterleri

- Kayıt butonu ile ses kaydı başlatılabilir ve durdurulabilir
- Mikrofon izni reddedilince uygulama çalışmaya devam eder
- Ses kaydı tamamlanınca veritabanına yazılır
- Metin kaydı alternatif olarak çalışır
- Widget testleri geçiyor
