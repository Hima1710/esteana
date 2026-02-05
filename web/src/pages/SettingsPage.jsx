import { getStrings } from '../constants/strings';
import { tokens } from '../theme/tokens';
import { AppCard, AppListItem } from '../components';

export function SettingsPage() {
  const t = getStrings();
  return (
    <div style={{ padding: 16 }}>
      <h1 style={{ marginBottom: 4 }}>{t.settings.title}</h1>
      <p style={{ color: tokens.onSurfaceVariant, marginBottom: 24, fontSize: 14 }}>{t.settings.subtitle}</p>
      <AppCard>
        <AppListItem headline={t.settings.profileItem} supporting={t.settings.profileItemSupporting} />
        <AppListItem headline={t.settings.notificationsItem} supporting={t.settings.notificationsItemSupporting} />
      </AppCard>
    </div>
  );
}
