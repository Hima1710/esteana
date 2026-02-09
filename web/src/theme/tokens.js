/**
 * Material Design 3 — باليت Teal (أخضر غامق مريح).
 * مرجع: MD3 color roles (primary, onPrimary, surface, outline, etc.)
 */
export const tokens = {
  // Primary — Teal غامق مريح
  primary: '#006A6A',
  onPrimary: '#FFFFFF',
  primaryContainer: '#6FF7F6',
  onPrimaryContainer: '#002020',

  // Secondary — تكميلي هادئ
  secondary: '#4A6363',
  onSecondary: '#FFFFFF',
  secondaryContainer: '#CCE8E7',
  onSecondaryContainer: '#051F1F',

  // Tertiary
  tertiary: '#4B607C',
  onTertiary: '#FFFFFF',
  tertiaryContainer: '#D3E4FD',
  onTertiaryContainer: '#041C35',

  // Surface (خلفيات)
  surface: '#FAFDFC',
  onSurface: '#191C1C',
  surfaceVariant: '#DAE5E4',
  onSurfaceVariant: '#3F4948',

  // Background
  background: '#FAFDFC',
  onBackground: '#191C1C',

  // Outline
  outline: '#6F7979',
  outlineVariant: '#BEC9C8',

  // Error
  error: '#BA1A1A',
  onError: '#FFFFFF',
  errorContainer: '#FFDAD6',
  onErrorContainer: '#410002',

  // Inverse (للعناصر المعكوسة)
  inverseSurface: '#2D3131',
  inverseOnSurface: '#EFF1F0',
  inversePrimary: '#4CDADA',

  // Elevation (للظلال والكروت)
  surfaceDim: '#DADBD9',
  surfaceBright: '#FAFDFC',
  surfaceContainerLowest: '#FFFFFF',
  surfaceContainerLow: '#F4F6F6',
  surfaceContainer: '#EEF0EF',
  surfaceContainerHigh: '#E8EAE9',
  surfaceContainerHighest: '#E3E4E3',

  // Scrim
  scrim: '#000000',

  // Shadow
  shadow: '#000000',

  /** الخطوط — متوافق مع MD3 ودعم العربية */
  typography: {
    fontFamily: '"Noto Sans Arabic", "Noto Kufi Arabic", system-ui, "Segoe UI", sans-serif',
    fontFamilyDisplay: '"Noto Sans Arabic", "Noto Kufi Arabic", system-ui, sans-serif',
  },
};

/** قيم إضافية للاستخدام في المكونات (نصف قطر، ارتفاعات، إلخ) */
export const shape = {
  radiusSmall: 8,
  radiusMedium: 12,
  radiusLarge: 16,
  radiusFull: 9999,
};

export const elevation = {
  level0: 0,
  level1: 1,
  level2: 2,
  level3: 3,
};
