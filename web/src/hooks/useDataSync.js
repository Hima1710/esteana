import { useCallback, useEffect, useState } from 'react';
import {
  addDailyActionLog,
  getUnsyncedDailyActionLogs,
  markDailyActionLogSynced,
} from '../db/database';
import { insertDailyLogToSupabase } from '../lib/supabase';

/**
 * هوك موحد لإدارة المزامنة التلقائية مع Supabase.
 * المزامنة تتم فقط عند توفر الإنترنت (online).
 */
export function useDataSync() {
  const [isSyncing, setIsSyncing] = useState(false);
  const [lastSyncAt, setLastSyncAt] = useState(null);
  const [isOnline, setIsOnline] = useState(
    typeof navigator !== 'undefined' ? navigator.onLine : true
  );

  const syncUnsynced = useCallback(async () => {
    if (!navigator.onLine) return;
    setIsSyncing(true);
    try {
      const unsynced = await getUnsyncedDailyActionLogs();
      for (const log of unsynced) {
        const { error } = await insertDailyLogToSupabase({
          action_type: log.action_type,
          payload: log.payload,
          created_at: log.created_at,
        });
        if (!error) await markDailyActionLogSynced(log.id);
      }
      if (unsynced.length) setLastSyncAt(new Date());
    } finally {
      setIsSyncing(false);
    }
  }, []);

  const logAction = useCallback(async (action_type, payload = null) => {
    const id = await addDailyActionLog({ action_type, payload });
    await syncUnsynced();
    return id;
  }, [syncUnsynced]);

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
    logAction,
    syncUnsynced,
    isSyncing,
    lastSyncAt,
    isOnline,
  };
}
