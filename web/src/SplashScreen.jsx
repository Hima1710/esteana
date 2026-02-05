import { useEffect, useState } from 'react';
import { initQuranIfEmpty } from './initQuranIfEmpty';
import { getStrings } from './constants/strings';
import { tokens } from './theme/tokens';

/**
 * شاشة البداية: تهيئة القرآن في IndexedDB إن كان المخزن فارغاً، ثم إظهار التطبيق.
 */
export function SplashScreen({ children }) {
  const [ready, setReady] = useState(false);
  const t = getStrings();

  useEffect(() => {
    let cancelled = false;
    (async () => {
      try {
        await initQuranIfEmpty();
      } finally {
        if (!cancelled) setReady(true);
      }
    })();
    return () => { cancelled = true; };
  }, []);

  if (!ready) {
    return (
      <div
        style={{
          position: 'fixed',
          inset: 0,
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          background: `linear-gradient(135deg, ${tokens.primary} 0%, ${tokens.secondary} 100%)`,
          color: tokens.onPrimary,
          fontFamily: tokens.typography.fontFamily,
        }}
      >
        <div
          style={{
            width: 48,
            height: 48,
            border: `3px solid ${tokens.primaryContainer}`,
            borderTopColor: tokens.onPrimary,
            borderRadius: '50%',
            animation: 'spin 0.8s linear infinite',
          }}
        />
        <p style={{ marginTop: 16, fontSize: 18 }}>{t.appName}</p>
        <p style={{ marginTop: 4, opacity: 0.8, fontSize: 14 }}>{t.splash.loading}</p>
        <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
      </div>
    );
  }

  return children;
}
