import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../hooks/use_l10n.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_card.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../services/prayer_requests_service.dart';

/// التابة الثالثة — المجلس: طلبات الدعاء من Supabase، "اطلب الدعاء" و "دعوت لك".
class MajlisTab extends HookWidget {
  const MajlisTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();
    final stream = useMemoized(() => PrayerRequestsService.watchRequests());
    final snapshot = useStream(stream);
    final requests = snapshot.data ?? <PrayerRequestDto>[];
    final localPrayedIds = useState<Set<String>>({});
    final isLoading = !snapshot.hasData && snapshot.connectionState == ConnectionState.waiting;

    final gradient = AppGradients.gradientFor(Theme.of(context).brightness);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(gradient: gradient),
      child: SafeArea(
        child: CustomScrollView(
          cacheExtent: 400,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.majlis,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.95),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _PrayForMeIntro(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            _PrayerRequestsSliver(
              requests: requests,
              isLoading: isLoading,
              localPrayedIds: localPrayedIds.value,
              onLocalPrayed: (id) {
                localPrayedIds.value = {...localPrayedIds.value, id};
              },
              l10n: l10n,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _GroupChallengesSection(),
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

class _PrayForMeIntro extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();
    return AppCard(
      icon: Icons.favorite_rounded,
      title: l10n.prayForMe,
      subtitle: l10n.prayForMeHint,
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () {
            if (context.read<AuthProvider>().isGuest) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.loginRequired)),
              );
              return;
            }
            _showRequestPrayerDialog(context, l10n);
          },
          icon: const Icon(Icons.add_rounded),
          label: Text(l10n.requestPrayer),
        ),
      ),
    );
  }

  void _showRequestPrayerDialog(BuildContext context, AppLocalizations l10n) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.requestPrayer),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: l10n.prayForMeHint,
            border: const OutlineInputBorder(),
          ),
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              final text = controller.text.trim();
              if (text.isEmpty) return;
              Navigator.pop(ctx);
              await PrayerRequestsService.addRequest(text);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.requestPrayer)),
                );
              }
            },
            child: Text(l10n.submit),
          ),
        ],
      ),
    );
  }
}

class _PrayerRequestsSliver extends StatelessWidget {
  const _PrayerRequestsSliver({
    required this.requests,
    required this.isLoading,
    required this.localPrayedIds,
    required this.onLocalPrayed,
    required this.l10n,
  });

  final List<PrayerRequestDto> requests;
  final bool isLoading;
  final Set<String> localPrayedIds;
  final void Function(String id) onLocalPrayed;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isLoading) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator(color: colorScheme.primary)),
        ),
      );
    }
    if (requests.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  l10n.prayForMeHint,
                  style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final r = requests[index];
            final displayIPrayed = r.iPrayed || localPrayedIds.contains(r.id);
            return RepaintBoundary(
              key: ValueKey(r.id),
              child: _PrayerRequestCard(
                dto: r,
                displayIPrayed: displayIPrayed,
                iPrayedLabel: l10n.iPrayed,
                onIPrayed: () async {
                  onLocalPrayed(r.id);
                  await PrayerRequestsService.markPrayed(r.id);
                },
              ),
            );
          },
          childCount: requests.length,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
        ),
      ),
    );
  }
}

class _PrayerRequestCard extends StatelessWidget {
  static final _shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius));

  const _PrayerRequestCard({
    required this.dto,
    required this.displayIPrayed,
    required this.iPrayedLabel,
    required this.onIPrayed,
  });

  final PrayerRequestDto dto;
  final bool displayIPrayed;
  final String iPrayedLabel;
  final VoidCallback onIPrayed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: _shape,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dto.text,
                    style: TextStyle(fontSize: 15, color: colorScheme.onSurface),
                  ),
                  if (dto.prayedCount > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${dto.prayedCount}',
                      style: TextStyle(fontSize: 12, color: colorScheme.primary),
                    ),
                  ],
                ],
              ),
            ),
            if (!displayIPrayed)
              TextButton.icon(
                onPressed: onIPrayed,
                icon: const Icon(Icons.favorite_rounded, size: 18),
                label: Text(iPrayedLabel),
                style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconTheme(data: IconThemeData(size: 18, color: colorScheme.primary), child: const Icon(Icons.check_circle_rounded)),
                  const SizedBox(width: 6),
                  Text(iPrayedLabel, style: TextStyle(fontSize: 12, color: colorScheme.primary)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _GroupChallengesSection extends HookWidget {
  const _GroupChallengesSection();

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.groupChallenges,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.95),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
          child: Column(
            children: [
              ListTile(
                leading: IconTheme(
                  data: IconThemeData(color: Theme.of(context).colorScheme.primary),
                  child: const Icon(Icons.groups_rounded),
                ),
                title: Text(l10n.joinReading),
                subtitle: Text(l10n.joinReadingHint),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: IconTheme(
                  data: IconThemeData(color: Theme.of(context).colorScheme.primary),
                  child: const Icon(Icons.emoji_events_rounded),
                ),
                title: Text(l10n.dhikrChallenge),
                subtitle: Text(l10n.dhikrChallengeHint),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
