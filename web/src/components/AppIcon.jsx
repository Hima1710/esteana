/**
 * أيقونة Material Symbols (MD3) بالاسم.
 * الاسم من: https://fonts.google.com/icons
 * @param {{ name: string, size?: number, fill?: boolean, style?: React.CSSProperties, className?: string }}
 */
export function AppIcon({ name, size = 24, fill = false, style, className = '' }) {
  return (
    <span
      className={`material-symbols-outlined ${className}`}
      style={{
        fontVariationSettings: fill ? "'FILL' 1" : "'FILL' 0",
        fontSize: size,
        ...style,
      }}
      aria-hidden
    >
      {name}
    </span>
  );
}
