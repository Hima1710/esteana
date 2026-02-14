import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n/app_localizations.dart';
import '../../hooks/use_l10n.dart';
import '../../providers/auth_provider.dart';
import '../../services/majlis_rooms_service.dart';
import '../../theme/app_theme.dart';
import 'collective_reading_screen.dart';
import 'majlis_room_screen.dart';

/// شاشة استكشاف المقرآت: عرض المقارئ النشطة + إنشاء أو انضمام برمز.
class MajlisDiscoverScreen extends HookWidget {
  const MajlisDiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();
    context.watch<AuthProvider>();
    final rooms = useState<List<MajlisRoomDto>>([]);
    final loading = useState(true);
    final error = useState<String?>(null);

    Future<void> loadRooms() async {
      loading.value = true;
      error.value = null;
      try {
        rooms.value = await MajlisRoomsService.fetchActiveRooms();
      } catch (e) {
        error.value = e.toString();
      }
      loading.value = false;
    }

    useEffect(() {
      loadRooms();
      return null;
    }, []);

    void navigateToCreate() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const MajlisRoomScreen()),
      ).then((_) => loadRooms());
    }

    void navigateToJoinWithCode() {
      showDialog(
        context: context,
        builder: (ctx) => _JoinCodeDialog(
          l10n: l10n,
          onJoin: (String code) async {
            final room = await MajlisRoomsService.getRoomByShortCode(code);
            final roomId = room?.roomId ?? code;
            if (!ctx.mounted) return;
            Navigator.of(ctx).pop();
            if (!context.mounted) return;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => CollectiveReadingScreen(
                  roomId: roomId,
                  isTeacher: false,
                  initialPage: 1,
                ),
              ),
            );
          },
        ),
      );
    }

    void joinRoom(MajlisRoomDto room) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => CollectiveReadingScreen(
            roomId: room.roomId,
            isTeacher: false,
            initialPage: 1,
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.gradientFor(Theme.of(context).brightness),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ثابت في الأعلى: إنشاء مقرأة أو انضم برمز
              Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.createOrJoin,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: navigateToCreate,
                      icon: const Icon(Icons.add_rounded),
                      label: Text(l10n.createRoom),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kShapeRadius),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton.tonal(
                      onPressed: navigateToJoinWithCode,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kShapeRadius),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.key_rounded),
                          const SizedBox(width: 8),
                          Text(l10n.joinRoom),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // قابل للتمرير: المقارئ النشطة
              Expanded(
                child: RefreshIndicator(
                  onRefresh: loadRooms,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SectionTitle(title: l10n.activeReadingSessions),
                        const SizedBox(height: 12),
                        if (loading.value)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (error.value != null)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                error.value!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          )
                        else if (rooms.value.isEmpty)
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(kShapeRadius),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.campaign_outlined,
                                      size: 48,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      l10n.noActiveSessions,
                                      style: Theme.of(context).textTheme.bodyLarge,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else
                          ...rooms.value.map(
                            (r) => _RoomCard(
                              room: r,
                              l10n: l10n,
                              onTap: () => joinRoom(r),
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
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(l10n.collectiveReading),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({
    required this.room,
    required this.l10n,
    required this.onTap,
  });

  final MajlisRoomDto room;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kShapeRadius),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(Icons.menu_book_rounded, color: colorScheme.onPrimaryContainer),
        ),
        title: Text(
          '${l10n.collectiveReading} — ${room.creatorName}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Row(
          children: [
            Chip(
              label: Text(
                room.isPublic ? l10n.publicRoom : l10n.privateRoom,
                style: const TextStyle(fontSize: 11),
              ),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 8),
            Text(
              room.shortCode ?? (room.roomId.length >= 8 ? room.roomId.substring(0, 8) : room.roomId),
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class _JoinCodeDialog extends StatefulWidget {
  const _JoinCodeDialog({
    required this.l10n,
    required this.onJoin,
  });

  final AppLocalizations l10n;
  final Future<void> Function(String code) onJoin;

  @override
  State<_JoinCodeDialog> createState() => _JoinCodeDialogState();
}

class _JoinCodeDialogState extends State<_JoinCodeDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.l10n.joinRoom),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.l10n.roomCode,
          border: const OutlineInputBorder(),
        ),
        textCapitalization: TextCapitalization.none,
        autocorrect: false,
        onSubmitted: (_) async {
          final code = _controller.text.trim();
          if (code.isEmpty) return;
          await widget.onJoin(code.toLowerCase());
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.l10n.cancel),
        ),
        FilledButton(
          onPressed: () async {
            final code = _controller.text.trim();
            if (code.isEmpty) return;
            await widget.onJoin(code.toLowerCase());
          },
          child: Text(widget.l10n.joinRoom),
        ),
      ],
    );
  }
}
