# CLAUDE.md — Mırıldan Projesi Talimatları

> Bu dosya, projede Claude Code ile çalışırken ona verilecek **kalıcı bağlamdır**. Her yeni oturumda Claude Code bu dosyayı okuyacak ve kurallarına uyacaktır.

## Proje Hakkında

**İsim:** Mırıldan
**Subtitle:** Duygularını yakala, takip etme.
**Platform:** iOS + Android (Flutter), tablet dahil
**Diller:** Türkçe (ana), İngilizce
**Versiyon:** v1.0 (geliştirme aşamasında)

Mırıldan, kullanıcıların ses veya kısa yazı ile duygusal anlarını zorunluluk hissetmeden yakalamalarını sağlayan minimal bir uygulamadır. Standart mood tracker'ların aksine streak baskısı yoktur.

**Detaylı bilgi için:** `docs/Mirildan_PRD_v1.0.docx` ve `docs/Mirildan_Teknik_Karar_Dokumani_v1.0.docx` dosyalarına bak.

---

## En Önemli Kural: Aşama Sistemi

Bu proje **13 aşamada** geliştirilmektedir. Her aşama kendi içinde tamamlanır ve kullanıcı (proje yöneticisi) onayladıktan sonra bir sonrakine geçilir.

**ASLA** bir sonraki aşamaya kullanıcının onayı olmadan geçme. Mevcut aşamada kal, tamamla, test et, onay bekle.

**Aşamalar:**
1. PRD + Teknik Karar Dokümanı ✅ (Tamamlandı)
2. Tasarım Sistemi ve Mockup'lar
3. Proje İskeleti ve Temel Mimari
4. Veri Modeli ve Yerel Depolama Katmanı
5. Ana Ekran: Kayıt Butonu ve Ses Kaydı
6. Renk ve Metin Ekleme Akışı
7. Kayıt Listesi, Oynatma ve Filtreleme
8. Galaxy Görünümü
9. Onboarding ve Hesap Sistemi
10. Bildirimler, Ayarlar, Tema Seçenekleri
11. Minimal Streak/Rozet Sistemi
12. Paylaşım Özelliği
13. Çok Dilli Destek + Tablet Optimizasyonu + Son Cilalama

Şu an hangi aşamadayız? `CURRENT_PHASE.md` dosyasına bak.

---

## Teknoloji Stack (Özet)

Tüm detaylar `docs/Mirildan_Teknik_Karar_Dokumani_v1.0.docx` içinde.

- **Framework:** Flutter 3.24+
- **State Management:** Riverpod 2.x (+ riverpod_annotation)
- **Database:** Isar 3.x
- **Navigation:** go_router 14.x
- **Auth:** Firebase Auth (Google + Apple + Email)
- **Audio:** record (kayıt) + just_audio (oynatma)
- **Architecture:** Feature-first + Clean Architecture
- **Code Generation:** build_runner + freezed + json_serializable

## Klasör Yapısı

```
lib/
├── core/                  # Ortak altyapı (constants, theme, utils, router, l10n, widgets)
├── features/              # Özellikler (her biri: data, domain, presentation)
│   ├── onboarding/
│   ├── recording/
│   ├── galaxy/
│   ├── entry_detail/
│   ├── list_view/
│   ├── settings/
│   ├── auth/
│   ├── sharing/
│   └── badges/
├── data/                  # Global data (models, repositories, services)
└── main.dart
```

---

## Kod Yazım Kuralları

### Genel

1. **Ürünün felsefesine sadık kal.** Mırıldan'da "zorunluluk hissi" yoktur. UI metinleri, hata mesajları ve bildirimler her zaman nazik ve yargısız olmalıdır.
   - ❌ Kötü: "Streak'in kırıldı!"
   - ✅ İyi: "Seni özledik. Ne zaman istersen döneriz."

2. **Türkçe'yi doğru kullan.** Tüm kullanıcıya gösterilen metinler önce Türkçe'de mükemmel olmalıdır. Daha sonra İngilizce'ye çevrilir. Türkçe karakterler (ç, ğ, ı, ö, ş, ü) test edilmelidir.

3. **Yorum satırları Türkçe yazılsın.** Karmaşık logic için yorumlar Türkçe olabilir. Ama kod, değişken adları, fonksiyon adları **her zaman İngilizce**.

4. **Magic number yok.** Tüm sabitler `core/constants/` altında tanımlı olmalı.

### Naming Conventions

- **Dosyalar:** `snake_case.dart`
- **Sınıflar:** `PascalCase`
- **Değişkenler ve fonksiyonlar:** `camelCase`
- **Sabitler:** `lowerCamelCase` (Dart konvensiyonu, SCREAMING değil)
- **Özel (private):** `_underscorePrefix`

### Widget Yapısı

- Her widget kendi dosyasında olmalı
- 200 satırdan uzun widget'lar parçalanmalı
- `build` metodu sade tutulmalı, karmaşık logic helper metodlara çekilmeli
- `StatelessWidget` tercih edilmeli (state gerekmedikçe)

### State Management (Riverpod)

