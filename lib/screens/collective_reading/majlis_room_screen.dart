import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../generated/l10n/app_localizations.dart';
import '../../services/majlis_rooms_service.dart';
import '../../theme/app_theme.dart';
import 'collective_reading_screen.dart';

/// شاشة إنشاء مقرأة أو الانضمام بها برمز.
class MajlisRoomScreen extends StatefulWidget {
  const MajlisRoomScreen({
    super.key,
    this.isPublic = true,
  });

  final bool isPublic;

  @override
  State<MajlisRoomScreen> createState() => _MajlisRoomScreenState();
}

class _MajlisRoomScreenState extends State<MajlisRoomScreen> {
  final _codeController = TextEditingController();
  String? _pendingRoomId;
  bool _isPublic = true;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _createRoom() {
    setState(() {
      _pendingRoomId = const Uuid().v4();
      _isPublic = widget.isPublic;
    });
  }

  void _startAsTeacher() async {
    if (_pendingRoomId == null) return;
    final roomId = _pendingRoomId!;
    final user = Supabase.instance.client.auth.currentUser;
    final creatorId = user?.id;
    final creatorName = (user?.userMetadata?['full_name'] as String?) ??
        user?.email?.split('@').first ??
        AppLocalizations.of(context)!.teacherLabel;
    if (_isPublic) {
      try {
        await MajlisRoomsService.createRoom(
          roomId: roomId,
          creatorName: creatorName,
          creatorId: creatorId,
          isPublic: true,
        );
      } catch (_) {}
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => CollectiveReadingScreen(
          roomId: roomId,
          isTeacher: true,
          initialPage: 1,
        ),
      ),
    );
  }

  void _joinRoom(String roomId) {
    if (roomId.trim().isEmpty) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => CollectiveReadingScreen(
          roomId: roomId.trim().toLowerCase(),
          isTeacher: false,
          initialPage: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.gradientFor(Theme.of(context).brightness),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  l10n.collectiveReading,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: 32),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kShapeRadius),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_pendingRoomId == null) ...[
                          FilledButton.icon(
                            onPressed: _createRoom,
                            icon: const Icon(Icons.add_rounded),
                            label: Text(l10n.createRoom),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(kShapeRadius),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.joinRoom,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _codeController,
                            decoration: InputDecoration(
                              hintText: l10n.roomCode,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            textCapitalization: TextCapitalization.none,
                            autocorrect: false,
                          ),
                          const SizedBox(height: 12),
                          FilledButton.tonal(
                            onPressed: () => _joinRoom(_codeController.text),
                            child: Text(l10n.joinRoom),
                          ),
                        ] else ...[
                          SegmentedButton<bool>(
                            segments: [
                              ButtonSegment(
                                value: true,
                                label: Text(l10n.publicRoom),
                                icon: const Icon(Icons.public_rounded, size: 18),
                              ),
                              ButtonSegment(
                                value: false,
                                label: Text(l10n.privateRoom),
                                icon: const Icon(Icons.lock_rounded, size: 18),
                              ),
                            ],
                            selected: {_isPublic},
                            onSelectionChanged: (s) =>
                                setState(() => _isPublic = s.first),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.roomCode,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          SelectableText(
                            _pendingRoomId!,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _startAsTeacher,
                            icon: const Icon(Icons.school_rounded),
                            label: Text(l10n.teacherLabel),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(kShapeRadius),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => setState(() => _pendingRoomId = null),
                            child: Text(l10n.cancel),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
