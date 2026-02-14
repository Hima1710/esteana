import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../services/luminous_service.dart';
import '../theme/app_theme.dart';
import '../utils/locale_digits.dart';

/// صندوق نوراني طافي يظهر في كل الصفحات، مع تأثير نبض عند استقبال القطع.
class LuminousFloatingBox extends HookWidget {
  const LuminousFloatingBox({super.key});

  @override
  Widget build(BuildContext context) {
    // distinct() يقلل إعادة البناء وضغط BLASTBufferQueue على أندرويد
    final totalStream = useMemoized(() => LuminousService.watchTotal().distinct());
    final snapshot = useStream(totalStream);
    final total = snapshot.data ?? 0;
    final pulseTrigger = useMemoized(() => LuminousService.pulseTrigger);
    useListenable(pulseTrigger);
    final pulseController = useAnimationController(duration: const Duration(milliseconds: 600));
    final scale = useAnimationController(duration: const Duration(milliseconds: 400));

    useEffect(() {
      if (pulseTrigger.value > 0) {
        pulseController.forward(from: 0);
        scale.forward(from: 0).then((_) => scale.reverse());
      }
      return null;
    }, [pulseTrigger.value]);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // لا نستخدم Positioned هنا لأن الودجت يُلفّ بـ RepaintBoundary في MainScreen؛
    // Positioned يجب أن يكون ابناً مباشراً لـ Stack فاستبدلناه بـ Align + Padding.
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 100),
        child: IgnorePointer(
          child: AnimatedBuilder(
            animation: Listenable.merge([pulseController, scale]),
            builder: (context, _) {
              final pulseGlow = 4.0 + 8.0 * pulseController.value * (1 - pulseController.value);
              final scaleVal = 1.0 + 0.15 * scale.value * (1 - scale.value);
              return Transform.scale(
                scale: scaleVal,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kShapeRadius),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.5),
                        blurRadius: pulseGlow,
                        spreadRadius: 1,
                      ),
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primaryContainer,
                        colorScheme.primary.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lightbulb_rounded, color: colorScheme.onPrimaryContainer, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        total.toString().toLocaleDigits(Localizations.localeOf(context)),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
