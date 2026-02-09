import { tokens, shape } from '../theme/tokens';

const baseStyle = {
  fontFamily: tokens.typography.fontFamily,
  fontWeight: 500,
  fontSize: 14,
  letterSpacing: 0.1,
  border: 'none',
  cursor: 'pointer',
  borderRadius: shape.radiusFull,
  padding: '10px 24px',
  minHeight: 40,
  display: 'inline-flex',
  alignItems: 'center',
  justifyContent: 'center',
  transition: 'background-color 0.2s, box-shadow 0.2s',
};

const variants = {
  filled: {
    backgroundColor: tokens.primary,
  },
  tonal: {
    backgroundColor: tokens.primaryContainer,
    color: tokens.onPrimaryContainer,
  },
  outlined: {
    backgroundColor: 'transparent',
    color: tokens.primary,
    border: `1px solid ${tokens.outline}`,
  },
  text: {
    backgroundColor: 'transparent',
    color: tokens.primary,
  },
};

/**
 * زر MD3 (Filled / Tonal / Outlined / Text).
 * @param {{ children: React.ReactNode, variant?: 'filled'|'tonal'|'outlined'|'text', style?: React.CSSProperties, type?: 'button'|'submit', disabled?: boolean } & React.ButtonHTMLAttributes<HTMLButtonElement>}
 */
export function AppButton({
  children,
  variant = 'filled',
  style,
  type = 'button',
  disabled,
  ...rest
}) {
  const variantStyle = variants[variant] ?? variants.filled;
  const color = variant === 'filled' || variant === 'tonal' ? undefined : variantStyle.color;
  return (
    <button
      type={type}
      disabled={disabled}
      style={{
        ...baseStyle,
        ...variantStyle,
        color: color ?? tokens.onPrimary,
        opacity: disabled ? 0.38 : 1,
        ...style,
      }}
      {...rest}
    >
      {children}
    </button>
  );
}
