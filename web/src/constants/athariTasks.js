/**
 * قائمة أفعال (action_type) لكل فئة عمرية.
 * المفاتيح يجب أن تطابق athari.tasks في strings.js
 */
export const TASKS_BY_AGE_GROUP = {
  child: [
    'prayer_simple',
    'dhikr_short',
    'quran_verse',
  ],
  both: [
    'fajr',
    'dhuhr',
    'asr',
    'maghrib',
    'isha',
    'dhikr_morning',
    'quran',
  ],
  adult: [
    'fajr',
    'dhuhr',
    'asr',
    'maghrib',
    'isha',
    'dhikr_morning',
    'dhikr_evening',
    'quran',
    'istighfar',
    'duaa',
  ],
};

/** الفئات المدعومة في الـ Onboarding */
export const AGE_GROUPS = ['child', 'both', 'adult'];
