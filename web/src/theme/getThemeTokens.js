/**
 * ثيمات MD3 Teal: Light, Dark, Sepia.
 * تُستخدم في المصحف والإعدادات.
 */
const light = {
  primary: '#006A6A',
  onPrimary: '#FFFFFF',
  primaryContainer: '#6FF7F6',
  onPrimaryContainer: '#002020',
  surface: '#FAFDFC',
  onSurface: '#191C1C',
  surfaceContainer: '#EEF0EF',
  onSurfaceVariant: '#3F4948',
  outline: '#6F7979',
  outlineVariant: '#BEC9C8',
  background: '#FAFDFC',
  onBackground: '#191C1C',
};

const dark = {
  primary: '#4CDADA',
  onPrimary: '#003737',
  primaryContainer: '#004F4F',
  onPrimaryContainer: '#6FF7F6',
  surface: '#191C1C',
  onSurface: '#E0E3E2',
  surfaceContainer: '#2D3131',
  onSurfaceVariant: '#BEC9C8',
  outline: '#899392',
  outlineVariant: '#3F4948',
  background: '#191C1C',
  onBackground: '#E0E3E2',
};

const sepia = {
  primary: '#006A6A',
  onPrimary: '#FFFFFF',
  primaryContainer: '#6FF7F6',
  onPrimaryContainer: '#002020',
  surface: '#F5F0E6',
  onSurface: '#1F1B16',
  surfaceContainer: '#EBE6DC',
  onSurfaceVariant: '#4F4539',
  outline: '#6F6560',
  outlineVariant: '#CAC4BC',
  background: '#F5F0E6',
  onBackground: '#1F1B16',
};

/**
 * @param {'light'|'dark'|'sepia'} theme
 * @returns {typeof light}
 */
export function getThemeTokens(theme) {
  if (theme === 'dark') return dark;
  if (theme === 'sepia') return sepia;
  return light;
}

export { light, dark, sepia };
