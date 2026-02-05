import { memo, useCallback, useState, useRef, useEffect } from 'react';
import { getStrings } from '../../constants/strings';
import { getThemeTokens } from '../../theme/getThemeTokens';
import { shape } from '../../theme/tokens';
import { VerseActionsBottomSheet } from './VerseActionsBottomSheet';
import { saveLastQuranPosition, addHeartTouched, removeHeartTouched, isHeartTouched } from '../../db/database';

/** خط المصحف: Amiri أو Scheherazade New */
const QURAN_FONT = '"Amiri Quran", "Scheherazade New", "Amiri", "Traditional Arabic", serif';

const VERSE_ESTIMATE_HEIGHT = 72;
const VERSE_BUFFER = 6;

/**
 * عرض سورة بنظام Text Flow (نص متصل كالمصحف) مع windowing.
 * عند النقر على آية: BottomSheet (علامة مرجعية، قلب، وضع التسميع).
 */
export const SurahView = memo(function SurahView({
  surah,
  ayahs,
  fontSize = 22,
  themeKey = 'light',
  hifzMode = false,
  onHifzModeChange,
  themeTokens,
}) {
  const t = getStrings();
  const [selectedAyah, setSelectedAyah] = useState(null);
  const [sheetOpen, setSheetOpen] = useState(false);
  const [heartActiveMap, setHeartActiveMap] = useState({});
  const [revealedInHifz, setRevealedInHifz] = useState(new Set());
  const containerRef = useRef(null);
  const [scrollTop, setScrollTop] = useState(0);
  const [containerHeight, setContainerHeight] = useState(400);
  const totalHeight = ayahs.length * VERSE_ESTIMATE_HEIGHT;

  const openSheet = useCallback((ayah) => {
    setSelectedAyah(ayah);
    setSheetOpen(true);
  }, []);

  const handleBookmark = useCallback(() => {
    if (!selectedAyah || !surah) return;
    saveLastQuranPosition(surah.number, selectedAyah.numberInSurah);
  }, [selectedAyah, surah]);

  const toggleHeart = useCallback(async () => {
    if (!selectedAyah || !surah) return;
    const key = `${surah.number}-${selectedAyah.numberInSurah}`;
    const isActive = heartActiveMap[key] ?? false;
    if (isActive) {
      await removeHeartTouched(surah.number, selectedAyah.numberInSurah);
      setHeartActiveMap((m) => ({ ...m, [key]: false }));
    } else {
      await addHeartTouched({ surahNumber: surah.number, ayahNumber: selectedAyah.numberInSurah, text: selectedAyah.text });
      setHeartActiveMap((m) => ({ ...m, [key]: true }));
    }
  }, [selectedAyah, surah, heartActiveMap]);

  const handleVerseClick = useCallback((ayah) => {
    if (hifzMode) setRevealedInHifz((s) => new Set(s).add(ayah.number));
    setSelectedAyah(ayah);
    setSheetOpen(true);
  }, [hifzMode]);

  const handleScroll = useCallback(() => {
    if (containerRef.current) setScrollTop(containerRef.current.scrollTop);
  }, []);

  useEffect(() => {
    const el = containerRef.current;
    if (!el) return;
    setContainerHeight(el.clientHeight);
    const ro = new ResizeObserver(() => setContainerHeight(el.clientHeight));
    ro.observe(el);
    return () => ro.disconnect();
  }, []);

  useEffect(() => {
    if (!selectedAyah || !surah) return;
    isHeartTouched(surah.number, selectedAyah.numberInSurah).then((active) =>
      setHeartActiveMap((m) => ({ ...m, [`${surah.number}-${selectedAyah.numberInSurah}`]: active }))
    );
  }, [selectedAyah, surah]);

  const start = Math.max(0, Math.floor(scrollTop / VERSE_ESTIMATE_HEIGHT) - VERSE_BUFFER);
  const end = Math.min(ayahs.length, Math.ceil((scrollTop + containerHeight) / VERSE_ESTIMATE_HEIGHT) + VERSE_BUFFER);
  const visible = ayahs.slice(start, end);
  const offsetY = start * VERSE_ESTIMATE_HEIGHT;
  const theme = themeTokens ?? getThemeTokens(themeKey);

  return (
    <>
      <div
        ref={containerRef}
        onScroll={handleScroll}
        style={{
          flex: 1,
          overflow: 'auto',
          minHeight: 200,
          direction: 'rtl',
          fontFamily: QURAN_FONT,
          fontSize: fontSize,
          lineHeight: 2,
          color: theme.onSurface,
          background: theme.background,
        }}
      >
        <div style={{ height: totalHeight, position: 'relative' }}>
          <div
            style={{
              position: 'absolute',
              left: 0,
              right: 0,
              top: offsetY,
              padding: '8px 12px',
            }}
          >
            {visible.map((ayah) => {
              const key = `${surah?.number}-${ayah.numberInSurah}`;
              const heartActive = heartActiveMap[key];
              const revealed = !hifzMode || revealedInHifz.has(ayah.number);
              return (
                <button
                  key={ayah.number}
                  type="button"
                  onClick={() => handleVerseClick(ayah)}
                  style={{
                    display: 'block',
                    width: '100%',
                    padding: '10px 0',
                    marginBottom: 4,
                    border: 'none',
                    background: 'none',
                    cursor: 'pointer',
                    textAlign: 'right',
                    fontFamily: QURAN_FONT,
                    fontSize: fontSize,
                    lineHeight: 2,
                    color: theme.onSurface,
                    opacity: revealed ? 1 : 0.02,
                    transition: 'opacity 0.2s',
                  }}
                >
                  <span style={{ color: theme.primary, fontWeight: 600, marginLeft: 8 }}>{ayah.numberInSurah}</span>
                  {' '}
                  {ayah.text}
                </button>
              );
            })}
          </div>
        </div>
      </div>

      <VerseActionsBottomSheet
        open={sheetOpen}
        onClose={() => setSheetOpen(false)}
        onBookmark={handleBookmark}
        onHeartTouched={toggleHeart}
        heartActive={selectedAyah ? (heartActiveMap[`${surah?.number}-${selectedAyah?.numberInSurah}`] ?? false) : false}
        hifzMode={hifzMode}
        onHifzModeChange={onHifzModeChange}
        themeTokens={theme}
      />
    </>
  );
});
