import { useState, useEffect, useCallback } from 'react';
import { getSettings, saveSettings, getDailyLogsForToday } from '../db/database';
import { getAssetJson } from '../lib/androidBridge';
import { TASKS_BY_AGE_GROUP } from '../constants/athariTasks';

const DAILY_ACTIONS_JSON = '/daily_actions.json';
const DAILY_ACTIONS_ASSET = 'web/daily_actions.json';

/**
 * جلب daily_actions.json — من الجسر في WebView (file://) أو fetch في المتصفح.
 */
async function loadDailyActionsJson() {
  if (typeof window !== 'undefined' && window.location?.protocol === 'file:') {
    const data = await getAssetJson(DAILY_ACTIONS_ASSET);
    if (data && typeof data === 'object') return data;
  }
  try {
    const r = await fetch(DAILY_ACTIONS_JSON);
    return r.ok ? await r.json() : null;
  } catch {
    return null;
  }
}

/**
 * حالة تاب أثري: age_group من IndexedDB، قائمة المهام من daily_actions.json (أو الاحتياطي)، ومجموعة ما تم إنجازه اليوم.
 */
export function useAthari() {
  const [ageGroup, setAgeGroupState] = useState(null);
  const [completedToday, setCompletedToday] = useState([]);
  const [tasksByAge, setTasksByAge] = useState(TASKS_BY_AGE_GROUP);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;
    loadDailyActionsJson()
      .then((data) => {
        if (!cancelled && data && typeof data === 'object') setTasksByAge(data);
      })
      .catch(() => {});
    return () => { cancelled = true; };
  }, []);

  const refresh = useCallback(async () => {
    const logs = await getDailyLogsForToday();
    setCompletedToday(logs.map((l) => l.action_type));
  }, []);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      const settings = await getSettings();
      if (!cancelled) {
        setAgeGroupState(settings?.age_group ?? null);
        setLoading(false);
      }
    })();
    return () => { cancelled = true; };
  }, []);

  useEffect(() => {
    if (ageGroup == null) return;
    let cancelled = false;
    (async () => {
      const logs = await getDailyLogsForToday();
      if (!cancelled) setCompletedToday(logs.map((l) => l.action_type));
    })();
    return () => { cancelled = true; };
  }, [ageGroup]);

  const setAgeGroup = useCallback(async (group) => {
    await saveSettings({ age_group: group });
    setAgeGroupState(group);
    await refresh();
  }, [refresh]);

  const taskIds = ageGroup && tasksByAge[ageGroup] ? tasksByAge[ageGroup] : (tasksByAge.adult || TASKS_BY_AGE_GROUP.adult);
  const completedSet = new Set(completedToday);

  return {
    ageGroup,
    setAgeGroup,
    taskIds,
    completedSet,
    refresh,
    loading,
    needsOnboarding: ageGroup === null && !loading,
  };
}
