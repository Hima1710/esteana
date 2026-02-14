import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:isar/isar.dart';

import '../../config/jitsi_config.dart';
import 'jitsi_auto_media_listener.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../hooks/use_l10n.dart';
import '../../hooks/use_isar.dart';
import '../../models/mushaf_surah.dart';
import '../../providers/auth_provider.dart';
import '../../providers/call_state_provider.dart';
import '../../quran/quran_provider.dart';
import '../../services/assignments_service.dart';
import '../../services/majlis_realtime_service.dart';
import '../../services/majlis_rooms_service.dart';
import '../../services/mushaf_storage_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_route_observer.dart';
import '../../widgets/mushaf_teacher_toolbar.dart'
    show isAssignmentColor, assignmentTypeFromColor, MushafTeacherToolbar;
import '../../widgets/mushaf_surah_drawer.dart';
import 'interactive_mushaf_view.dart';

/// شاشة المقرأة الجماعية: مصحف تفاعلي (أداة الإدارة الرئيسية) + مكالمة Jitsi.
/// تزامن المصحف عبر Supabase Realtime Broadcast. سيرفر Jitsi من [JitsiConfig].
class CollectiveReadingScreen extends HookWidget {
  const CollectiveReadingScreen({
    super.key,
    required this.roomId,
    this.isTeacher = false,
    this.initialPage = 1,
  });

  final String roomId;
  final bool isTeacher;
  final int initialPage;

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();
    context.watch<AuthProvider>();
    final user = Supabase.instance.client.auth.currentUser;
    final guestId = useMemoized(() => const Uuid().v4(), []);
    final myId = user?.id ?? guestId;
    final myName = (user?.userMetadata?['full_name'] as String?) ??
        user?.email?.split('@').first ??
        (isTeacher ? l10n.teacherLabel : l10n.studentLabel);
    final quran = useMemoized(() => QuranApiProvider(), []);
    final realtime = useMemoized(() => MajlisRealtimeService(roomId: roomId), [roomId]);
    final storageReady = useState(false);
    useEffect(() {
      MushafStorageService.ensureInit().then((_) => storageReady.value = true);
      return null;
    }, []);
    final pageController = usePageController(
      initialPage: (initialPage - 1).clamp(0, quran.totalPages - 1),
    );
    final currentPage = useState(initialPage.clamp(1, quran.totalPages));
    final controllerUserId = useState<String?>(null);
    final controllerName = useState<String>(l10n.teacherLabel);
    final participants = useState<List<ParticipantPayload>>([]);
    final currentVerseKey = useState<String?>(null);
    final pastVerseKeys = useState<Set<String>>({});
    final highlightColor = useState<Color?>(null);
    final highlightedRectsByPage = useState<Map<int, List<Map<String, double>>>>({});
    final isJoined = useState(false);
    final initialPageFromDbApplied = useRef(false);
    final showColorToolbar = useState(false);
    final toolbarPosition = useState<Offset?>(null);
    final isar = useIsar();
    final surahs = useState<List<MushafSurah>>([]);
    final callState = context.read<CallState>();

    useEffect(() {
      callState.setOnMajlisPage(true);
      return () => callState.setOnMajlisPage(false);
    }, [callState]);

    void reassertTeacherControl() {
      if (isTeacher) {
        controllerUserId.value = myId;
        controllerName.value = myName;
        realtime.broadcastControlTransfer(ControlTransferPayload(
          controllerUserId: myId,
          controllerName: myName,
        ));
      }
    }

    useEffect(() {
      late final WidgetsBindingObserver observer;
      observer = _AppLifecycleReconnect(
        onResumed: () {
          realtime.reconnect(onSubscribed: reassertTeacherControl);
        },
      );
      WidgetsBinding.instance.addObserver(observer);
      return () => WidgetsBinding.instance.removeObserver(observer);
    }, [realtime]);

    useEffect(() {
      void loadSurahs() async {
        final list = await isar.mushafSurahs.where().sortBySurahNumber().findAll();
        surahs.value = list;
      }
      loadSurahs();
      return null;
    }, [isar]);

