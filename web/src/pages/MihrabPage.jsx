import { useState } from 'react';
import { getStrings } from '../constants/strings';
import { tokens, shape } from '../theme/tokens';
import { AppCard, AppIcon } from '../components';
import { toolsIcons } from '../constants/icons';
import { TasbihCounter } from './mihrab/TasbihCounter';
import { QuranModal } from './mihrab/QuranModal';

const toolsRowStyle = {
  display: 'flex',
  gap: 16,
  justifyContent: 'space-around',
  marginTop: 16,
  flexWrap: 'wrap',
};

const toolButtonStyle = {
  display: 'flex',
  flexDirection: 'column',
  alignItems: 'center',
  gap: 8,
  padding: 16,
  minWidth: 80,
  backgroundColor: tokens.surfaceContainer,
  border: 'none',
  borderRadius: shape.radiusMedium,
  cursor: 'pointer',
  color: tokens.onSurface,
  fontFamily: tokens.typography.fontFamily,
  fontSize: 14,
};

export function MihrabPage() {
  const t = getStrings();
  const [showTasbih, setShowTasbih] = useState(false);
  const [showQuran, setShowQuran] = useState(false);

  return (
    <div style={{ padding: 16 }}>
      <h1 style={{ marginBottom: 4 }}>{t.mihrab.title}</h1>
      <p style={{ color: tokens.onSurfaceVariant, marginBottom: 24, fontSize: 14 }}>{t.mihrab.subtitle}</p>

      <AppCard>
        <p style={{ margin: 0, fontSize: 14, color: tokens.onSurfaceVariant }}>{t.mihrab.contentPlaceholder}</p>
        <div style={{ borderTop: `1px solid ${tokens.outlineVariant}`, marginTop: 16, paddingTop: 16 }}>
          <p style={{ margin: 0, marginBottom: 8, fontWeight: 600, fontSize: 15 }}>{t.mihrab.toolsTitle}</p>
          <div style={toolsRowStyle}>
            <button
              type="button"
              style={toolButtonStyle}
              onClick={() => setShowQuran(true)}
              aria-label={t.mihrab.mushafLabel}
            >
              <AppIcon name={toolsIcons.quran} size={32} />
              <span>{t.mihrab.mushafLabel}</span>
            </button>
            <button
              type="button"
              style={toolButtonStyle}
              onClick={() => setShowTasbih(true)}
              aria-label={t.mihrab.toolTasbih}
            >
              <AppIcon name={toolsIcons.tasbih} size={32} />
              <span>{t.mihrab.toolTasbih}</span>
            </button>
            <button type="button" style={toolButtonStyle} onClick={() => {}} aria-label={t.mihrab.toolQibla}>
              <AppIcon name={toolsIcons.qibla} size={32} />
              <span>{t.mihrab.toolQibla}</span>
            </button>
          </div>
        </div>
      </AppCard>

      {showTasbih && <TasbihCounter onClose={() => setShowTasbih(false)} />}
      {showQuran && <QuranModal onClose={() => setShowQuran(false)} />}
    </div>
  );
}
