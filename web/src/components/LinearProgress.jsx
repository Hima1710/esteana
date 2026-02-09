import { tokens, shape } from '../theme/tokens';

const trackStyle = {
  height: 4,
  borderRadius: shape.radiusFull,
  backgroundColor: tokens.surfaceContainerHighest,
  overflow: 'hidden',
};

const fillStyle = {
  height: '100%',
  borderRadius: shape.radiusFull,
  backgroundColor: tokens.primary,
  transition: 'width 0.3s ease',
};

/**
 * شريط تقدم خطي MD3.
 * @param {{ value: number, max?: number, style?: React.CSSProperties }}
 */
export function LinearProgress({ value, max = 100, style }) {
  const pct = Math.min(100, Math.max(0, (Number(value) / Number(max)) * 100));
  return (
    <div style={{ ...trackStyle, ...style }} role="progressbar" aria-valuenow={value} aria-valuemin={0} aria-valuemax={max}>
      <div style={{ ...fillStyle, width: `${pct}%` }} />
    </div>
  );
}
