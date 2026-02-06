import { openDB } from 'idb';

const DB_NAME = 'MuslimJourneyDB';
const DB_VERSION = 1;

let dbPromise = null;

/**
 * قاعدة بيانات Hybrid Offline-First موحدة — MuslimJourneyDB.
 * المخازن:
 * - settings: الفئة العمرية، الاسم، حجم الخط، آخر مكان وقوف في المصحف، الثيم
 * - quran: نصوص المصحف بالرسم العثماني (سجل واحد لكل سورة)
 * - heart_touched: الآيات التي لمست قلب المستخدم
 * - daily_actions_logs: سجل الأفعال اليومية مع علم المزامنة لـ Supabase
 */
export function openMuslimJourneyDB() {
  if (dbPromise) return dbPromise;
  dbPromise = openDB(DB_NAME, DB_VERSION, {
    upgrade(db) {
      if (!db.objectStoreNames.contains('settings')) {
        const s = db.createObjectStore('settings', { keyPath: 'id' });
        s.createIndex('by_key', 'id', { unique: true });
      }
      if (!db.objectStoreNames.contains('quran')) {
        const q = db.createObjectStore('quran', { keyPath: 'number' });
        q.createIndex('by_number', 'number', { unique: true });
      }
      if (!db.objectStoreNames.contains('heart_touched')) {
        const h = db.createObjectStore('heart_touched', { keyPath: 'id' });
        h.createIndex('surah_ayah', ['surahNumber', 'ayahNumber'], { unique: true });
        h.createIndex('addedAt', 'addedAt', { unique: false });
      }
      if (!db.objectStoreNames.contains('daily_actions_logs')) {
        const d = db.createObjectStore('daily_actions_logs', { keyPath: 'id' });
        d.createIndex('created_at', 'created_at', { unique: false });
      }
    },
  });
  return dbPromise;
}

// ——— Settings ———
const SETTINGS_ID = 'profile';

/**
 * @param {{ age_group?: string, name?: string, displayName?: string, fontSize?: number, lastQuranPosition?: { surahNumber: number, ayahNumber: number }, theme?: 'light'|'dark'|'sepia' }} data
 */
export async function saveSettings(data) {
  const db = await openMuslimJourneyDB();
  const existing = await db.get('settings', SETTINGS_ID);
  await db.put('settings', { id: SETTINGS_ID, ...existing, ...data, updatedAt: new Date().toISOString() });
}

export async function getSettings() {
  const db = await openMuslimJourneyDB();
  const row = await db.get('settings', SETTINGS_ID);
  return row ?? null;
}

// ——— Quran (مصحف عثماني: سجل واحد لكل سورة) ———
// مسار الملف: يُعتبر quran.json موجوداً في src/assets/data/؛ يُخدم من public/quran.json (ويب) و assets/web/quran.json (أندرويد).
// نستخدم fetch للمسار المحلي فقط (بدون استيراد ثقيل) لتفادي بطء شاشة البداية.

/** أسماء السور بالعربية (لتحويل الملف المحلي) */
const SURAH_NAMES_AR = [
  'الفاتحة', 'البقرة', 'آل عمران', 'النساء', 'المائدة', 'الأنعام', 'الأعراف', 'الأنفال', 'التوبة', 'يونس',
  'هود', 'يوسف', 'الرعد', 'إبراهيم', 'الحجر', 'النحل', 'الإسراء', 'الكهف', 'مريم', 'طه',
  'الأنبياء', 'الحج', 'المؤمنون', 'النور', 'الفرقان', 'الشعراء', 'النمل', 'القصص', 'العنكبوت', 'الروم',
  'لقمان', 'السجدة', 'الأحزاب', 'سبأ', 'فاطر', 'يس', 'الصافات', 'ص', 'الزمر', 'غافر',
  'فصلت', 'الشورى', 'الزخرف', 'الدخان', 'الجاثية', 'الأحقاف', 'محمد', 'الفتح', 'الحجرات', 'ق',
  'الذاريات', 'الطور', 'النجم', 'القمر', 'الرحمن', 'الواقعة', 'الحديد', 'المجادلة', 'الحشر', 'الممتحنة',
  'الصف', 'الجمعة', 'المنافقون', 'التغابن', 'الطلاق', 'التحريم', 'الملك', 'القلم', 'الحاقة', 'المعارج',
  'نوح', 'الجن', 'المزمل', 'المدثر', 'القيامة', 'الإنسان', 'المرسلات', 'النبأ', 'النازعات', 'عبس',
  'التكوير', 'الانفطار', 'المطففين', 'الانشقاق', 'البروج', 'الطارق', 'الأعلى', 'الغاشية', 'الفجر', 'البلد',
  'الشمس', 'الليل', 'الضحى', 'الشرح', 'التين', 'العلق', 'القدر', 'البينة', 'الزلزلة', 'العاديات',
  'القارعة', 'التكاثر', 'العصر', 'الهمزة', 'الفيل', 'قريش', 'الماعون', 'الكوثر', 'الكافرون', 'النصر',
  'المسد', 'الإخلاص', 'الفلق', 'الناس',
];

