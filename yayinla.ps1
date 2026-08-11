# Oynatıcıyı public/ klasörüne kopyalar ve Firebase'e yayımlar.
# Kullanım:
#   .\yayinla.ps1              -> kopyala + deploy
#   .\yayinla.ps1 -SadeceKopya -> yalnızca kopyala (deploy etme)

param([switch]$SadeceKopya)

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot

Copy-Item (Join-Path $root "kuran-meal-player.html") (Join-Path $root "public\index.html") -Force
Write-Host "public\index.html guncellendi." -ForegroundColor Green

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
