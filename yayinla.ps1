# Oynatıcıyı yayına giden iki kopyaya dağıtır ve Firebase'e yayımlar.
# Kullanım:
#   .\yayinla.ps1              -> kopyala + deploy
#   .\yayinla.ps1 -SadeceKopya -> yalnızca kopyala (deploy etme)

param([switch]$SadeceKopya)

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
$kaynak = Join-Path $root "kuran-meal-player.html"

# public\index.html -> Firebase Hosting (kurandinle.web.app)
# index.html        -> GitHub Pages (kamilsaim.github.io/kurandinle)
# Ikisi de ana kaynagin kopyasidir; elle duzenlemeyin.
foreach ($hedef in @("public\index.html", "index.html")) {
  Copy-Item $kaynak (Join-Path $root $hedef) -Force
  Write-Host "$hedef guncellendi." -ForegroundColor Green
}

# Logo ve oynat/duraklat gorselleri HTML'in icine gomulu; ayrica kopyalanmasi gerekmiyor.
# Ikonlar (favicon, PWA) public\ altinda kalicidir.

if ($SadeceKopya) { return }

if (-not (Get-Command firebase -ErrorAction SilentlyContinue)) {
  Write-Host "firebase komutu bulunamadi. Once kurun:" -ForegroundColor Yellow
  Write-Host "  npm install -g firebase-tools" -ForegroundColor Yellow
  return
}

Write-Host "Yayimlaniyor..." -ForegroundColor Cyan
firebase deploy
