import { isQuranStoreEmpty, downloadQuranData } from './db/database';

function logInit(msg) {
  const full = '[initQuran] ' + msg;
  try {
    console.log(full);
    const b = typeof window !== 'undefined' && (window.Android || window.AndroidBridge);
    if (b && typeof b.log === 'function') b.log(full);
  } catch (_) {}
}

/**
 * عند أول تشغيل (Splash): إذا كان مخزن quran فارغاً، جلب المصحف من الملف المحلي quran.json وتخزينه في IndexedDB (MuslimJourneyDB).
 */
export async function initQuranIfEmpty() {
  logInit('start');
  const empty = await isQuranStoreEmpty();
  logInit('isQuranStoreEmpty=' + empty);
  if (!empty) {
    logInit('skip: store not empty');
    return;
  }
  const result = await downloadQuranData();
  logInit('downloadQuranData ok=' + (result?.ok ?? false) + (result?.error ? ' error=' + result.error : ''));
}
