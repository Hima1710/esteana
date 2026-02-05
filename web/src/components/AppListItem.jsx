import { tokens, shape } from '../theme/tokens';

const listItemStyle = {
  display: 'flex',
  alignItems: 'center',
  minHeight: 56,
  paddingLeft: 16,
  paddingRight: 16,
  paddingTop: 8,
  paddingBottom: 8,
  backgroundColor: tokens.surfaceContainerLowest,
  color: tokens.onSurface,
  fontFamily: tokens.typography.fontFamily,
  fontSize: 16,
  borderBottom: `1px solid ${tokens.outlineVariant}`,
};

const leadingStyle = {
  marginLeft: 16,
  marginRight: 16,
  flexShrink: 0,
};

const headlineStyle = {
  fontWeight: 500,
  marginBottom: 2,
};

const supportingStyle = {
  fontSize: 14,
  color: tokens.onSurfaceVariant,
};

/**
 * عنصر قائمة MD3 (رأس + نص داعم + اختياري: leading/trailing).
 * @param {{ headline: React.ReactNode, supporting?: React.ReactNode, leading?: React.ReactNode, trailing?: React.ReactNode, style?: React.CSSProperties, onClick?: () => void }}
 */
export function AppListItem({
  headline,
  supporting,
  leading,
  trailing,
  style,
  onClick,
  ...rest
}) {
  const isInteractive = typeof onClick === 'function';
  return (
    <div
      role={isInteractive ? 'button' : undefined}
      tabIndex={isInteractive ? 0 : undefined}
      onKeyDown={isInteractive ? (e) => e.key === 'Enter' && onClick() : undefined}
      onClick={onClick}
      style={{
        ...listItemStyle,
        cursor: isInteractive ? 'pointer' : 'default',
        ...style,
      }}
      {...rest}
    >
      {leading && <span style={leadingStyle}>{leading}</span>}
      <span style={{ flex: 1, minWidth: 0 }}>
        <div style={headlineStyle}>{headline}</div>
        {supporting != null && <div style={supportingStyle}>{supporting}</div>}
      </span>
      {trailing != null && <span style={{ marginRight: 8, flexShrink: 0 }}>{trailing}</span>}
    </div>
  );
}
