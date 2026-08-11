# Kur'ân-ı Kerîm ve Meâli — MP3 indirici (Diyanet Kur'an Radyo)
# Kullanım:
#   .\indir.ps1                 -> tüm 52 bölümü "mp3" klasörüne indirir
#   .\indir.ps1 -Bolum 1-10     -> sadece 1'den 10'a kadar
#   .\indir.ps1 -Bolum 3,7,40   -> sadece bu bölümler
#   .\indir.ps1 -Klasor D:\Kuran
# Yarım kalan indirmeler: dosya zaten tam boyuttaysa atlanır, tekrar çalıştırmak güvenlidir.

[CmdletBinding()]
param(
  [string]$Bolum = "",
  [string]$Klasor = "mp3"
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$BASE = "https://diyanetkuranradyo.com/assets/"

$RAW = @'
1|Fatiha Suresi - Bakara Suresi (1-86. Ayet)|c6bf2803-2e0e-41dc-9e7b-78b7c876a4eb
2|Bakara Suresi (87-158. Ayet)|48c2cb36-80a4-4c19-88c5-258681b1de5e
3|Bakara Suresi (159-223. Ayet)|794d5ea5-c8b2-4e6f-8f4a-6a27d287dc7d
4|Bakara Suresi (224-281. Ayet)|748dfe64-4e85-4b69-8caa-d3b9d7b4125b
5|Bakara Suresi (281-286), Al-i Imran Suresi (1-68)|1f113529-24b4-4ad9-8d64-140185545e93
6|Al-i Imran Suresi (69-153. Ayet)|f188534c-5397-44bb-8bec-69dc37843329
7|Al-i Imran Suresi (154-200), Nisa Suresi (1-24)|6c6b4d2f-3c80-4d77-9bdc-b1af68eb0c07
8|Nisa Suresi (25-94. Ayet)|51c8cdf5-f76b-43d8-8e13-a120c9728523
9|Nisa Suresi (95-175. Ayet)|30c7a6c1-1598-412a-aba6-a7b38edcd8d9
10|Nisa Suresi (179), Maide Suresi (1-56)|69588156-5906-4cc7-b618-51d61ef27d6e
11|Maide Suresi (57-120), Enam Suresi (1-5)|f48d03dd-9009-40fd-b1c9-642e7ff80587
12|Enam Suresi (6-90. Ayet)|0d17a762-fbbc-4f2a-83ae-7c4a384928ff
13|Enam Suresi (91-160. Ayet)|4755461f-d9a5-4e67-a2f0-67da39ee9960
14|Enam Suresi (161-165), Araf Suresi (1-79)|e39b735e-59b2-4bc5-be8e-12cbaac42e15
15|Araf Suresi (80-166. Ayet)|b734e571-8b8b-4340-a9a1-79086329b26f
16|Araf Suresi (167-206), Enfal Suresi (1-54)|a2ee3adb-2f21-4720-b669-c7164218e472
17|Enfal Suresi (55-75), Tevbe Suresi (1-57)|7e7804ec-e7da-4045-beeb-1a31ca2a4ee7
18|Tevbe Suresi (58-129), Yunus Suresi (1-6)|d8f0af30-a076-42c4-b259-b511a9dc6480
19|Yunus Suresi (7-93. Ayet)|91c5ae7c-6f34-4b84-99e0-667ecba888d7
20|Yunus Suresi (94-109), Hud Suresi (1-83)|613f6aa6-5fbe-4388-a56e-377dc1d26bf6
21|Hud Suresi (84-123), Yusuf Suresi (1-57)|5ebf65f5-20c3-4eb4-ba06-5079a45886e6
22|Yusuf Suresi (58-111), Rad Suresi (1-32)|3a8bbabe-e0d8-4395-9828-9309f9a463fd
23|Rad Suresi (33-43), Ibrahim Suresi, Hicr Suresi (1-50)|979b5c63-3e45-45b7-8da5-c31e9247cfb1
24|Hicr Suresi (51-99), Nahl Suresi (1-83)|2de25468-4c83-4281-aca7-e63d3b55cb3c
25|Nahl Suresi (84-128), Isra Suresi (1-60)|ff57e45f-3ff5-4be1-a909-e72a9803554c
26|Isra Suresi (61-111), Kehf Suresi (1-53)|4ce9a7dc-f54a-4a7c-a96e-6007ef78dcae
27|Kehf Suresi (54-110), Meryem Suresi (1-76)|c26beded-be60-49f8-bac3-a17e9512c752
28|Meryem Suresi (77-98), Taha Suresi (1-135)|f0683d11-e2da-458d-838e-5103234c5a3f
29|Enbiya Suresi (1-122), Hac Suresi (1-24)|ad20c948-db16-455f-961f-73b441a0d83f
30|Hac Suresi (25-78), Muminun Suresi (1-77)|6d8cb5e1-8e30-4a7e-a00f-54d99c9d48bd
31|Muminun Suresi (78-118), Nur Suresi (1-61)|cdf79d70-9fb8-4e1e-a312-babc29bbfc37
32|Nur Suresi (62-64), Furkan Suresi, Suara Suresi (1-68)|3265386e-8e19-47dc-82ba-b76b34a88284
33|Suara Suresi (69-227), Neml Suresi (1-58)|68ee6b22-8861-42cf-81f8-a305e716ffde
34|Neml Suresi (59-93), Kasas Suresi (1-70)|62c8993d-a625-4e96-b9b8-8624676aeb1a
35|Kasas Suresi (71-88), Rum Suresi (1-19)|09b939f9-18ea-403e-99d0-537c6db4eac4
36|Rum Suresi (20-60), Lokman Suresi, Secde Suresi|27408034-701d-41a2-9256-1d951cba72c6
37|Ahzab Suresi, Sebe Suresi (1-14)|8470bedc-79ca-4e48-b9c6-8a2f6bebe6ac
38|Sebe Suresi (15-54), Fatir Suresi, Yasin Suresi (1-12)|3fa96e60-61a7-4769-baac-6d9313061158
39|Yasin Suresi (13-83), Saffat Suresi (1-163)|27f287b5-b921-44bb-bea8-c072df8cdea4
40|Saffat Suresi (164-182), Sad Suresi, Zumer Suresi (1-37)|76a09d2e-0e63-4d7c-879d-14ef3fa634b0
41|Zumer Suresi (38-75), Mumin Suresi (1-76)|4c0f5db2-5203-45e4-985d-1f78e57e90cd
42|Mumin Suresi (77-85), Fussilet Suresi, Sura Suresi (1-43)|42a94769-d96b-4085-9876-16ddc7edfedb
43|Sura Suresi (44), Zuhruf Suresi, Duhan Suresi, Casiye Suresi (1-13)|c6860e8c-a69d-4f5e-a578-1c00acddb30f
44|Casiye Suresi (14-37), Ahkaf Suresi, Muhammed Suresi|2489d861-0621-42bb-979a-26b0146d2d15
45|Fetih Suresi, Hucurat Suresi, Kaf Suresi, Zariyat Suresi (1-47)|63990894-f957-4568-9310-610145e7f7c0
46|Zariyat Suresi (48-60), Tur, Necm, Kamer, Rahman Sureleri|d0be1116-9fa5-4c31-bbba-ed0a0fcbddd4
47|Vakia Suresi, Hadid Suresi, Mucadele Suresi|ca7652cf-4e40-4e34-a577-f7a4e2e06fd9
48|Hasr, Mumtehine, Saf, Cuma, Tegabun Sureleri|8f1b1e55-ec19-46d9-ad7a-cfa4f0889512
49|Talak, Tahrim, Mulk, Kalem, Hakka Sureleri|a801f614-0f6c-493f-8601-abe53940241f
50|Mearic, Nuh, Cin, Muzzemmil, Muddessir, Kiyamet Sureleri, Insan (1-22)|54bfc50a-e671-4548-92fb-22fe868cfdce
51|Insan Suresi (23-31), Murselat Suresinden Tarik Suresine Kadar|7b4865b7-0fba-40c0-931d-369e1028ea25
52|Ala Suresinden Nas Suresine Kadar|daaad9ed-7d44-4c8a-9eb9-05982f0ddccc
'@

$All = foreach ($line in $RAW -split "`r?`n") {
  if ($line.Trim()) {
    $p = $line -split '\|'
    [pscustomobject]@{ No = [int]$p[0]; Ad = $p[1]; Id = $p[2] }
  }
}

# -Bolum süzgeci: "1-10" ya da "3,7,40" ya da ikisi karışık
$Sec = $All
if ($Bolum.Trim()) {
  $want = New-Object System.Collections.Generic.HashSet[int]
  foreach ($part in $Bolum -split ',') {
    $part = $part.Trim()
    if ($part -match '^(\d+)\s*-\s*(\d+)$') {
      [int]$matches[1]..[int]$matches[2] | ForEach-Object { [void]$want.Add($_) }
    } elseif ($part -match '^\d+$') {
      [void]$want.Add([int]$part)
    }
  }
  $Sec = $All | Where-Object { $want.Contains($_.No) }
}

$Sec = @($Sec)
if ($Sec.Count -eq 0) { Write-Host "Seçime uyan bölüm yok." -ForegroundColor Yellow; return }

if (-not (Test-Path $Klasor)) { New-Item -ItemType Directory -Path $Klasor | Out-Null }
$Hedef = (Resolve-Path $Klasor).Path
Write-Host "Klasör : $Hedef"
Write-Host "Bölüm  : $($Sec.Count) dosya"
Write-Host ""

$ok = 0; $atlanan = 0; $hata = 0; $i = 0

foreach ($e in $Sec) {
  $i++
  $ad = "{0:D2} - {1}.mp3" -f $e.No, ($e.Ad -replace '[\\/:*?"<>|]', '-')
  $yol = Join-Path $Hedef $ad
  $etiket = "[$i/$($Sec.Count)] $ad"

  # Uzaktaki boyutu öğren; dosya tamsa atla (yeniden çalıştırmayı ucuzlatır)
  $uzunluk = 0
  try {
    $h = Invoke-WebRequest -Uri "$BASE$($e.Id)" -Method Head -UseBasicParsing
    $uzunluk = [int64]$h.Headers['Content-Length']
  } catch { }

  if ((Test-Path $yol) -and $uzunluk -gt 0 -and (Get-Item $yol).Length -eq $uzunluk) {
    Write-Host "$etiket  — zaten var, atlandı" -ForegroundColor DarkGray
    $atlanan++
    continue
  }

  $mb = ""
  if ($uzunluk -gt 0) { $mb = " ({0:N1} MB)" -f ($uzunluk / 1048576) }
  Write-Host "$etiket$mb" -NoNewline

  $gecici = "$yol.indiriliyor"
  try {
    $sw = [Diagnostics.Stopwatch]::StartNew()
    # BITS varsa onu kullan: kesintide devam eder, ilerleme gösterir
    $bits = Get-Command Start-BitsTransfer -ErrorAction SilentlyContinue
    if ($bits) {
      Start-BitsTransfer -Source "$BASE$($e.Id)" -Destination $gecici -Description $ad -ErrorAction Stop
    } else {
      Invoke-WebRequest -Uri "$BASE$($e.Id)" -OutFile $gecici -UseBasicParsing -ErrorAction Stop
    }
    $sw.Stop()

    $boyut = (Get-Item $gecici).Length
    if ($uzunluk -gt 0 -and $boyut -ne $uzunluk) {
      throw "Eksik indi ($boyut / $uzunluk bayt)"
    }
    Move-Item -Path $gecici -Destination $yol -Force
    Write-Host ("  OK {0:N1} MB, {1:N0} sn" -f ($boyut / 1048576), $sw.Elapsed.TotalSeconds) -ForegroundColor Green
    $ok++
  } catch {
    if (Test-Path $gecici) { Remove-Item $gecici -Force -ErrorAction SilentlyContinue }
    Write-Host "  HATA: $($_.Exception.Message)" -ForegroundColor Red
    $hata++
  }
}

Write-Host ""
Write-Host "Bitti. $ok indirildi, $atlanan atlandı, $hata başarısız." -ForegroundColor Cyan
Write-Host "Konum: $Hedef"
if ($hata -gt 0) { Write-Host "Başarısızlar için betiği tekrar çalıştırın; tamamlananlar atlanır." -ForegroundColor Yellow }
