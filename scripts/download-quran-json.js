#!/usr/bin/env node
/**
 * تحميل المصحف الكامل من api.alquran.cloud وحفظه بصيغة مسطحة في web/public/quran.json
 * للاستخدام الأوفلاين في التطبيق. يشغّل مرة واحدة: node scripts/download-quran-json.js
 */
const fs = require('fs');
const path = require('path');

const API = 'https://api.alquran.cloud/v1/quran/quran-uthmani';
const ROOT = path.resolve(__dirname, '..');
const OUT = path.join(ROOT, 'web', 'public', 'quran.json');

async function main() {
  console.log('جاري تحميل المصحف من الـ API...');
  const res = await fetch(API);
  if (!res.ok) throw new Error(`HTTP ${res.status}`);
  const json = await res.json();
  if (json.code !== 200 || !json.data?.surahs?.length) throw new Error('استجابة API غير صالحة');

  const flat = [];
  for (const s of json.data.surahs) {
    for (const a of s.ayahs || []) {
      flat.push({
        id: `${s.number}-${a.numberInSurah || a.number}`,
        sura: s.number,
        aya: a.numberInSurah ?? a.number,
        text: a.text || '',
      });
    }
  }

  fs.writeFileSync(OUT, JSON.stringify(flat, null, 0), 'utf8');
  console.log('تم الحفظ في', OUT, '— عدد الآيات:', flat.length);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