/**
 * يحوّل مصحفاً بصيغة مسطحة [{ id, sura, aya, text }] إلى سور بالصيغة المتوقعة في المخزن.
 */
function flatToSurahs(flat) {
  if (!Array.isArray(flat) || flat.length === 0) return [];
  const bySura = new Map();
  for (const a of flat) {
    const suraNum = Number(a.sura) || 1;
    if (!bySura.has(suraNum)) {
      bySura.set(suraNum, {
        number: suraNum,
        name: SURAH_NAMES_AR[suraNum - 1] || `سورة ${suraNum}`,
        englishName: '',
        englishNameTranslation: '',
        revelationType: '',
        ayahs: [],
      });
    }
    const ayahNum = Number(a.aya) || 1;
    bySura.get(suraNum).ayahs.push({
      number: ayahNum,
      numberInSurah: ayahNum,
      text: a.text || '',
    });
  }
  return Array.from(bySura.values()).sort((a, b) => a.number - b.number);
}

/** في WebView نطلب الـ assets من هذا الأصل؛ الأندرويد يعترض الطلب ويرد من الـ assets. */
const ANDROID_ASSET_BASE = 'https://app.esteana.local';
/** true عند التشغيل داخل أندرويد (file:// أو تحميل من app.esteana.local عبر loadDataWithBaseURL). */
const isAndroidAssetHost = typeof window !== 'undefined' && (
  window.location?.protocol === 'file:' || window.location?.hostname === 'app.esteana.local'
);

/** يُرجع الأساس للمسارات المحلية (ويب: نفس أصل الصفحة؛ أندرويد: app.esteana.local). */
function getLocalBaseUrl() {
  if (typeof window === 'undefined') return '';
  if (isAndroidAssetHost) return ANDROID_ASSET_BASE + '/';
  const u = window.location?.href ?? '';
  const last = u.lastIndexOf('/');
  return last >= 0 ? u.slice(0, last + 1) : u + (u.endsWith('/') ? '' : '/');
}

/** إرسال رسالة إلى Console و Logcat (للتتبع عند عدم فتح القرآن). */
function logQuran(msg) {
  const full = '[Quran] ' + msg;
  try {
    console.log(full);
    if (typeof window !== 'undefined') {
      const b = window.Android || window.AndroidBridge;
      if (b && typeof b.log === 'function') b.log(full);
    }
  } catch (_) {}
}

/**
 * تحميل المصحف من ملف JSON المحلي فقط (متوافق مع WebView الأندرويد).
 * يُستخدم fetch للمسار المحلي دون استيراد ثقيل؛ مع try-catch ورسائل واضحة في الـ Console.
 */
