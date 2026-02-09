import { getStrings } from '../../constants/strings';
import { onboardingIcons } from '../../constants/icons';
import { tokens, shape } from '../../theme/tokens';
import { AppIcon } from '../../components';

const containerStyle = {
  padding: 24,
  maxWidth: 400,
  margin: '0 auto',
  textAlign: 'center',
};

const headlineStyle = {
  fontSize: 22,
  fontWeight: 600,
  color: tokens.onSurface,
  marginBottom: 8,
};

const sublineStyle = {
  fontSize: 15,
  color: tokens.onSurfaceVariant,
  marginBottom: 32,
};


const cardStyle = {
  padding: 20,
  marginBottom: 12,
  borderRadius: shape.radiusMedium,
  border: `2px solid ${tokens.outlineVariant}`,
  backgroundColor: tokens.surfaceContainerLowest,
  color: tokens.onSurface,
  cursor: 'pointer',
  fontSize: 16,
  fontWeight: 500,
  width: '100%',
  boxShadow: '0 1px 3px rgba(0,0,0,0.06)',
  transition: 'border-color 0.2s, background-color 0.2s, box-shadow 0.2s',
};

/**
 * شاشة Onboarding لاختيار الفئة العمرية.
 */
export function AgeOnboarding({ onSelect }) {
  const t = getStrings();
  const o = t.athari.onboarding;
  const labels = { child: o.ageChild, both: o.ageTeen, adult: o.ageAdult };

  const handleChoose = (ageGroup) => {
    onSelect(ageGroup);
  };

  return (
    <div style={containerStyle}>
      <h1 style={headlineStyle}>{o.headline}</h1>
      <p style={sublineStyle}>{o.subline}</p>
      {['child', 'both', 'adult'].map((ageGroup) => (
        <button
          key={ageGroup}
          type="button"
          style={cardStyle}
          onClick={() => handleChoose(ageGroup)}
          onMouseDown={(e) => {
            e.currentTarget.style.backgroundColor = tokens.primaryContainer;
            e.currentTarget.style.borderColor = tokens.primary;
          }}
          onMouseUp={(e) => {
            e.currentTarget.style.backgroundColor = tokens.surfaceContainerLowest;
            e.currentTarget.style.borderColor = tokens.outlineVariant;
          }}
          onMouseLeave={(e) => {
            e.currentTarget.style.backgroundColor = tokens.surfaceContainerLowest;
            e.currentTarget.style.borderColor = tokens.outlineVariant;
          }}
        >
          <AppIcon name={onboardingIcons[ageGroup]} size={28} style={{ display: 'block', marginBottom: 8 }} />
          {labels[ageGroup]}
        </button>
      ))}
      <p style={{ marginTop: 24, fontSize: 13, color: tokens.outline }}>
        {o.changeLater}
      </p>
    </div>
  );
}
