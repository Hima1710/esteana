import { Outlet } from 'react-router-dom';
import { BottomNavBar } from './BottomNavBar';
import { tokens } from '../theme/tokens';

const layoutStyle = {
  minHeight: '100vh',
  backgroundColor: tokens.background,
  color: tokens.onBackground,
  fontFamily: tokens.typography.fontFamily,
  paddingBottom: 96,
};

export function AppLayout() {
  return (
    <div style={layoutStyle}>
      <main>
        <Outlet />
      </main>
      <BottomNavBar />
    </div>
  );
}