    useEffect(() {
      if (initialPageFromDbApplied.value) return;
      void load() async {
        final page = await MajlisRoomsService.getCurrentPage(roomId);
        if (page != null && page >= 1 && page <= quran.totalPages) {
          initialPageFromDbApplied.value = true;
          currentPage.value = page;
          if (pageController.hasClients) {
            pageController.jumpToPage((page - 1).clamp(0, quran.totalPages - 1));
          }
        }
      }
      load();
      return null;
    }, [roomId, quran.totalPages]);

    useEffect(() {
      void onPage(int page) {
        currentPage.value = page;
        if (pageController.hasClients) {
          pageController.jumpToPage((page - 1).clamp(0, quran.totalPages - 1));
        }
      }
      final sub1 = realtime.pageStream.listen(onPage);
      final sub2 = realtime.verseHighlightStream.listen((p) {
        if (p.status == 'current') {
          final old = currentVerseKey.value;
          if (old != null && old != p.verseKey) {
            pastVerseKeys.value = {...pastVerseKeys.value, old};
          }
          currentVerseKey.value = p.verseKey;
        } else if (p.status == 'past') {
          pastVerseKeys.value = {...pastVerseKeys.value, p.verseKey};
        }
      });
      final sub3 = realtime.controlTransferStream.listen((p) {
        controllerUserId.value = p.controllerUserId;
        controllerName.value = p.controllerName;
      });
      final sub4 = realtime.participantsStream.listen((list) {
        participants.value = list;
        if (controllerUserId.value == null && list.isNotEmpty) {
          final teacher = list.where((p) => p.isTeacher).firstOrNull;
          if (teacher != null) {
            controllerUserId.value = teacher.userId;
            controllerName.value = teacher.displayName;
          }
        }
      });
      return () {
        sub1.cancel();
        sub2.cancel();
        sub3.cancel();
        sub4.cancel();
      };
    }, [realtime]);

    useEffect(() {
      realtime.join(
        userId: myId,
        displayName: myName,
        isTeacher: isTeacher,
        onSubscribed: () {
          if (isTeacher) {
            controllerUserId.value = myId;
            controllerName.value = myName;
            realtime.broadcastControlTransfer(ControlTransferPayload(
              controllerUserId: myId,
              controllerName: myName,
            ));
          }
        },
      );
      isJoined.value = true;
      return () => realtime.leave();
    }, [realtime]);

    void goToPage(int page) {
      final p = page.clamp(1, quran.totalPages);
      currentPage.value = p;
      if (pageController.hasClients) {
        pageController.jumpToPage((p - 1).clamp(0, quran.totalPages - 1));
      }
      if (controllerUserId.value == myId) {
        realtime.broadcastPageChange(p, myId);
        MajlisRoomsService.updateCurrentPage(roomId: roomId, page: p);
      }
    }

    void highlightVerse(String verseKey, String status) {
      if (controllerUserId.value != myId) return;
      realtime.broadcastVerseHighlight(VerseHighlightPayload(
        page: currentPage.value,
        verseKey: verseKey,
        status: status,
        fromUserId: myId,
      ));
    }

    void giveControlTo(String userId, String displayName) {
      if (controllerUserId.value != myId) return;
      controllerUserId.value = userId;
      controllerName.value = displayName;
      realtime.broadcastControlTransfer(ControlTransferPayload(
        controllerUserId: userId,
        controllerName: displayName,
      ));
    }

