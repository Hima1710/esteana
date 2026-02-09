import { useCallback, useEffect, useState } from 'react';
import {
  addDailyLog,
  getUnsyncedDailyLogs,
  markDailyLogSynced,
} from '../db/database';
import { insertDailyLogToSupabase } from '../lib/supabase';

/**
 * هوك موحد Offline-First:
 * - تسجيل أي "فعل" (Action) يُحفظ فوراً في IndexedDB مع synced: false
 * - عند توفر الإنترنت يتم المزامنة تلقائياً مع Supabase وتحويل synced إلى true
 */
export function useOfflineSync() {
  const [isSyncing, setIsSyncing] = useState(false);
  const [lastSyncAt, setLastSyncAt] = useState(null);
  const [isOnline, setIsOnline] = useState(
    typeof navigator !== 'undefined' ? navigator.onLine : true
  );

  /** تسجيل فعل: حفظ محلي فوري ثم محاولة مزامنة إن وُجد اتصال */
  const logAction = useCallback(async (action_type, payload = null) => {
    const id = await addDailyLog({ action_type, payload });
    await syncUnsyncedLogs();
    return id;
  }, []);

  /** مزامنة كل السجلات غير المُزامَنة مع Supabase */
  const syncUnsyncedLogs = useCallback(async () => {
    if (!navigator.onLine) return;
    setIsSyncing(true);
    try {
      const unsynced = await getUnsyncedDailyLogs();
      for (const log of unsynced) {
        const { error } = await insertDailyLogToSupabase({
          action_type: log.action_type,
          payload: log.payload,
          created_at: log.created_at,
        });
        if (!error) await markDailyLogSynced(log.id);
      }
      if (unsynced.length) setLastSyncAt(new Date());
    } finally {
      setIsSyncing(false);
    }
  }, []);

  // استماع لتوفر الشبكة وإطلاق المزامنة
  useEffect(() => {
    const handleOnline = () => {
      setIsOnline(true);
      syncUnsyncedLogs();
    };
    const handleOffline = () => setIsOnline(false);
    window.addEventListener('online', handleOnline);
    window.addEventListener('offline', handleOffline);
    return () => {
      window.removeEventListener('online', handleOnline);
      window.removeEventListener('offline', handleOffline);
    };
  }, [syncUnsyncedLogs]);

  // مزامنة دورية خفيفة عند التركيز على النافذة
  useEffect(() => {
    const handleFocus = () => syncUnsyncedLogs();
    window.addEventListener('focus', handleFocus);
    return () => window.removeEventListener('focus', handleFocus);
  }, [syncUnsyncedLogs]);

  return {
    logAction,
    syncUnsyncedLogs,
    isSyncing,
    lastSyncAt,
    isOnline,
  };
}
