import { getAssetJson } from './androidBridge';

const WISDOM_URL = '/daily-wisdom.json';
const WISDOM_ASSET = 'web/daily-wisdom.json';
let cachedList = null;

/**
 * جلب قائمة الحكم من الملف المحلي (مرّة واحدة). في WebView (file://) نستخدم جسر أندرويد.
 * @returns {Promise<Array<{ type: string, text: string, source: string }>>}
 */
export async function fetchDailyWisdomList() {
  if (cachedList) return cachedList;
  if (typeof window !== 'undefined' && window.location?.protocol === 'file:') {
    const data = await getAssetJson(WISDOM_ASSET);
    cachedList = Array.isArray(data) ? data : [];
    return cachedList;
  }
  const res = await fetch(WISDOM_URL);
  if (!res.ok) return [];
  const list = await res.json();
  cachedList = Array.isArray(list) ? list : [];
  return cachedList;
}

/**
 * اختيار حكمة اليوم بشكل ثابت حسب التاريخ (نفس اليوم = نفس الحكمة).
 * @param {string} [dateKey] YYYY-MM-DD، إن لم يُمرَّر يُستخدم تاريخ اليوم.
 * @returns {Promise<{ type: string, text: string, source: string } | null>}
 */
export async function getWisdomForDay(dateKey) {
  const list = await fetchDailyWisdomList();
  if (list.length === 0) return null;
  const key = dateKey ?? new Date().toISOString().slice(0, 10);
  let hash = 0;
  for (let i = 0; i < key.length; i++) hash = (hash * 31 + key.charCodeAt(i)) >>> 0;
  const index = hash % list.length;
  return list[index];
}
