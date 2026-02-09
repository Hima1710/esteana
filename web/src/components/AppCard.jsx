import { tokens, shape } from '../theme/tokens';

const cardStyle = {
  backgroundColor: tokens.surfaceContainerLowest,
  color: tokens.onSurface,
  borderRadius: shape.radiusMedium,
  padding: 16,
  boxShadow: '0 1px 3px rgba(0,0,0,0.08)',
  border: `1px solid ${tokens.outlineVariant}`,
};

/**
 * مكون كارت MD3 قابل لإعادة الاستخدام.
 * @param {{ children: React.ReactNode, style?: React.CSSProperties, as?: keyof JSX.IntrinsicElements }}
 */
export function AppCard({ children, style, as: Component = 'div', ...rest }) {
  return (
    <Component style={{ ...cardStyle, ...style }} {...rest}>
      {children}
    </Component>
  );
}
