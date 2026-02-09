import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_plus/share_plus.dart';

import '../../theme/app_theme.dart';
import '../../hooks/use_l10n.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../data/zad_dummy_data.dart';

/// التابة الرابعة — زاد: مقولة اليوم مع مشاركة، Short Clips تمرير رأسي (Reels).
class ZadTab extends HookWidget {
  const ZadTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();
    final gradient = AppGradients.gradientFor(Theme.of(context).brightness);
    final quote = useMemoized(() => getDailyQuoteForToday());

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(gradient: gradient),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: _DailyQuoteCard(l10n: l10n, quote: quote),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _ShortClipsReels(l10n: l10n, clips: kShortClips),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyQuoteCard extends StatelessWidget {
  const _DailyQuoteCard({required this.l10n, required this.quote});

  final AppLocalizations l10n;
  final String quote;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card.filled(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.format_quote_rounded, color: colorScheme.primary, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.dailyWisdom,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface.withValues(alpha: 0.95),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    quote,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSurface.withValues(alpha: 0.9),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: colorScheme.primaryContainer.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(kShapeRadius),
              child: InkWell(
                onTap: () => Share.share(
                  '$quote\n— ${l10n.appTitle}',
                  subject: l10n.dailyWisdom,
                ),
                borderRadius: BorderRadius.circular(kShapeRadius),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.share_rounded, size: 20, color: colorScheme.onPrimaryContainer),
                      const SizedBox(width: 6),
                      Text(
                        l10n.share,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShortClipsReels extends HookWidget {
  const _ShortClipsReels({required this.l10n, required this.clips});

  final AppLocalizations l10n;
  final List<ShortClipItem> clips;

  @override
  Widget build(BuildContext context) {
    final fullHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom + 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            l10n.shortClips,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.95),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: clips.length,
            itemBuilder: (context, index) {
              return RepaintBoundary(
                key: ValueKey(index),
                child: _ClipReelTile(
                  clip: clips[index],
                  index: index,
                  height: fullHeight,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ClipReelTile extends StatelessWidget {
  const _ClipReelTile({required this.clip, required this.index, required this.height});

  final ShortClipItem clip;
  final int index;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kShapeRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: colorScheme.surfaceContainerHighest,
              child: Center(
                child: Icon(
                  Icons.play_circle_filled_rounded,
                  size: 72,
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clip.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      clip.description,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
