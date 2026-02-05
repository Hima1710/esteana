import { isQuranStoreEmpty, downloadQuranData } from './db/database';

/**
 * عند أول تشغيل (Splash): إذا كان مخزن quran فارغاً، جلب المصحف من API (quran-uthmani) وتخزينه في MuslimJourneyDB.
 */
export async function initQuranIfEmpty() {
  const empty = await isQuranStoreEmpty();
  if (!empty) return;
  await downloadQuranData();
}
