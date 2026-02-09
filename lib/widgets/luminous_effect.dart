import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// وحدة مسؤولة عن تأثير الكرة النورانية والاهتزاز — قابلة للاستدعاء من أي زر تفاعلي.
class LuminousEffect {
  LuminousEffect._();

  /// يشغّل هزّة خفيفة ثم يعرض كرة نورانية تتحرك للأعلى وتتلاشى في الـ Overlay.
  static void trigger(BuildContext context) {
    HapticFeedback.lightImpact();
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _LuminousOrbOverlay(
        onComplete: () {
          entry.remove();
        },
      ),
    );
    overlay.insert(entry);
  }
}

class _LuminousOrbOverlay extends StatefulWidget {
  const _LuminousOrbOverlay({required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<_LuminousOrbOverlay> createState() => _LuminousOrbOverlayState();
}

class _LuminousOrbOverlayState extends State<_LuminousOrbOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward(from: 0).then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final dy = -180.0 * _controller.value;
          final opacity = 1.0 - _controller.value;
          return Transform.translate(
            offset: Offset(0, dy),
            child: Center(
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.6),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                    gradient: RadialGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withValues(alpha: 0.4),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
