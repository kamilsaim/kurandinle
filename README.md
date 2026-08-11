# Kur'ân-ı Kerîm ve Meâli — oynatıcı + indirici

Diyanet Kur'an Radyo'nun *Kur'ân-ı Kerîm ve Meâli* programı (52 bölüm, Fatih Okumuş & Nisan Kumru).
Ses dosyaları Diyanet'in sunucusunda kalır; buradaki dosyalar yalnızca oynatır ve indirir.

## Durum

| Ne | Durum |
|---|---|
| Oynatıcı (tek HTML) | Tamam — çalışıyor, test edildi |
| MP3'lerin indirilmesi | Tamam — 52/52 dosya, `mp3/`, 2,82 GB |
| Logo, ikonlar, çal/duraklat tuşları | Tamam |
| Hakkında (bilgi) sayfası | Tamam |
| Firebase'e yayımlama | **Sırada — sizde** |
| APK (TWA) | Firebase adresi belli olunca |

## Dosyalar

| Dosya | Ne işe yarar |
|---|---|
| `kuran-meal-player.html` | **Ana kaynak.** Tek dosyalık oynatıcı; çift tıklayıp açın. |
| `indir.ps1` | Tüm mp3'leri indiren betik. |
| `yayinla.ps1` | Oynatıcıyı `public/`e kopyalar, Firebase'e yayımlar. |
| `public/` | Firebase'e giden klasör (`index.html` + görseller + manifest). |
| `functions/`, `firebase.json` | İndirme proxy'si ve barındırma ayarları. |
| `mp3/` | İndirilmiş 52 bölüm (2,82 GB). Firebase'e **gitmez**. |
| `seffaf.png` | Şeffaf zeminli özgün logo — tüm ikonlar bundan üretildi. |
| `logo-seffaf.png` | Kırpılmış, kareye oturtulmuş logo (512px). Sayfada kullanılan. |
| `play.png`, `pause.png` | Çal / duraklat tuşları (şeffaf, 256px). |
| `logo.png` | Beyaz zeminli ilk logo. Artık kullanılmıyor, yedek. |
| `play-kucuk.png`, `pause-kucuk.png` | `play/pause.png` ile aynı. Silinebilir. |

> **Önemli:** `public/index.html`, `kuran-meal-player.html`'in kopyasıdır.
> Oynatıcıyı düzenledikten sonra mutlaka `.\yayinla.ps1 -SadeceKopya` çalıştırın.

## 1. Yerelde kullanım

`kuran-meal-player.html` dosyasına çift tıklayın. Kurulum gerekmez.

Özellikler: sûre araması, kaldığınız yerden devam, otomatik sıradaki bölüm,
0.75x–2x hız, biten bölümlerde ✓ işareti, klavye kısayolları
(<kbd>Boşluk</kbd> duraklat, <kbd>←</kbd>/<kbd>→</kbd> 15 sn).

## 2. MP3 indirme

```powershell
.\indir.ps1
```

```powershell
.\indir.ps1 -Bolum 1-10 -Klasor D:\Kuran
```

Yarıda kalırsa tekrar çalıştırın; tamamlanmış dosyalar atlanır.
Bölüm başına ~55 MB, tamamı ~2,8 GB.

**Neden betik, neden tarayıcıdan değil?** Diyanet'in sunucusu CORS başlığı
göndermiyor; tarayıcı `file://` sayfasından o adrese istek atmayı engelliyor.
Bu bir hata değil, güvenlik kuralı. Oynatıcı bunu açılışta sınar: indirme
mümkün değilse indirme düğmeleri, seçtiğiniz bölümleri indiren hazır bir
`.ps1` üretir. Firebase'de proxy varsa aynı düğmeler doğrudan indirir.

## 3. Firebase Hosting'e yayımlama

Sırayla:

```bash
npm install -g firebase-tools
```

```bash
firebase login
```

