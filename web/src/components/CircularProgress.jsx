import { tokens } from '../theme/tokens';

/**
 * مؤشر تحميل دائري بأسلوب Material Design 3.
 */
export function CircularProgress({ size = 48, strokeWidth = 3, style = {} }) {
  const r = (size - strokeWidth) / 2;
  const c = 2 * Math.PI * r;
  return (
    <div
      style={{
        width: size,
        height: size,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        ...style,
      }}
      role="progressbar"
      aria-label="جاري التحميل"
    >
      <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}>
        <circle
          cx={size / 2}
          cy={size / 2}
          r={r}
          fill="none"
          stroke={tokens.outlineVariant}
          strokeWidth={strokeWidth}
        />
        <circle
          cx={size / 2}
          cy={size / 2}
          r={r}
          fill="none"
          stroke={tokens.primary}
          strokeWidth={strokeWidth}
          strokeDasharray={`${c * 0.25} ${c * 0.75}`}
          strokeLinecap="round"
          style={{ transform: `rotate(-90deg)`, transformOrigin: 'center', animation: 'circularProgressSpin 0.8s linear infinite' }}
        />
      </svg>
      <style>{`
        @keyframes circularProgressSpin {
          to { transform: rotate(-90deg) rotate(360deg); }
        }
      `}</style>
    </div>
  );
}
