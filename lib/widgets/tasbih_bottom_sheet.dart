import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';

import '../generated/l10n/app_localizations.dart';
import '../services/tasbih_storage_service.dart';

/// Dark emerald background for the sheet.
const Color _kSheetBackground = Color(0xFF013220);

/// Inner bead (slightly darker so golden border reads as glowing thread).
const Color _kInnerBead = Color(0xFF012210);

/// Champagne gold for counter text.
const Color _kChampagneGold = Color(0xFFFDEBB2);

/// Semi-transparent gold for reset control.
const Color _kResetGold = Color(0xB3FDB931);

/// Golden border gradient: [#BF953F, #FCF6BA, #B38728].
final List<Color> _kBorderGradientColors = [
  const Color(0xFFBF953F),
  const Color(0xFFFCF6BA),
  const Color(0xFFB38728),
];

/// Opens the Tasbih (electronic rosary) as a modal bottom sheet.
/// العداد يُحمّل ويُحفظ محلياً (Isar) وفي Supabase إن كان المستخدم مسجلاً.
void showTasbihBottomSheet(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final height = MediaQuery.sizeOf(context).height * 0.4;
  final isar = context.read<Isar>();

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      height: height,
      decoration: const BoxDecoration(
        color: _kSheetBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: _TasbihContent(l10n: l10n, isar: isar),
    ),
  );
}

/// عداد التسبيح — يُحمّل من التخزين المحلي/السحابي ويُحفظ عند كل ضغطة أو إعادة تعيين.
class _TasbihContent extends StatefulWidget {
  const _TasbihContent({
    required this.l10n,
    required this.isar,
  });

  final AppLocalizations l10n;
  final Isar isar;

  @override
  State<_TasbihContent> createState() => _TasbihContentState();
}

class _TasbihContentState extends State<_TasbihContent> {
  int _count = 0;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    getTasbihCountToday(widget.isar).then((c) {
      if (mounted) setState(() { _count = c; _loaded = true; });
    });
  }

  Future<void> _increment() async {
    HapticFeedback.lightImpact();
    setState(() => _count++);
    await saveTasbihCountToday(widget.isar, _count);
  }

  Future<void> _reset() async {
    HapticFeedback.lightImpact();
    setState(() => _count = 0);
    await saveTasbihCountToday(widget.isar, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _loaded ? _increment : null,
          child: Column(
            children: [
              const _DragHandle(),
              Expanded(
                child: Center(
                  child: _loaded
                      ? _Bead(count: _count)
                      : const SizedBox(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: _kChampagneGold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 12,
          right: 16,
          child: IconButton(
            onPressed: _loaded ? _reset : null,
            icon: Icon(Icons.refresh_rounded, color: _kResetGold, size: 24),
            style: IconButton.styleFrom(
              minimumSize: const Size(40, 40),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: _kResetGold.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

class _Bead extends StatelessWidget {
  const _Bead({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: CustomPaint(
        painter: _BeadPainter(),
        child: Center(
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 60,
              color: _kChampagneGold,
              fontWeight: FontWeight.w300,
              fontFamily: 'sans-serif',
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints inner dark circle + 1.5px golden gradient ring (no shadow/blur).
class _BeadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final innerRect = rect.deflate(1.5);

    canvas.drawCircle(rect.center, rect.shortestSide / 2 - 1.5, Paint()..color = _kInnerBead);

    final ringPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addOval(rect)
      ..addOval(innerRect);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: _kBorderGradientColors,
      ).createShader(rect);
    canvas.drawPath(ringPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
