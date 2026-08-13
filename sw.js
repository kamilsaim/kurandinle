/* Kur'ân-ı Kerîm ve Meâli — service worker
 *
 * Amaç: site ya da şebeke kapalıyken arayüzün yine de açılması.
 * Ses dosyaları ASLA önbelleğe alınmaz (52 bölüm ~2,9 GB, ayrıca başka
 * bir alan adından geliyor) — yalnızca kabuk dosyaları saklanır.
 *
 * Sürümü değiştirmek eski önbelleği siler: dosyaları güncelleyince
 * SURUM değerini artır.
 */
const SURUM = "kuran-v1";
const KABUK = [
  "./",
  "./index.html",
  "./manifest.json",
  "./favicon-32.png",
  "./apple-touch-icon.png",
  "./icon-192.png",
  "./icon-512.png",
  "./icon-maskable.png"
];

self.addEventListener("install", e => {
  e.waitUntil(
    caches.open(SURUM)
      // Tek bir dosya bulunamazsa kurulum tümden çökmesin.
      .then(c => Promise.allSettled(KABUK.map(u => c.add(u))))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener("activate", e => {
  e.waitUntil(
    caches.keys()
      .then(ks => Promise.all(ks.filter(k => k !== SURUM).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", e => {
  const r = e.request;
  if (r.method !== "GET") return;

  const url = new URL(r.url);
  // Başka alan adları (ses, indirme proxy'si) ve Range istekleri doğrudan ağa gider.
  if (url.origin !== self.location.origin) return;
  if (r.headers.has("range")) return;

  const sayfa = r.mode === "navigate" || url.pathname.endsWith(".html");

  if (sayfa){
    // Sayfa: önce ağ (güncel sürüm gelsin), olmazsa önbellek.
    e.respondWith(
      fetch(r)
        .then(y => {
          const kopya = y.clone();
          caches.open(SURUM).then(c => c.put(r, kopya));
          return y;
        })
        .catch(() => caches.match(r).then(v => v || caches.match("./index.html")))
    );
    return;
  }

  // İkon vb.: önce önbellek, yoksa ağdan alıp sakla.
  e.respondWith(
    caches.match(r).then(v => v || fetch(r).then(y => {
      if (y.ok){
        const kopya = y.clone();
        caches.open(SURUM).then(c => c.put(r, kopya));
      }
      return y;
    }))
  );
});
