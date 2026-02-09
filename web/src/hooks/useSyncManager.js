import { useCallback, useEffect, useState } from 'react';
import {
  getSettings,
  saveSettings,
  addDailyAction,
  getUnsyncedDailyActions,
  markDailyActionSynced,
} from '../db/database';
import { insertDailyLogToSupabase } from '../lib/supabase';

/**
 * هوك إدارة المزامنة: يربط مخازن IndexedDB (settings، daily_actions، quran) بـ Supabase.
 * - عند وضع علامة (صح) على فعل وأنت أوفلاين: يُحفظ محلياً في daily_actions مع synced: false.
 * - فور عودة الإنترنت: تُزامَن الأفعال غير المُزامَنة مع السحاب ويُحدَّث synced إلى true.
 */
export function useSyncManager() {
  const [settings, setSettingsState] = useState(null);
  const [isSyncing, setIsSyncing] = useState(false);
  const [lastSyncAt, setLastSyncAt] = useState(null);
  const [isOnline, setIsOnline] = useState(
    typeof navigator !== 'undefined' ? navigator.onLine : true
  );

  const loadSettings = useCallback(async () => {
    const s = await getSettings();
    setSettingsState(s);
    return s;
  }, []);

  useEffect(() => {
    loadSettings();
  }, [loadSettings]);

  /** حفظ الإعدادات (العمر، الاسم المستعار) محلياً. */
  const setSettings = useCallback(async (data) => {
    await saveSettings(data);
    setSettingsState((prev) => ({ ...prev, ...data }));
  }, []);

  /** وضع علامة (صح) على فعل: حفظ محلي فوري ثم محاولة مزامنة إن وُجد اتصال. */
  const markActionDone = useCallback(async (action_type, payload = null) => {
    const id = await addDailyAction({ action_type, payload });
    await syncUnsynced();
    return id;
  }, []);

  /** مزامنة كل الأفعال غير المُزامَنة مع Supabase. */
  const syncUnsynced = useCallback(async () => {
    if (!navigator.onLine) return;
    setIsSyncing(true);
    try {
      const unsynced = await getUnsyncedDailyActions();
      for (const row of unsynced) {
        const { error } = await insertDailyLogToSupabase({
          action_type: row.action_type,
          payload: row.payload ?? null,
          created_at: row.created_at ?? new Date().toISOString(),
        });
        if (!error) await markDailyActionSynced(row.id);
      }
      if (unsynced.length) setLastSyncAt(new Date());
    } finally {
      setIsSyncing(false);
    }
  }, []);

  useEffect(() => {
    const handleOnline = () => {
      setIsOnline(true);
      syncUnsynced();
    };
    const handleOffline = () => setIsOnline(false);
    window.addEventListener('online', handleOnline);
    window.addEventListener('offline', handleOffline);
    return () => {
      window.removeEventListener('online', handleOnline);
      window.removeEventListener('offline', handleOffline);
    };
  }, [syncUnsynced]);

  useEffect(() => {
    const handleFocus = () => syncUnsynced();
    window.addEventListener('focus', handleFocus);
    return () => window.removeEventListener('focus', handleFocus);
  }, [syncUnsynced]);

  return {
    settings,
    setSettings,
    loadSettings,
    markActionDone,
    syncUnsynced,
    isSyncing,
    lastSyncAt,
    isOnline,
  };
}