- Her provider `_providers.dart` dosyalarında toplanmalı
- Code generation kullan: `@riverpod` anotasyonu
- `ConsumerWidget` veya `HookConsumerWidget` (hook gerekirse)
- Business logic view'larda değil, notifier/controller'larda

### Database (Isar)

- Tüm modeller `data/models/` altında
- Her model için repository `data/repositories/` altında
- View'lar asla Isar'a direkt erişmez, repository üzerinden erişir
- Karmaşık query'ler method olarak repository'de tanımlanır

### Test

- Yeni bir repository/service yazıldığında unit testi de yazılır
- Kritik widget'lar için widget testi
- PR'lar test olmadan merge edilmez

---

## Git Workflow

### Branch Stratejisi

- `main` — Sadece yayınlanmış versiyonlar
- `develop` — Aktif geliştirme
- `feature/phase-N-kisa-isim` — Her aşama kendi branch'inde

### Commit Mesajları (Conventional Commits)

```
feat(scope): kısa açıklama

Örnekler:
feat(recording): ses kaydı başlatma/durdurma
fix(galaxy): noktalar çakışması
docs: PRD güncellendi
refactor(entry): EntryModel freezed'e çevrildi
test(recording): AudioService unit testleri
```

Türleri: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### PR Süreci

1. `develop`'tan `feature/phase-N-...` branch'i aç
2. Değişiklikleri yap
3. Testler ve linter çalıştır: `flutter analyze && flutter test`
4. PR aç, açıklamaya:
   - Hangi aşamanın hangi adımı yapıldı
   - Ekran görüntüleri (UI değişikliği varsa)
   - Test edilme durumu
5. **Kullanıcının (proje yöneticisi) onayı bekle**
6. Merge et

---

## Her Aşama Başlarken Yapılacaklar

Yeni bir aşama başladığında Claude Code bu adımları takip eder:

1. `CURRENT_PHASE.md` dosyasını oku, aşamanın detaylarını anla
2. İlgili branch'i oluştur (`feature/phase-N-isim`)
3. Aşamanın sonunda teslim edilecek çıktıları netleştir
4. Görevleri küçük parçalara böl
5. Parça parça uygula, her önemli noktada kullanıcıya rapor ver
6. Aşama bitince özet çıkar, test ekranları/görselleri göster
7. Kullanıcı onayını bekle

---

## Her Aşama Sonunda Yapılacaklar

1. `flutter analyze` hatasız olmalı
2. `flutter test` tüm testler geçmeli
3. `flutter format .` çalıştırılmalı
4. PR açılmalı, kullanıcı onayı alınmalı
5. Merge sonrası `CURRENT_PHASE.md` bir sonraki aşamaya güncellenir
6. `CHANGELOG.md` güncellenir

---

## Karar Alırken Kılavuzlar

Eğer bir karar belirsizse, şu öncelik sırasını kullan:

1. **Kullanıcı deneyimi ilk sırada.** Teknik zariflik 2. sırada.
2. **Basitlik karmaşıklığa tercih edilir.** "Yapılabiliyor" = "yapılmalı" değildir.
3. **Performans önemlidir.** Özellikle Galaxy ekranı için 60 FPS hedefi.
4. **Güvenlik ihmal edilmez.** Kullanıcı verisi hassas, dikkatli davran.
5. **Test edilmeyen kod yoktur.**

Karar veremediğin bir durumda **kullanıcıya sor**. "Bence X veya Y olabilir, sen hangisini tercih edersin?" tarzı net seçenekler sun.

---

## Sık Yapılan Hatalar (Kaçınılacaklar)

1. ❌ Kullanıcıyı yargılayan metinler kullanmak ("Streak'in kırıldı!")
2. ❌ Aşamalar arasında atlama yapmak
3. ❌ Test yazmadan özellik ekleme
4. ❌ Büyük dosyalar (200+ satır widget)
5. ❌ Magic number kullanımı (5.0, Color(0xFFFF0000))
6. ❌ Repository pattern'i atlamak, view'dan direkt DB'ye erişmek
7. ❌ Riverpod provider'larını tüm uygulamaya yayıp scope vermemek
8. ❌ Mikrofon izni reddedilince uygulamanın çalışmaz hale gelmesi (metin kaydı her zaman aktif olmalı)
9. ❌ Async işlemlerde `BuildContext` kullanıp `mounted` kontrolünü atlamak
10. ❌ Hard-coded metinler (her metin `core/localization/` altında key ile)

---

## İletişim Kuralları

- Kullanıcıya **Türkçe** yanıt ver
- Uzun raporlar yerine **net, kısa özetler** tercih et
- Emin olmadığın noktalarda **sormaktan çekinme**
- İş bitince "bittiği"ni açıkça belirt, sonraki aşamaya geçmek için **onay iste**
- Sorun çıkarsa **sakla değil, bildir** — Sorun erken yakalanmalı

---

## Son Not

Kullanıcı şöyle demişti:

> "Temeli sağlam olmayan bir bina en ufak depremde yıkılabilir."

Bu proje acele edilmeden, her katman sağlam şekilde kurulacaktır. Hızdan değil, **kaliteden ödün vermeyiz**.

---

_Son güncelleme: Aşama 1 — PRD + Teknik Karar Dokümanı tamamlandı._
