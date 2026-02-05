import { getStrings } from '../constants/strings';
import { tokens } from '../theme/tokens';
import { AppCard, AppButton, LinearProgress, AppIcon } from '../components';
import { useDataSync } from '../hooks/useDataSync';
import { triggerVibration } from '../lib/androidBridge';
import { useAthari } from '../hooks/useAthari';
import { AgeOnboarding } from './athari/AgeOnboarding';

const checklistItemStyle = (done, isLast) => ({
  display: 'flex',
  alignItems: 'center',
  gap: 12,
  padding: '14px 16px',
  borderTopWidth: 0,
  borderLeftWidth: 0,
  borderRightWidth: 0,
  borderBottomWidth: isLast ? 0 : 1,
  borderBottomStyle: 'solid',
  borderBottomColor: tokens.outlineVariant,
  backgroundColor: done ? tokens.primaryContainer : tokens.surfaceContainerLowest,
  color: done ? tokens.onPrimaryContainer : tokens.onSurface,
  cursor: 'pointer',
  textAlign: 'right',
  width: '100%',
  boxSizing: 'border-box',
  fontFamily: 'inherit',
  fontSize: 16,
});

export function AthariPage() {
  const t = getStrings();
  const { logAction, isSyncing, isOnline } = useDataSync();
  const { needsOnboarding, ageGroup, setAgeGroup, taskIds, completedSet, refresh } = useAthari();

  const handleTaskPress = async (actionType) => {
    await logAction(actionType, {});
    triggerVibration();
    await refresh();
  };

  if (needsOnboarding) {
    return (
      <div style={{ padding: 16 }}>
        <h1 style={{ marginBottom: 4 }}>{t.athari.title}</h1>
        <p style={{ color: tokens.onSurfaceVariant, marginBottom: 24, fontSize: 14 }}>{t.athari.subtitle}</p>
        <AgeOnboarding onSelect={setAgeGroup} />
      </div>
    );
  }

  const completedCount = taskIds.filter((id) => completedSet.has(id)).length;
  const total = taskIds.length;
  const progressValue = total ? completedCount : 0;
  const progressMax = total || 1;

  return (
    <div style={{ padding: 16 }}>
      <p style={{ fontSize: 14, color: tokens.onSurfaceVariant, marginBottom: 6 }}>{t.athari.progressLabel}</p>
      <LinearProgress value={progressValue} max={progressMax} style={{ marginBottom: 16 }} />

      <h1 style={{ marginBottom: 4 }}>{t.athari.title}</h1>
      <p style={{ color: tokens.onSurfaceVariant, marginBottom: 8, fontSize: 14 }}>{t.athari.subtitle}</p>
      <p style={{ color: tokens.outline, marginBottom: 16, fontSize: 13 }}>
        {isOnline ? t.status.online : t.status.offline}
        {isSyncing && ` — ${t.status.syncing}`}
      </p>

      <AppCard style={{ padding: 0, overflow: 'hidden' }}>
        {taskIds.map((actionType, index) => {
          const done = completedSet.has(actionType);
          const isLast = index === taskIds.length - 1;
          const label = t.athari.tasks[actionType] ?? actionType;
          return (
            <button
              key={actionType}
              type="button"
              style={checklistItemStyle(done, isLast)}
              onClick={() => handleTaskPress(actionType)}
            >
              <span style={{ flex: 1 }}>{label}</span>
              <AppIcon name={done ? 'check_circle' : 'radio_button_unchecked'} size={22} fill={done} />
            </button>
          );
        })}
      </AppCard>
    </div>
  );
}
