# Mırıldan 🌌

> **Duygularını yakala, takip etme.**

Mırıldan, kullanıcıların ses veya kısa yazı ile duygusal anlarını zorunluluk hissetmeden yakalamalarını sağlayan minimal bir mobil uygulamadır.

---

## ✨ Felsefe

Piyasadaki mood tracker uygulamalarının çoğu kullanıcıyı sürekli takip etmeye, streak tutmaya ve disipline zorlar. Mırıldan bunun tam tersidir:

- 🎯 **Yakala, takip etme.** Her gün girmek zorunda değilsin.
- 🤫 **Sessiz ve minimal.** Dikkatini dağıtmaz.
- 💝 **Commitment-free.** Streak kırılması, suçluluk yaratan mekanikler yoktur.
- 📸 **Duygusal arşiv.** Kayıtların, hayatının renkli anılarıdır.

---

## 🎨 Nasıl Çalışır?

1. **Kaydet:** Ses kaydı yap (önerilen 10 sn), yazı yaz veya ikisini birlikte bırak.
2. **Renklendir:** 8 duygu renginden biriyle o anını etiketle.
3. **İzle:** Zamanla, kayıtların bir galaxy gibi büyür. İstediğin zaman geri dön, dinle.

---

## 🛠️ Teknoloji Stack

- **Framework:** Flutter 3.24+
- **State:** Riverpod 2.x
- **Database:** Isar 3.x (yerel)
- **Navigation:** go_router
- **Auth:** Firebase (Google + Apple + Email — isteğe bağlı)
- **Mimari:** Feature-first + Clean Architecture

---

## 📱 Desteklenen Platformlar

- iOS 13.0+
- Android 6.0+ (API 23+)
- iPad ve Android tabletler

**Diller:** Türkçe, İngilizce

---

## 📋 Geliştirme Durumu

**Versiyon:** v1.0 — Tüm aşamalar tamamlandı 🎉

### Aşamalar

- [x] **1.** PRD + Teknik Karar Dokümanı
- [x] **2.** Tasarım Sistemi ve Mockup'lar
- [x] **3.** Proje İskeleti ve Temel Mimari
- [x] **4.** Veri Modeli ve Yerel Depolama
- [x] **5.** Ana Ekran: Kayıt Butonu ve Ses Kaydı
- [x] **6.** Renk ve Metin Ekleme Akışı
- [x] **7.** Kayıt Listesi, Oynatma ve Filtreleme
- [x] **8.** Galaxy Görünümü
- [x] **9.** Onboarding ve Hesap Sistemi
- [x] **10.** Bildirimler, Ayarlar, Tema
- [~] **11.** Streak/Rozet Sistemi *(kasıtlı atlandı — felsefe gereği)*
- [x] **12.** Paylaşım Özelliği
- [x] **13.** Çok Dilli Destek + Tablet Optimizasyonu + Son Cilalama

---

## 📚 Dokümantasyon

- [PRD (Ürün Gereksinim Dokümanı)](docs/Mirildan_PRD_v1.0.docx)
- [Teknik Karar Dokümanı](docs/Mirildan_Teknik_Karar_Dokumani_v1.0.docx)
- [Claude Code Talimatları](CLAUDE.md)
- [Değişiklik Günlüğü](CHANGELOG.md)

---

## 🤝 Geliştirme

Bu proje, Claude Code ile yönetici-AI arasında iş bölümü yapılarak geliştirilmektedir. Detaylar `CLAUDE.md` içinde.

### Branch Stratejisi

- `main` — Yayınlanan versiyonlar
- `develop` — Aktif geliştirme
- `feature/phase-N-...` — Her aşamanın kendi branch'i

### Commit Konvensiyonu

[Conventional Commits](https://www.conventionalcommits.org/) kullanılır.

---

## 📄 Lisans

TBD (henüz belirlenmedi)

---

_Acele yok. Temel sağlam olacak._
