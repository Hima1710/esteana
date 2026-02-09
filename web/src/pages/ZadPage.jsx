import { useState, useEffect } from 'react';
import { getStrings } from '../constants/strings';
import { tokens } from '../theme/tokens';
import { getWisdomForDay } from '../lib/dailyWisdom';
import { DailyWisdomCard } from './zad/DailyWisdomCard';

export function ZadPage() {
  const t = getStrings();
  const [wisdom, setWisdom] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;
    getWisdomForDay()
      .then((w) => {
        if (!cancelled) {
          setWisdom(w);
          setLoading(false);
        }
      })
      .catch(() => {
        if (!cancelled) setLoading(false);
      });
    return () => { cancelled = true; };
  }, []);

  return (
    <div style={{ padding: 16 }}>
      <h1 style={{ marginBottom: 4 }}>{t.zad.title}</h1>
      <p style={{ color: tokens.onSurfaceVariant, marginBottom: 24, fontSize: 14 }}>{t.zad.subtitle}</p>
      <p style={{ fontSize: 15, fontWeight: 600, color: tokens.primary, marginBottom: 12 }}>
        {t.zad.dailyWisdomTitle}
      </p>
      {loading ? (
        <p style={{ color: tokens.onSurfaceVariant }}>...</p>
      ) : wisdom ? (
        <DailyWisdomCard wisdom={wisdom} />
      ) : (
        <p style={{ color: tokens.onSurfaceVariant }}>{t.zad.noWisdom}</p>
      )}
    </div>
  );
}