async function loadQuranFromLocalJson() {
  const base = getLocalBaseUrl();
  const primaryUrl = base + 'quran.json';
  let flat = null;

  try {
    logQuran('fetch start: ' + primaryUrl);
    const res = await fetch(primaryUrl);
    logQuran('fetch done: ' + primaryUrl + ' status=' + (res && res.status));
    if (!res.ok) {
      const msg = `[Quran] فشل تحميل quran.json: HTTP ${res.status} من ${primaryUrl}`;
      logQuran('fetch fail: ' + primaryUrl + ' status=' + res.status);
      console.error(msg);
      if (isAndroidAssetHost && typeof window !== 'undefined' && (window.AndroidBridge || window.Android)?.loadAsset) {
        flat = await loadQuranViaAndroidBridge();
      }
      if (!flat) return { ok: false, error: msg };
    } else {
      flat = await res.json();
      logQuran('fetch parsed: verses=' + (Array.isArray(flat) ? flat.length : 0));
    }
  } catch (e) {
    const msg = `[Quran] خطأ عند تحميل quran.json: ${e?.message || String(e)}`;
    logQuran('fetch error: ' + primaryUrl + ' ' + (e?.message || ''));
    console.error(msg);
    if (isAndroidAssetHost && typeof window !== 'undefined' && (window.AndroidBridge || window.Android)?.loadAsset) {
      flat = await loadQuranViaAndroidBridge();
    }
    if (!flat) return { ok: false, error: msg };
  }

  if (!Array.isArray(flat) || flat.length === 0) {
    const msg = '[Quran] لا توجد بيانات مصحف صالحة في الملف المحلي.';
    logQuran('loadQuranFromLocalJson: no data');
    console.error(msg);
    return { ok: false, error: msg };
  }
  const surahs = flatToSurahs(flat);
  if (surahs.length === 0) {
    const msg = '[Quran] تحويل الملف المحلي إلى سور فشل (صيغة غير متوقعة).';
    logQuran('loadQuranFromLocalJson: flatToSurahs empty');
    console.error(msg);
    return { ok: false, error: msg };
  }
  try {
    logQuran('loadQuranFromLocalJson: saving surahs=' + surahs.length);
    const db = await openMuslimJourneyDB();
    const tx = db.transaction('quran', 'readwrite');
    for (const s of surahs) {
      await tx.store.put({
        number: s.number,
        name: s.name,
        englishName: s.englishName || '',
        englishNameTranslation: s.englishNameTranslation || '',
        revelationType: s.revelationType || '',
        ayahs: s.ayahs || [],
      });
    }
    await tx.done;
    logQuran('loadQuranFromLocalJson: done');
    return { ok: true };
  } catch (err) {
    const msg = `[Quran] فشل حفظ المصحف في IndexedDB: ${err?.message || String(err)}`;
    console.error(msg);
    return { ok: false, error: msg };
  }
}

/**
 * جلب مصحف من أصول الأندرويد عبر الجسر (عند فشل fetch في WebView).
 */
async function loadQuranViaAndroidBridge() {
  try {
    const { getAssetJson } = await import('../lib/androidBridge.js');
    const data = await getAssetJson('web/quran.json');
    if (Array.isArray(data) && data.length > 0) return data;
  } catch (e) {
    logQuran('Android bridge load fail: ' + (e?.message || ''));
    console.error('[Quran] جلب المصحف عبر جسر الأندرويد فشل:', e?.message || e);
  }
  return null;
}

/**
 * تحميل بيانات المصحف: إن وُجدت في IndexedDB لا نُعيد التحميل؛ وإلا نقرأ من الملف المحلي quran.json فقط.
 */
export async function downloadQuranData() {
  try {
    const base = typeof window !== 'undefined' ? getLocalBaseUrl() : '';
    logQuran('downloadQuranData: start | isAndroid=' + isAndroidAssetHost + ' | base=' + base);
    const empty = await isQuranStoreEmpty();
    logQuran('downloadQuranData: isQuranStoreEmpty=' + empty);
    if (!empty) {
      logQuran('downloadQuranData: البيانات موجودة في IndexedDB، تخطي التحميل');
      return { ok: true };
    }
    logQuran('downloadQuranData: جلب من الملف المحلي quran.json');
    const result = await loadQuranFromLocalJson();
    if (result.ok) logQuran('downloadQuranData: تم التخزين في IndexedDB');
    else logQuran('downloadQuranData: فشل - ' + (result.error || ''));
    return result;
  } catch (err) {
    const msg = `[Quran] خطأ غير متوقع في تحميل المصحف: ${err?.message || String(err)}`;
    console.error(msg);
    logQuran('downloadQuranData: exception ' + (err?.message || ''));
    return { ok: false, error: msg };
  }
}

