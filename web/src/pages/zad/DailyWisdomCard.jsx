import { useState } from 'react';
import { getStrings } from '../../constants/strings';
import { tokens, shape } from '../../theme/tokens';
import { AppButton, AppIcon } from '../../components';

const cardWrapStyle = {
  borderRadius: shape.radiusLarge,
  overflow: 'hidden',
  boxShadow: '0 8px 32px rgba(0,106,106,0.15)',
};

const cardInnerStyle = {
  padding: 28,
  background: `linear-gradient(145deg, ${tokens.surfaceContainerLowest} 0%, ${tokens.surfaceContainer} 100%)`,
  border: `2px solid ${tokens.outlineVariant}`,
  borderRadius: shape.radiusLarge,
  minHeight: 200,
  display: 'flex',
  flexDirection: 'column',
  justifyContent: 'center',
  position: 'relative',
};

const cardDecoStyle = {
  position: 'absolute',
  top: 0,
  left: 0,
  right: 0,
  height: 4,
  background: `linear-gradient(90deg, ${tokens.primary}, ${tokens.secondary})`,
};

const titleStyle = {
  fontSize: 13,
  fontWeight: 600,
  color: tokens.primary,
  letterSpacing: 0.5,
  marginBottom: 16,
  fontFamily: tokens.typography.fontFamily,
};

const textStyle = {
  fontSize: 22,
  fontWeight: 500,
  lineHeight: 1.7,
  color: tokens.onSurface,
  marginBottom: 16,
  fontFamily: tokens.typography.fontFamily,
  textAlign: 'center',
};

const sourceStyle = {
  fontSize: 14,
  color: tokens.onSurfaceVariant,
  fontFamily: tokens.typography.fontFamily,
  textAlign: 'center',
};

const typeBadgeStyle = (type) => ({
  display: 'inline-block',
  fontSize: 11,
  fontWeight: 600,
  padding: '4px 10px',
  borderRadius: shape.radiusFull,
  marginBottom: 12,
  fontFamily: tokens.typography.fontFamily,
  background: type === 'quran' ? tokens.primaryContainer : tokens.secondaryContainer,
  color: type === 'quran' ? tokens.onPrimaryContainer : tokens.onSecondaryContainer,
});

/** رسم البطاقة على Canvas وتصديرها كصورة (بدون html2canvas). */
function renderCardToBlob(wisdom, t, width = 600, height = 400) {
  return new Promise((resolve) => {
    const canvas = document.createElement('canvas');
    canvas.width = width;
    canvas.height = height;
    const ctx = canvas.getContext('2d');
    if (!ctx) {
      resolve(null);
      return;
    }
    const pad = 32;
    const title = t.zad.dailyWisdomTitle;
    const typeLabel = wisdom.type === 'quran' ? t.zad.wisdomTypeQuran : t.zad.wisdomTypeHadith;

    ctx.fillStyle = '#FAFDFC';
    ctx.fillRect(0, 0, width, height);

    const gradient = ctx.createLinearGradient(0, 0, width, 0);
    gradient.addColorStop(0, tokens.primary);
    gradient.addColorStop(1, tokens.secondary);
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, width, 4);

    ctx.fillStyle = tokens.primary;
    ctx.font = '600 14px "Noto Sans Arabic", sans-serif';
    ctx.textAlign = 'center';
    ctx.fillText(title, width / 2, 50);

    ctx.fillStyle = wisdom.type === 'quran' ? tokens.primaryContainer : tokens.secondaryContainer;
    ctx.fillRect(width / 2 - 60, 62, 120, 24);
    ctx.fillStyle = wisdom.type === 'quran' ? tokens.onPrimaryContainer : tokens.onSecondaryContainer;
    ctx.font = '600 12px "Noto Sans Arabic", sans-serif';
    ctx.fillText(typeLabel, width / 2, 78);

    ctx.fillStyle = tokens.onSurface;
    ctx.font = '500 22px "Noto Sans Arabic", sans-serif';
    ctx.textAlign = 'center';
    const lines = wisdom.text.match(/.{1,35}/g) || [wisdom.text];
    let y = 140;
    for (const line of lines) {
      ctx.fillText(line, width / 2, y);
      y += 36;
    }

    ctx.fillStyle = tokens.onSurfaceVariant;
    ctx.font = '14px "Noto Sans Arabic", sans-serif';
    ctx.fillText('— ' + wisdom.source, width / 2, y + 24);

    canvas.toBlob((blob) => resolve(blob), 'image/png');
  });
}

/**
 * بطاقة حكمة اليوم — تصميم جذاب قابل للمشاركة كصورة.
 */
export function DailyWisdomCard({ wisdom, onShare }) {
  const t = getStrings();
  const [sharing, setSharing] = useState(false);

  const handleShareAsImage = async () => {
    if (!wisdom) return;
    setSharing(true);
    try {
      const blob = await renderCardToBlob(wisdom, t);
      if (!blob) {
        setSharing(false);
        return;
      }
      const file = new File([blob], 'wisdom-of-the-day.png', { type: 'image/png' });
      if (typeof navigator !== 'undefined' && navigator.share && navigator.canShare?.({ files: [file] })) {
        await navigator.share({
          title: t.zad.dailyWisdomTitle,
          files: [file],
        });
      } else {
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'wisdom-of-the-day.png';
        a.click();
        URL.revokeObjectURL(url);
      }
      onShare?.();
    } catch {
      // ignore
    }
    setSharing(false);
  };

  if (!wisdom) return null;

  return (
    <div style={cardWrapStyle}>
      <div style={cardInnerStyle}>
        <div style={cardDecoStyle} />
        <p style={titleStyle}>{t.zad.dailyWisdomTitle}</p>
        <span style={typeBadgeStyle(wisdom.type)}>
          {wisdom.type === 'quran' ? t.zad.wisdomTypeQuran : t.zad.wisdomTypeHadith}
        </span>
        <p style={textStyle}>{wisdom.text}</p>
        <p style={sourceStyle}>— {wisdom.source}</p>
      </div>
      <div style={{ padding: 16, paddingTop: 12 }}>
        <AppButton
          variant="tonal"
          onClick={handleShareAsImage}
          disabled={sharing}
          style={{ width: '100%' }}
        >
          <AppIcon name="share" size={20} style={{ marginLeft: 8, verticalAlign: 'middle' }} />
          {sharing ? '...' : t.zad.shareAsImage}
        </AppButton>
      </div>
    </div>
  );
}