    Future<void> endReading() async {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.endReading),
          content: Text(l10n.endReadingConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n.done),
            ),
          ],
        ),
      );
      if (ok != true || !context.mounted) return;
      try {
        await MajlisRoomsService.endAndLogSession(
          roomId: roomId,
          endedByUserId: myId,
          endedByName: myName,
          participantsCount: participants.value.length,
          lastPage: currentPage.value,
        );
      } catch (_) {}
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.readingEnded)),
      );
      Navigator.of(context).pop();
    }

    Future<void> launchJitsi() async {
      // طلب أذونات الميكروفون والكاميرا صراحة قبل بدء الجلسة (أندرويد 14+ يربط المؤشر الأخضر بنوع الخدمة والأذونات عند التشغيل).
      debugPrint('[Jitsi] Requesting microphone permission…');
      final mic = await Permission.microphone.request();
      debugPrint('[Jitsi] Microphone: granted=${mic.isGranted}, denied=${mic.isDenied}, permanentlyDenied=${mic.isPermanentlyDenied}');
      debugPrint('[Jitsi] Requesting camera permission…');
      final cam = await Permission.camera.request();
      debugPrint('[Jitsi] Camera: granted=${cam.isGranted}, denied=${cam.isDenied}, permanentlyDenied=${cam.isPermanentlyDenied}');
      if (!mic.isGranted || !cam.isGranted) {
        debugPrint('[Jitsi] Aborting join: missing permission (mic=${mic.isGranted}, cam=${cam.isGranted})');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                mic.isGranted
                    ? l10n.cameraPermissionRequired
                    : l10n.microphonePermissionRequired,
              ),
            ),
          );
        }
        return;
      }

      try {
        final authUser = Supabase.instance.client.auth.currentUser;
      final meta = authUser?.userMetadata;
      final googleEmail = authUser?.email ?? '';
      final displayNameFromAuth = (meta?['full_name'] as String?) ??
          (googleEmail.isNotEmpty ? googleEmail.split('@').first : null) ??
          myName;
      final avatarUrl = (meta != null && meta['avatar_url'] != null)
          ? (meta['avatar_url'] as String?)
          : null;
      final effectiveAvatar = (avatarUrl != null && avatarUrl.isNotEmpty)
          ? avatarUrl
          : null;

      final roomName = 'esteana-majlis-$roomId-${roomId.replaceAll("-", "")}';

      // سيرفر FSF (jitsi.member.fsf.org) لا يدعم JWT — المعلم يدخل كـ Guest ببياناته (الاسم/الصورة) فقط
      const String? token = null;
      // if (isTeacher && authUser != null) {
      //   try {
      //     final res = await Supabase.instance.client.functions.invoke(
      //       'jitsi-teacher-token',
      //       body: {
      //         'room': roomName,
      //         'displayName': displayNameFromAuth,
      //         'email': googleEmail,
      //         'avatar': effectiveAvatar,
      //         'userId': authUser.id,
      //       },
      //     );
      //     final data = res.data as Map<String, dynamic>?;
      //     if (data != null && data['token'] != null) {
      //       token = data['token'] as String;
      //       debugPrint('[Jitsi] teacher token obtained');
      //     }
      //   } catch (e) {
      //     debugPrint('[Jitsi] teacher token failed: $e');
      //   }
      // }

      final userInfo = JitsiMeetUserInfo(
        displayName: displayNameFromAuth,
        email: googleEmail,
        avatar: effectiveAvatar,
      );

      // لغة واجهة Jitsi حسب لغة التطبيق (عربي / إنجليزي)
      final appLocale = Localizations.localeOf(context);
      final jitsiLang = appLocale.languageCode == 'ar' ? 'ar' : 'en';

      final configOverrides = <String, Object?>{
        'startWithAudioMuted': false,
        'startWithVideoMuted': false,
        'disableSimulcast': true,
        'enableLayerSuspension': false,
        'resolution': 360,
        'videoCodec': 'VP8',
        'disableH264': true,
        'channelLastN': -1,
        'p2p': <String, Object>{'enabled': true},
        'subject': l10n.collectiveReading,
        'startWithLobbyEnabled': false,
        'defaultLanguage': jitsiLang,
        'prejoinPageEnabled': false,
      };

      // تعطيل الـ lobby عند استخدام meet.jit.si للاختبار (سيرفر FSF لا يدعم lobby.enabled ويظهر تحذير إن مُرّر).
      final featureFlags = JitsiConfig.serverUrl.contains('meet.jit.si')
          ? <String, Object?>{'lobby.enabled': false}
          : null;

      debugPrint('[Jitsi] isTeacher: $isTeacher, hasToken: ${token != null}, room: $roomName');

      final options = JitsiMeetConferenceOptions(
        room: roomName,
        serverURL: JitsiConfig.serverUrl,
        token: token,
        userInfo: userInfo,
        configOverrides: configOverrides,
        featureFlags: featureFlags,
      );
      final baseListener = JitsiMeetEventListener(
        conferenceWillJoin: (url) {
          debugPrint('[Jitsi] conferenceWillJoin: $url');
        },
        conferenceJoined: (url) async {
          debugPrint('[Jitsi] conferenceJoined: $url');
          callState.setInCall(true);
        },
        conferenceTerminated: (url, error) async {
          debugPrint('[Jitsi] conferenceTerminated: url=$url, error=$error');
          callState.setInCall(false);
        },
        readyToClose: () async {
          debugPrint('[Jitsi] readyToClose');
          callState.setInCall(false);
        },
        participantJoined: (email, name, role, participantId) async {
          debugPrint('[Jitsi] participantJoined: $name ($participantId) role=$role');
        },
        audioMutedChanged: (muted) {
          debugPrint('[Jitsi] audioMutedChanged: muted=$muted (الميكروفون ${muted ? "مكتوم" : "يعمل"})');
        },
        videoMutedChanged: (muted) => callState.setVideoMuted(muted),
      );
      final listener = JitsiAutoMediaListener.wrapWithAutoMedia(baseListener);
      debugPrint('[Jitsi] Calling JitsiMeet().join()…');
      JitsiMeet().join(options, listener);
      debugPrint('[Jitsi] join() returned (واجهة Jitsi تفتح في طبقة منفصلة)');
      } catch (e, st) {
        debugPrint('[Jitsi] Error launching Jitsi: $e');
        debugPrint('[Jitsi] Stack trace: $st');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطأ في فتح المكالمة: $e')),
          );
        }
      }
    }

    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final call = context.watch<CallState>();

    return _MajlisRouteAware(
      onBecameCurrent: () => realtime.reconnect(onSubscribed: reassertTeacherControl),
      child: Scaffold(
      drawer: surahs.value.isEmpty
          ? null
          : MushafSurahDrawer(
              surahs: surahs.value,
              isArabic: isAr,
              searchHint: l10n.searchSurahOrVerse,
              onSurahSelected: goToPage,
            ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.gradientFor(Theme.of(context).brightness),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.pageOf(currentPage.value, quran.totalPages),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (controllerUserId.value == myId)
                      Chip(
                        avatar: const Icon(Icons.person, size: 16, color: Colors.teal),
                        label: Text(l10n.youAreController, style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.teal.withValues(alpha: 0.2),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      )
                    else
                      Text(
                        '${l10n.controllerLabel}: ${controllerName.value}',
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    InteractiveMushafView(
                      quran: quran,
                      pageController: pageController,
                      currentPage: currentPage,
                      onPageChanged: goToPage,
                      currentVerseKey: currentVerseKey.value,
                      pastVerseKeys: pastVerseKeys.value,
                      onVerseTap: controllerUserId.value == myId
                          ? (vk, status) => highlightVerse(vk, status)
                          : null,
                      canControl: controllerUserId.value == myId,
                      highlightColor: highlightColor.value,
                      highlightedRectsByPage: highlightedRectsByPage.value,
                      drawingMode: showColorToolbar.value,
                      onAddRect: controllerUserId.value == myId
                          ? (pageNumber, rect) {
                              final key = pageNumber;
                              final list = List<Map<String, double>>.from(highlightedRectsByPage.value[key] ?? []);
                              list.add(Map<String, double>.from(rect));
                              highlightedRectsByPage.value = {...highlightedRectsByPage.value, key: list};
                            }
                          : null,
                    ),
                    if (controllerUserId.value == myId) ...[
                      _DraggableToolbar(
                        visible: showColorToolbar.value,
                        toolbarPosition: toolbarPosition.value,
                        onPositionChanged: (p) => toolbarPosition.value = p,
                        screenSize: MediaQuery.sizeOf(context),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MushafTeacherToolbar(
                              selectedColor: highlightColor.value,
                              onColorSelected: (c) => highlightColor.value = c,
                            ),
                            if (isAssignmentColor(highlightColor.value)) ...[
                              const SizedBox(height: 8),
                              FilledButton.icon(
                                onPressed: () => _showSaveAssignmentDialog(
                                  context,
                                  participants: participants.value,
                                  myId: myId,
                                  pageNumber: currentPage.value,
                                  assignmentType: assignmentTypeFromColor(highlightColor.value)!,
                                  coordinates: highlightedRectsByPage.value[currentPage.value],
                                  l10n: l10n,
                                ),
                                icon: const Icon(Icons.save_rounded, size: 20),
                                label: Text(l10n.saveAssignmentForStudent),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(kShapeRadius),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: FloatingActionButton.small(
                          heroTag: null,
                          onPressed: () => showColorToolbar.value = !showColorToolbar.value,
                          child: Icon(
                            Icons.brush_rounded,
                            color: showColorToolbar.value
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      endDrawer: _ParticipantsDrawer(
        participants: participants.value,
        controllerUserId: controllerUserId.value,
        myId: myId,
        isTeacher: isTeacher,
        onGiveControl: giveControlTo,
        l10n: l10n,
      ),
      appBar: AppBar(
        toolbarHeight: 48,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          l10n.collectiveReading,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Builder(
            builder: (scaffoldContext) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CallAppBarButton(
                  isInCall: call.isInCall,
                  isVideoMuted: call.isVideoMuted,
                  isTeacher: isTeacher,
                  l10n: l10n,
                  onPressed: () => launchJitsi(),
                ),
                if (surahs.value.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.menu_book_rounded, size: 22),
                    tooltip: l10n.mushafIndex,
                    onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
                  ),
                IconButton(
                  icon: const Icon(Icons.people_rounded, size: 22),
                  onPressed: () => Scaffold.of(scaffoldContext).openEndDrawer(),
                ),
                IconButton(
                  icon: const Icon(Icons.flag_rounded, size: 22),
                  tooltip: l10n.endReading,
                  onPressed: endReading,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}

class _MajlisRouteAware extends StatefulWidget {
  const _MajlisRouteAware({required this.onBecameCurrent, required this.child});

  final VoidCallback onBecameCurrent;
  final Widget child;

  @override
  State<_MajlisRouteAware> createState() => _MajlisRouteAwareState();
}

class _MajlisRouteAwareState extends State<_MajlisRouteAware> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is ModalRoute<void> && route.isCurrent) {
      appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    widget.onBecameCurrent();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _DraggableToolbar extends StatefulWidget {
  const _DraggableToolbar({
    required this.visible,
    required this.toolbarPosition,
    required this.onPositionChanged,
    required this.screenSize,
    required this.child,
  });

  final bool visible;
  final Offset? toolbarPosition;
  final void Function(Offset) onPositionChanged;
  final Size screenSize;
  final Widget child;

  @override
  State<_DraggableToolbar> createState() => _DraggableToolbarState();
}

class _DraggableToolbarState extends State<_DraggableToolbar> {
  static const double _kDefaultLeft = 20;
  static const double _kMinPadding = 8;
  static const double _kToolbarWidth = 320;
  static const double _kToolbarHeight = 180;

  Offset get _defaultOffset => Offset(
        _kDefaultLeft,
        widget.screenSize.height - _kToolbarHeight - 80,
      );

  Offset get _currentOffset => widget.toolbarPosition ?? _defaultOffset;

  void _onPanUpdate(DragUpdateDetails d) {
    final maxX = widget.screenSize.width - _kToolbarWidth - _kMinPadding;
    final maxY = widget.screenSize.height - _kToolbarHeight - _kMinPadding;
    widget.onPositionChanged(Offset(
      (_currentOffset.dx + d.delta.dx).clamp(_kMinPadding, maxX),
      (_currentOffset.dy + d.delta.dy).clamp(_kMinPadding, maxY),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.visible) return const SizedBox.shrink();
    return Positioned(
      left: _currentOffset.dx,
      top: _currentOffset.dy,
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(kShapeRadius),
        child: GestureDetector(
          onPanUpdate: _onPanUpdate,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow.withValues(alpha: 0.98),
              borderRadius: BorderRadius.circular(kShapeRadius),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

Future<void> _showSaveAssignmentDialog(
  BuildContext context, {
  required List<ParticipantPayload> participants,
  required String myId,
  required int pageNumber,
  required String assignmentType,
  List<Map<String, double>>? coordinates,
  required AppLocalizations l10n,
}) async {
  final students = participants.where((p) => p.userId != myId).toList();
  if (students.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noStudentsToAssign)),
      );
    }
    return;
  }
  if (!context.mounted) return;
  final selected = await showModalBottomSheet<ParticipantPayload>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.selectStudent,
              style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ...students.map((p) => ListTile(
                leading: CircleAvatar(
                  child: Text(p.displayName.isNotEmpty ? p.displayName[0] : '?'),
                ),
                title: Text(p.displayName),
                subtitle: p.isTeacher ? Text(l10n.teacherLabel) : Text(l10n.studentLabel),
                onTap: () => Navigator.of(ctx).pop(p),
              )),
        ],
      ),
    ),
  );
  if (selected == null || !context.mounted) return;
  try {
    final coords = (coordinates != null && coordinates.isNotEmpty)
        ? {'regions': coordinates}
        : {'fullPage': true};
    await insertAssignment(
      studentId: selected.userId,
      teacherId: myId,
      type: assignmentType,
      pageNumber: pageNumber,
      coordinates: coords,
      title: '$assignmentType — صفحة $pageNumber',
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.assignmentSaved)),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    }
  }
}

class _CallAppBarButton extends StatelessWidget {
  const _CallAppBarButton({
    required this.isInCall,
    required this.isVideoMuted,
    required this.isTeacher,
    required this.l10n,
    required this.onPressed,
  });

  final bool isInCall;
  final bool isVideoMuted;
  final bool isTeacher;
  final AppLocalizations l10n;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final IconData icon = isInCall
        ? (isVideoMuted ? Icons.mic_rounded : Icons.videocam_rounded)
        : Icons.videocam_rounded;
    final String tooltip = isInCall
        ? (isVideoMuted ? 'مكالمة صوتية' : 'مكالمة فيديو')
        : (isTeacher ? l10n.startVideoCall : l10n.joinVideoCall);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(icon, size: 22),
          tooltip: tooltip,
          onPressed: onPressed,
        ),
        if (isInCall)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.green.shade500,
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.surface, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.6),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _ParticipantsDrawer extends StatelessWidget {
  const _ParticipantsDrawer({
    required this.participants,
    required this.controllerUserId,
    required this.myId,
    required this.isTeacher,
    required this.onGiveControl,
    required this.l10n,
  });

  final List<ParticipantPayload> participants;
  final String? controllerUserId;
  final String myId;
  final bool isTeacher;
  final void Function(String userId, String displayName) onGiveControl;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.participants,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: participants.isEmpty
                  ? Center(
                      child: Text(
                        l10n.noResults,
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    )
                  : ListView.builder(
                      itemCount: participants.length,
                      itemBuilder: (ctx, i) {
                        final p = participants[i];
                        final isController = controllerUserId == p.userId;
                        final canGiveControl = controllerUserId == myId && p.userId != myId && isTeacher;
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(p.displayName.isNotEmpty ? p.displayName[0] : '?'),
                          ),
                          title: Row(
                            children: [
                              Expanded(child: Text(p.displayName)),
                              if (isController)
                                Icon(Icons.star_rounded, size: 18, color: colorScheme.primary),
                            ],
                          ),
                          subtitle: p.isTeacher ? Text(l10n.teacherLabel) : null,
                          trailing: canGiveControl
                              ? TextButton.icon(
                                  onPressed: () => onGiveControl(p.userId, p.displayName),
                                  icon: const Icon(Icons.handshake_rounded, size: 18),
                                  label: Text(l10n.giveControl),
                                )
                              : null,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// يستمع لدورة حياة التطبيق ويعيد الاتصال بـ Realtime عند العودة من الخلفية.
class _AppLifecycleReconnect extends WidgetsBindingObserver {
  _AppLifecycleReconnect({this.onResumed});

  final VoidCallback? onResumed;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) onResumed?.call();
  }
}