export async function isQuranStoreEmpty() {
  const db = await openMuslimJourneyDB();
  const count = await db.count('quran');
  return count === 0;
}

export async function getSurahs() {
  const db = await openMuslimJourneyDB();
  const list = await db.getAll('quran');
  return list.sort((a, b) => (a.number || 0) - (b.number || 0));
}

export async function getSurah(surahNumber) {
  const db = await openMuslimJourneyDB();
  const surah = await db.get('quran', Number(surahNumber));
  return surah ?? null;
}

// ——— Heart Touched (آيات لمست قلبي) ———

/**
 * @param {{ surahNumber: number, ayahNumber: number, text?: string }}
 */
export async function addHeartTouched({ surahNumber, ayahNumber, text }) {
  const db = await openMuslimJourneyDB();
  const id = `${surahNumber}-${ayahNumber}`;
  await db.put('heart_touched', {
    id,
    surahNumber,
    ayahNumber,
    text: text ?? '',
    addedAt: new Date().toISOString(),
  });
  return id;
}

export async function removeHeartTouched(surahNumber, ayahNumber) {
  const db = await openMuslimJourneyDB();
  await db.delete('heart_touched', `${surahNumber}-${ayahNumber}`);
}

export async function isHeartTouched(surahNumber, ayahNumber) {
  const db = await openMuslimJourneyDB();
  const index = db.transaction('heart_touched').store.index('surah_ayah');
  const row = await index.get([surahNumber, ayahNumber]);
  return !!row;
}

export async function getAllHeartTouched() {
  const db = await openMuslimJourneyDB();
  const list = await db.getAll('heart_touched');
  return list.sort((a, b) => (a.addedAt || '').localeCompare(b.addedAt || ''));
}

// ——— Last Quran Position (مكان الوقوف) ———

export async function saveLastQuranPosition(surahNumber, ayahNumber) {
  await saveSettings({ lastQuranPosition: { surahNumber, ayahNumber } });
}

export async function getLastQuranPosition() {
  const s = await getSettings();
  return s?.lastQuranPosition ?? null;
}

// ——— Daily Actions Logs (سجل الأفعال اليومية + علم المزامنة) ———

export async function addDailyActionLog(action) {
  const db = await openMuslimJourneyDB();
  const id = crypto.randomUUID();
  const record = {
    id,
    action_type: action.action_type,
    payload: action.payload ?? null,
    created_at: new Date().toISOString(),
    synced: false,
  };
  await db.add('daily_actions_logs', record);
  return id;
}

export async function getUnsyncedDailyActionLogs() {
  const db = await openMuslimJourneyDB();
  const all = await db.getAll('daily_actions_logs');
  return all.filter((a) => a.synced === false);
}

export async function markDailyActionLogSynced(id) {
  const db = await openMuslimJourneyDB();
  const row = await db.get('daily_actions_logs', id);
  if (row) {
    row.synced = true;
    await db.put('daily_actions_logs', row);
  }
}

export async function getDailyActionLogsForToday() {
  const db = await openMuslimJourneyDB();
  const all = await db.getAll('daily_actions_logs');
  const today = new Date().toISOString().slice(0, 10);
  return all.filter((a) => (a.created_at || '').startsWith(today));
}

// ——— توافق مع أسماء قديمة ———
export const openEsteanaDB = openMuslimJourneyDB;
export const addDailyAction = addDailyActionLog;
export const addDailyLog = addDailyActionLog;
export const getUnsyncedDailyLogs = getUnsyncedDailyActionLogs;
export const markDailyLogSynced = markDailyActionLogSynced;
export const getDailyLogsForToday = getDailyActionLogsForToday;
export const getDailyActionsForToday = getDailyActionLogsForToday;
export const getUnsyncedDailyActions = getUnsyncedDailyActionLogs;
export const markDailyActionSynced = markDailyActionLogSynced;

export async function isSurahsStoreEmpty() {
  return isQuranStoreEmpty();
}
