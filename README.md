<div align="center">

<img src="docs/logo.png" alt="Kur'ân-ı Kerîm ve Meâli" width="160">

# Kur'ân-ı Kerîm ve Meâli

**Diyanet Kur'an Radyo'nun 52 bölümlük *Kur'ân-ı Kerîm ve Meâli* programı için oynatıcı ve indirici.**

Fatih Okumuş &amp; Nisan Kumru — Arapça tilâvet ve Türkçe meâl

[**▶ kurandinle.web.app**](https://kurandinle.web.app)

![kurulum yok](https://img.shields.io/badge/kurulum-gerekmez-0d4c3b)
![tek dosya](https://img.shields.io/badge/tek_dosya-HTML-0d4c3b)
![bağımlılık](https://img.shields.io/badge/bağımlılık-yok-0d4c3b)
![lisans](https://img.shields.io/badge/içerik-Diyanet_İşleri_Başkanlığı-8a6d3b)

</div>

---

Ses dosyaları Diyanet'in sunucusunda kalır; buradaki hiçbir şey ses barındırmaz —
yalnızca oynatır ve indirir. Resmî bir Diyanet projesi değildir.

## Ne var

- **Tek dosyalık oynatıcı** — `kuran-meal-player.html`, çift tıklayın. Kurulum, sunucu, bağımlılık yok.
- **Kaldığınız yerden devam** — bölüm ve saniye tarayıcıda saklanır, hiçbir veri sunucuya gitmez.
- **Sûre araması**, otomatik sıradaki bölüm, 0.75x–2x hız, biten bölümlerde ✓ işareti.
- **Klavye kısayolları** — <kbd>Boşluk</kbd> duraklat, <kbd>←</kbd>/<kbd>→</kbd> 15 saniye.
- **Toplu indirme** — seçtiğiniz bölümler ya da 52'sinin tamamı.
- **Telefonda arka planda çalma** — ana ekrana ekleyin, ekran kilitliyken de devam eder.
- **Gömülü görseller** — logo ve tuşlar HTML'in içinde; tek dosya, tek başına eksiksiz.

## Hızlı başlangıç

**Sadece dinlemek için:** [kurandinle.web.app](https://kurandinle.web.app) adresini açın.
Ya da `kuran-meal-player.html` dosyasını indirip çift tıklayın.

**Tüm bölümleri indirmek için:**

```powershell
.\indir.ps1                      # 52 bölümün tamamı -> mp3\
.\indir.ps1 -Bolum 1-10          # sadece 1-10
.\indir.ps1 -Bolum 3,7,40        # seçili bölümler
.\indir.ps1 -Klasor D:\Kuran     # başka klasöre
```

Yarıda kalırsa tekrar çalıştırın; tamamlanmış dosyalar atlanır.
Bölüm başına ~55 MB, tamamı ~2,8 GB.

## Neden bir indirme proxy'si var

Diyanet'in sunucusu CORS başlığı göndermiyor. Bu, tarayıcının bir sayfadan o
adrese istek atmasını engeller — bir hata değil, güvenlik kuralı. Sesi *çalmak*
buna takılmaz (`<audio>` etiketi muaftır), ama *indirmek* takılır.

Oynatıcı açılışta hangi yolun açık olduğunu sınar ve düğmeleri ona göre ayarlar:

| Mod | Ne zaman | Düğmeler ne yapar |
|---|---|---|
| `proxy` | Bir proxy adresi tanımlı ve ayakta | Dosyaları doğrudan indirir |
| `direct` | Kaynak CORS'a izin veriyor | Dosyaları doğrudan indirir |
| `none` | İkisi de yok | Seçilenleri indiren bir `.ps1` üretir |

`worker/worker.js` bu proxy'dir: dosyayı CORS başlıklarıyla yeniden sunar,
gövdeyi akıtarak geçirir (55 MB'lık dosyalar belleğe alınmaz) ve Range
isteklerini destekler. Cloudflare Workers'ın ücretsiz katmanında çalışır.

```bash
cd worker
npx wrangler login
npx wrangler deploy
```

Çıkan adresi `PROXY` sabitine yazın; düğmeler kendiliğinden normal indirmeye geçer.

> Aynı proxy Firebase Cloud Functions ile de yazılabilir, ama Cloud Functions
> **Blaze** (kullandıkça öde) planı ister. Cloudflare Workers ücretsizdir.

## Klasör düzeni

| Yol | Ne işe yarar |
|---|---|
| `kuran-meal-player.html` | **Ana kaynak.** Tek dosyalık oynatıcı. |
| `public/` | Firebase'e giden klasör — `index.html` + ikonlar + manifest. |
| `public/index.html` | Ana kaynağın kopyası. Elle düzenlemeyin. |
| `worker/` | Cloudflare Workers indirme proxy'si. |
| `indir.ps1` | Tüm bölümleri indiren betik. |
| `yayinla.ps1` | Oynatıcıyı `public/`e kopyalar ve yayımlar. |
| `firebase.json` | Barındırma ayarları. |
| `docs/logo.png` | Bu sayfadaki logo. |
| `kaynak/` | Özgün yüksek çözünürlüklü logolar. Depoya ve siteye **girmez**. |
| `mp3/` | İndirilmiş bölümler. Depoya ve siteye **girmez**. |

> **Önemli:** Oynatıcıyı düzenledikten sonra `.\yayinla.ps1 -SadeceKopya`
> çalıştırın, yoksa değişiklik `public/index.html`e geçmez.

## Yayımlama

```powershell
.\yayinla.ps1              # kopyala + Firebase'e yayımla
.\yayinla.ps1 -SadeceKopya # yalnızca kopyala
```

İlk kurulumda `npm install -g firebase-tools`, ardından `firebase login`.
Barındırma ücretsiz **Spark** planında sorunsuz çalışır.

**Alan adı:** Konsol → Hosting → *Add custom domain*. Verilen TXT ve iki A
kaydını DNS panelinize girin; SSL otomatik gelir, yayılması birkaç saat sürebilir.

## Telefonda arka planda çalma

Siteyi telefondan açıp ana ekrana ekleyin (Chrome: ⋮ → "Uygulamayı yükle").
MediaSession tanımlı olduğu için:

- başka uygulamaya geçseniz veya ekranı kilitleseniz de ses devam eder,
- kilit ekranında bölüm adı ve oynat/duraklat/önceki/sonraki düğmeleri çıkar,
- kulaklık ve araç Bluetooth tuşları çalışır.

iPhone'da Safari sekmesinde çalışır; ana ekrana eklenmiş modda iOS bunu daha
kararsız yönetir.

## Sırada: APK

Seçilen yol **TWA (Trusted Web Activity)** — siteyi Chrome motoruyla, adres
çubuğu olmadan açan ince bir kabuk. Arka plan sesi birebir tarayıcıdaki gibi
çalışır, APK birkaç yüz KB olur, site güncellenince uygulama da güncellenir.

Öncesinde gerekenler:

1. **Service worker** — sitenin "kurulabilir" sayılması için.
2. **`public/.well-known/assetlinks.json`** — APK ile siteyi eşleştirir; olmazsa
   uygulamanın üstünde adres çubuğu görünür. İçindeki SHA-256 parmak izi,
   APK'yı imzalayacağınız anahtardan gelir.

Sonra PWABuilder ya da Bubblewrap ile APK üretilir.

MP3'leri APK'ya gömmek elendi: 2,8 GB'lık APK Play Store'a yüklenemez. Düz
WebView kabuğu da elendi: Android arka planda WebView sesini keser.

## Kaldığınız yer

İlerleme tarayıcının yerel deposunda (localStorage) tutulur; hiçbir veri sunucuya
gitmez. Kayıt **cihaza ve adrese özeldir** — bilgisayardaki `file://` ile
telefondaki site birbirinin ilerlemesini görmez. Ortak olması için her iki
cihazda da aynı adresi kullanın.

## Hak durumu

İçerik **Diyanet İşleri Başkanlığı**'na aittir. Site bu bölümleri indirilebilir
olarak işaretlememiştir; dosyalar herkese açık sunulduğu için indirme teknik
olarak çalışır. Kişisel dinleme dışında çoğaltma veya yeniden yayım için Diyanet
İşleri Başkanlığı'ndan izin alın.

Sayfadaki **Hakkında** düğmesi (`#hakkinda`) bu durumu ziyaretçiye de anlatır.