Ardından [console.firebase.google.com](https://console.firebase.google.com) →
"Proje ekle" ile projeyi oluşturun. Sonra bu klasörde:

```bash
firebase init hosting
```

`init` cevapları — dikkat:

- Public dizini: **`public`**
- Single-page app (rewrite all to index.html): **No**
- `index.html` üzerine yazılsın mı: **No** ← evet derseniz oynatıcı silinir

Yayımlama:

```powershell
.\yayinla.ps1
```

**Alan adı:** Konsol → Hosting → *Add custom domain*. Size bir TXT (doğrulama)
ve iki A kaydı verir; bunları alan adı sağlayıcınızın DNS panelinden girin.
SSL otomatik gelir, yayılması birkaç saat sürebilir.

**Plan:** İndirme proxy'si (`functions/`) Cloud Function olduğu için **Blaze**
planı ister. Sadece dinlemek yeterliyse `firebase.json` içindeki `rewrites`
satırını silin — ücretsiz **Spark** planında dinleme sorunsuz çalışır.
Proxy üzerinden inen her dosya çıkış trafiği yazar; toplu indirmeyi
bilgisayarda `indir.ps1` ile yapmak hem bedava hem hızlı.

## 4. Telefonda arka planda çalma

Siteyi telefondan açıp ana ekrana ekleyin (Chrome: ⋮ → "Uygulamayı yükle").
MediaSession tanımlı olduğu için:

- başka uygulamaya geçseniz veya ekranı kilitleseniz de ses devam eder,
- kilit ekranında bölüm adı ve oynat/duraklat/önceki/sonraki düğmeleri çıkar,
- kulaklık ve araç Bluetooth tuşları çalışır.

iPhone'da Safari sekmesinde çalışır; ana ekrana eklenmiş modda iOS bunu daha
kararsız yönetir.

## 5. APK (sonraki adım)

Seçilen yol: **TWA (Trusted Web Activity)** — siteyi Chrome motoruyla, adres
çubuğu olmadan açan ince bir kabuk. Arka plan sesi birebir tarayıcıdaki gibi
çalışır, APK birkaç yüz KB olur, site güncellenince uygulama da güncellenir.

MP3'leri APK'ya gömmek **elendi**: 2,8 GB'lık APK Play Store'a yüklenemez,
elden kurulumda telefon iki katı boş alan ister. Düz WebView kabuğu da elendi:
Android arka planda WebView sesini keser.

TWA'dan önce eklenmesi gerekenler:

1. **Service worker** — sitenin "kurulabilir" sayılması için.
2. **`public/.well-known/assetlinks.json`** — APK ile siteyi eşleştirir;
   olmazsa uygulamanın üstünde adres çubuğu görünür. İçindeki parmak izi
   (SHA-256), APK'yı imzalayacağınız anahtardan gelir.

Sonra PWABuilder ya da Bubblewrap ile APK üretilir.

## Kaldığınız yer

İlerleme tarayıcının yerel deposunda (localStorage) tutulur; hiçbir veri
sunucuya gitmez. Kayıt **cihaza ve adrese özeldir** — bilgisayardaki `file://`
ile telefondaki site birbirinin ilerlemesini görmez. Ortak olması için
her iki cihazda da aynı Firebase adresini kullanın.

## Bilgi sayfası

Başlıktaki **Hakkında** düğmesi; içeriğin Diyanet Kur'an Radyo'dan geldiğini,
sesin burada barındırılmadığını, sitenin resmî olmadığını ve telif durumunu
anlatır. Doğrudan bağlantı: adresin sonuna `#hakkinda` ekleyin.

## Hak durumu

İçerik Diyanet İşleri Başkanlığı'na aittir; site bu bölümleri indirilebilir
olarak işaretlememiştir. Dosyalar herkese açık sunulduğu için indirme teknik
olarak çalışır. Kişisel dinleme dışında çoğaltma veya yeniden yayım için
Diyanet İşleri Başkanlığı'ndan izin alın.
