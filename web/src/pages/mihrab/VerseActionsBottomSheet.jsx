import { memo } from 'react';
import { getStrings } from '../../constants/strings';
import { tokens, shape } from '../../theme/tokens';
import { AppIcon } from '../../components';

const SHEET_STYLE = (themeTokens) => ({
  position: 'fixed',
  left: 0,
  right: 0,
  bottom: 0,
  backgroundColor: themeTokens?.surface ?? tokens.surface,
  borderTopLeftRadius: shape.radiusLarge,
  borderTopRightRadius: shape.radiusLarge,
  padding: 24,
  paddingBottom: 'max(24px, env(safe-area-inset-bottom))',
  boxShadow: '0 -4px 20px rgba(0,0,0,0.15)',
  zIndex: 300,
});

const ROW_STYLE = (themeTokens) => ({
  display: 'flex',
  alignItems: 'center',
  gap: 16,
  padding: '12px 0',
  borderBottom: `1px solid ${themeTokens?.outlineVariant ?? tokens.outlineVariant}`,
  cursor: 'pointer',
  background: 'none',
  border: 'none',
  width: '100%',
  textAlign: 'right',
  fontFamily: 'inherit',
  fontSize: 16,
  color: themeTokens?.onSurface ?? tokens.onSurface,
});

/**
 * BottomSheet MD3 عند النقر على آية: علامة مرجعية، آية لمست قلبي، وضع التسميع.
 */
export const VerseActionsBottomSheet = memo(function VerseActionsBottomSheet({
  open,
  onClose,
  onBookmark,
  onHeartTouched,
  heartActive,
  hifzMode,
  onHifzModeChange,
  themeTokens,
}) {
  const t = getStrings();
  if (!open) return null;

  return (
    <>
      <div
        role="presentation"
        onClick={onClose}
        style={{
          position: 'fixed',
          inset: 0,
          backgroundColor: 'rgba(0,0,0,0.4)',
          zIndex: 299,
        }}
      />
      <div style={SHEET_STYLE(themeTokens)} role="dialog" aria-label={t.mihrab.verseActions}>
        <h3 style={{ margin: '0 0 8px', fontSize: 18 }}>{t.mihrab.verseActions}</h3>
        <button type="button" style={ROW_STYLE(themeTokens)} onClick={() => { onBookmark?.(); onClose(); }}>
          <AppIcon name="bookmark_add" size={24} />
          <span>{t.mihrab.bookmarkSave}</span>
        </button>
        <button type="button" style={ROW_STYLE(themeTokens)} onClick={() => { onHeartTouched?.(); onClose(); }}>
          <AppIcon name={heartActive ? 'favorite' : 'favorite_border'} size={24} fill={heartActive} />
          <span>{t.mihrab.heartTouchedSave}</span>
        </button>
        <div style={{ ...ROW_STYLE(themeTokens), cursor: 'default', display: 'flex', justifyContent: 'space-between' }}>
          <span>{t.mihrab.hifzMode}</span>
          <button
            type="button"
            role="switch"
            aria-checked={hifzMode}
            onClick={() => onHifzModeChange?.(!hifzMode)}
            style={{
              width: 48,
              height: 28,
              borderRadius: 14,
              border: 'none',
              background: hifzMode ? (themeTokens?.primary ?? tokens.primary) : (themeTokens?.outlineVariant ?? tokens.outlineVariant),
              cursor: 'pointer',
              position: 'relative',
            }}
          >
            <span
              style={{
                position: 'absolute',
                top: 2,
                left: hifzMode ? 22 : 2,
                width: 24,
                height: 24,
                borderRadius: 12,
                background: '#FFF',
                transition: 'left 0.2s',
              }}
            />
          </button>
        </div>
        <p style={{ margin: '8px 0 0', fontSize: 12, color: themeTokens?.onSurfaceVariant ?? tokens.onSurfaceVariant }}>{t.mihrab.hifzModeHint}</p>
      </div>
    </>
  );
});
