// Diyanet Kur'an Radyo mp3'leri için indirme proxy'si (Cloudflare Workers).
// Kaynak sunucu CORS başlığı göndermediği için tarayıcı, sayfadan doğrudan
// mp3 çekmeyi engelliyor. Bu worker dosyayı CORS başlıklarıyla yeniden sunar,
// böylece siteden toplu indirme çalışır.

const BASE = "https://diyanetkuranradyo.com/assets/";
const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, HEAD, OPTIONS",
  "Access-Control-Allow-Headers": "Range",
  "Access-Control-Expose-Headers": "Content-Length, Content-Range, Accept-Ranges, Content-Disposition"
};

export default {
  async fetch(req) {
    if (req.method === "OPTIONS") return new Response(null, { status: 204, headers: CORS });
    if (req.method !== "GET" && req.method !== "HEAD") {
      return new Response("Yöntem desteklenmiyor", { status: 405, headers: CORS });
    }

    // /dl/<uuid>  ya da  /dl/<uuid>/<dosya-adi>.mp3  (baştaki /dl isteğe bağlı)
    const parts = new URL(req.url).pathname.split("/").filter(Boolean);
    if (parts[0] === "dl") parts.shift();
    const id = parts[0] || "";
    if (!UUID.test(id)) return new Response("Geçersiz kimlik", { status: 400, headers: CORS });

    const name = parts[1] ? decodeURIComponent(parts[1]) : id + ".mp3";
    const safe = name.replace(/[\\/:*?"<>|\r\n]/g, "-").slice(0, 150);

    let upstream;
    try {
      upstream = await fetch(BASE + id, {
        method: req.method,
        headers: req.headers.get("range") ? { Range: req.headers.get("range") } : {}
      });
    } catch {
      return new Response("Kaynağa ulaşılamadı", { status: 502, headers: CORS });
    }

    if (!upstream.ok && upstream.status !== 206) {
      return new Response("Kaynak hatası: " + upstream.status,
        { status: upstream.status, headers: CORS });
    }

    const h = new Headers(CORS);
    h.set("Content-Type", "audio/mpeg");
    h.set("Accept-Ranges", "bytes");
    h.set("Cache-Control", "public, max-age=86400");
    h.set("Content-Disposition",
      'attachment; filename="' + safe.replace(/"/g, "") + '"; ' +
      "filename*=UTF-8''" + encodeURIComponent(safe));
    for (const k of ["content-length", "content-range"]) {
      const v = upstream.headers.get(k);
      if (v) h.set(k, v);
    }

    // Gövde akıtılarak geçirilir; dosyalar ~55 MB, belleğe alınmaz.
    return new Response(req.method === "HEAD" ? null : upstream.body,
      { status: upstream.status, headers: h });
  }
};
