import { NavLink } from 'react-router-dom';
import { getStrings } from '../constants/strings';
import { navIcons } from '../constants/icons';
import { tokens } from '../theme/tokens';
import { AppIcon } from '../components';

const navStyle = {
  position: 'fixed',
  bottom: 0,
  left: 0,
  right: 0,
  height: 80,
  backgroundColor: tokens.surfaceContainer,
  borderTop: `1px solid ${tokens.outlineVariant}`,
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-around',
  paddingBottom: 'env(safe-area-inset-bottom, 0)',
  zIndex: 100,
};

const linkStyle = {
  display: 'flex',
  flexDirection: 'column',
  alignItems: 'center',
  justifyContent: 'center',
  flex: 1,
  height: '100%',
  color: tokens.onSurfaceVariant,
  textDecoration: 'none',
  fontSize: 12,
  fontWeight: 500,
  fontFamily: tokens.typography.fontFamily,
};

const activeStyle = {
  ...linkStyle,
  color: tokens.primary,
};

const routes = [
  { path: '/', key: 'mihrab' },
  { path: '/athari', key: 'athari' },
  { path: '/zad', key: 'zad' },
  { path: '/settings', key: 'settings' },
];

export function BottomNavBar() {
  const t = getStrings();

  return (
    <nav style={navStyle} role="navigation" aria-label={t.nav.mihrab}>
      {routes.map(({ path, key }) => {
        const label = t.nav[key];
        return (
          <NavLink
            key={path}
            to={path}
            style={({ isActive }) => (isActive ? activeStyle : linkStyle)}
            end={path === '/'}
          >
            <AppIcon name={navIcons[key]} size={24} style={{ marginBottom: 4 }} />
            <span>{label}</span>
          </NavLink>
        );
      })}
    </nav>
  );
}
