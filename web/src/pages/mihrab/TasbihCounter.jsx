import { useState } from 'react';
import { getStrings } from '../../constants/strings';
import { tokens, shape } from '../../theme/tokens';
import { AppButton, AppIcon } from '../../components';
import { vibrate } from '../../lib/androidBridge';

const overlayStyle = {
  position: 'fixed',
  inset: 0,
  backgroundColor: 'rgba(0,0,0,0.5)',
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  zIndex: 200,
};

const modalStyle = {
  backgroundColor: tokens.surfaceContainerLowest,
  borderRadius: shape.radiusLarge,
  padding: 24,
  maxWidth: 320,
  width: '90%',
  boxShadow: '0 4px 20px rgba(0,0,0,0.15)',
};

export function TasbihCounter({ onClose }) {
  const t = getStrings();
  const [count, setCount] = useState(0);

  const handleIncrement = () => {
    setCount((c) => c + 1);
    vibrate();
  };

  const handleReset = () => setCount(0);

  return (
    <div style={overlayStyle} onClick={onClose} role="presentation">
      <div style={modalStyle} onClick={(e) => e.stopPropagation()} role="dialog" aria-label={t.mihrab.tasbihTitle}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
          <h2 style={{ margin: 0, fontSize: 18 }}>{t.mihrab.tasbihTitle}</h2>
          <button
            type="button"
            onClick={onClose}
            style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 4 }}
            aria-label={t.common.cancel}
          >
            <AppIcon name="close" size={24} />
          </button>
        </div>
        <p style={{ color: tokens.onSurfaceVariant, fontSize: 12, marginBottom: 8 }}>{t.mihrab.tasbihCount}</p>
        <div
          style={{
            fontSize: 48,
            fontWeight: 600,
            color: tokens.primary,
            textAlign: 'center',
            marginBottom: 24,
            fontFamily: tokens.typography.fontFamily,
          }}
        >
          {count}
        </div>
        <button
          type="button"
          onClick={handleIncrement}
          style={{
            width: '100%',
            padding: 16,
            fontSize: 18,
            fontWeight: 600,
            backgroundColor: tokens.primary,
            color: tokens.onPrimary,
            border: 'none',
            borderRadius: shape.radiusMedium,
            cursor: 'pointer',
            fontFamily: tokens.typography.fontFamily,
            marginBottom: 12,
          }}
        >
          +1
        </button>
        <AppButton variant="outlined" onClick={handleReset} style={{ width: '100%' }}>
          {t.mihrab.tasbihReset}
        </AppButton>
      </div>
    </div>
  );
}
